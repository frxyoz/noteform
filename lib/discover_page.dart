import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class DiscoverPage extends StatefulWidget{

  @override
  State createState() => _State();

}

class _State extends State<DiscoverPage>{

  final int sessionStartTime = DateTime.now().millisecondsSinceEpoch;

  // Server Variables
  final url = 'https://piano-tracker.onrender.com/checkhands';
  int delayTime = 10;
  Timer? timer;


  // Camera Variables
  List<CameraDescription>? cameras;
  CameraController? cameraController;
  XFile? cameraImage;

  // Status Variables
  ValueNotifier<int> handsStatus = ValueNotifier<int>(-1);
  ValueNotifier<int> correctHandsStatus = ValueNotifier<int>(-1);
  ValueNotifier<int> failedFingersStatus = ValueNotifier<int>(-1);


  @override
  void initState(){
    super.initState();
    loadCamera();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    if (cameraController != null){
      cameraController!.dispose();
    }

    timer?.cancel();
    super.dispose();
  }



  void loadCamera() async {
    cameras = await availableCameras();
    if(cameras != null){
      cameraController = CameraController(
          cameras![0],
          ResolutionPreset.medium
      );

      cameraController!.initialize().then(
        (value){
          if(!mounted){
            return;
          }
          setState(() {});
        }
      ).catchError((Object e) {
        if (e is CameraException) {
          print(e.code);
          switch (e.code) {
            case 'CameraAccessDenied':
            // Handle access errors here.
              break;
            default:
            // Handle other errors here.
              break;
          }
        }
      });
      ;

    }
    else{
      print("NO CAMERAS");
    }
  }

  Widget statDisplayWidget(String label, ValueNotifier<int> notifier){
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: ( context, value, _ ){
        String labelStatus = '';
        if(value < 0){
          labelStatus = 'n/a';
        }
        else{
          labelStatus = '$value';
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(labelStatus)
          ],
        );
      }
    );
  }


  Widget pianoStatsWidget(){
    return StatefulBuilder(
      builder: (sbContext, sbSetState){

        int numHands = 1;
        int numCorrectHands = 0;
        int numFailedFingers = 3;

        return Column(
          children: [
            statDisplayWidget('# Hands Found', handsStatus),
            statDisplayWidget('# Correct Hands', correctHandsStatus),
            statDisplayWidget('# Failed Fingers', failedFingersStatus),
          ],
        );
      }
    );
  }


  Future<XFile?> takePicture() async{
    print('called takePicture()');
    if(cameraController == null){
      print('cameraController is null');
      return null;
    }
    if(cameraController!.value.isTakingPicture){
      print('Currently take a photo');
      return null;
    }

    try{
      print('Trying to Take a photo');


      print('lock focus and exposure');
      await cameraController!.setFocusMode(FocusMode.locked);
      await cameraController!.setExposureMode(ExposureMode.locked);

      print('await Take a photo');
      XFile file = await cameraController!.takePicture();

      print('unlock focus and exposure');
      await cameraController!.setFocusMode(FocusMode.auto);
      await cameraController!.setExposureMode(ExposureMode.auto);

      return file;
    }
    catch (e){
      print('error in  takePicture()');
      print(e);
      return null;
    }
  }

  Future<void> takePictureAndUpload() async{
    print('called takePictureAndUpload()');
    try{
      print('awating takePicture()');
      XFile? image = await takePicture();
      if(image != null){
        print('image not null');
        String imagePath = image.path;
        print(imagePath);
        await serverRequest(imagePath);
      }
      else{
        print('image is null');
      }
    }
    catch (e){
      print('error in takePictureAndUpload()');

      print(e);
    }
  }

  Future<void> serverRequest(String imagePath) async {
    try{
      Uri uri = Uri.parse(url);

      http.MultipartRequest request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      http.StreamedResponse response = await request.send();
      var responseBytes = await response.stream.toBytes();
      var responseString = utf8.decode(responseBytes);
      var jsonResponse = jsonDecode(responseString);
      // print(responseString);
      print(jsonResponse);

      handsStatus.value = jsonResponse['NumHandsFound'];
      correctHandsStatus.value = jsonResponse['NumHandsCorrect'];

      int failedFingerCount = jsonResponse['FailedFingers0'].length + jsonResponse['FailedFingers1'].length;
      failedFingersStatus.value = failedFingerCount;

    }
    catch (e) {
      print(e);
      // var rng = Random();
      handsStatus.value = -1;
      correctHandsStatus.value = -1;
      failedFingersStatus.value = -1;
    }

    uploadDataToFirebase();
  }


  void uploadDataToFirebase() async {
    print('uploadDataToFirebase');
    String uid = FirebaseAuth.instance.currentUser!.uid;
    int currentTimeStamp = DateTime.now().millisecondsSinceEpoch;
    String refPath = "sessiondata/$uid/$sessionStartTime/$currentTimeStamp";

    Map<String, dynamic> uploadData = {
      "handsStatus": handsStatus.value,
      "correctHandsStatus": correctHandsStatus.value,
      "failedFingersStatus": failedFingersStatus.value,
    };

    await FirebaseDatabase.instance.ref(refPath).update(uploadData);
  }


  Widget cameraPreviewWidget(){
    return Column(
      children: [
        CameraPreview(cameraController!),
        pianoStatsWidget(),
      ],
    );
  }

  Widget discoverBodyWidget(){
    if(cameraController == null){
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Text('Initializing Camera...')
          ],
        ),
      );
    }
    return cameraPreviewWidget();
  }

  @override
  Widget build(context){

    if(cameraController != null && cameraController!.value.isInitialized) {
      print('setting up timer camera');
      if(timer == null){
        print('timer was null');
        timer = Timer.periodic(
            Duration(seconds: delayTime),
                (Timer t) async {
              print('Timer.periodic');
              await takePictureAndUpload();
            }
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Discover'),),
      body: discoverBodyWidget(),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.camera),
      //   onPressed: takePictureAndUpload
      // ),
    );
  }

}