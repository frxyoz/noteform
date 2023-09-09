import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "dart:convert";
import "page6.dart";
import "page7.dart";
import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import "user_simple_preferences.dart";
import "package:path_provider/path_provider.dart";

class python_test extends StatefulWidget {
  const python_test({super.key, required this.title, required this.value, required this.camera});
  final String title;
  final String value;
  final CameraDescription camera;


  @override
  State<python_test> createState() => _python_testState();
}

class _python_testState extends State<python_test> {
  late String data;

  Future<void> _getLatest() async{
    try{
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      var request = http.MultipartRequest("POST", Uri.https("piano-tracker.onrender.com", "/checkhands"));
      var pic = http.MultipartFile.fromBytes(
          "image",
          File(image.path).readAsBytesSync(),
          filename: "img.jpg", contentType: MediaType.parse("multipart/form-data")
      );
      request.files.add(pic);
      var streamedResponse = await request.send();
      final response = await streamedResponse.stream.bytesToString();
      writeData(response);
      data = response;
      print(data);
    } catch(e){
      print(e);
    }
  }
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );
    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }
  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print('$path/data.json');
    return File('$path/data.json');
  }

  Future<File> writeData(String object) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString(object);
  }

  Future<String> readData() async {
    try {
      final file = await _localFile;
      // Read the file
      final contents = await file.readAsString();
      print(contents);
      return contents;
    } catch (e) {
      // If encountering an error, return empty map
      return "";
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body:
      FutureBuilder<void>(
        future: Future.wait<void>([
          _initializeControllerFuture,
          _getLatest(),
        ]),
        builder: (context, snapshot){
          List<Widget> children = <Widget>[];
          if(snapshot.hasData){
            if(snapshot.connectionState == ConnectionState.done){
              // var result = jsonDecode("${data}");
              var result = {};
              readData().then((value){
                result = jsonDecode(value);
                print(result);
                print(result["NumHandsFound"]);
              });
              children = <Widget>[
                Container(
                    padding: const EdgeInsets.fromLTRB(0,0,0,0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,

                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(0,0,0,22),
                            child: CameraPreview(_controller),
                          ),
                          Text('# Hands Found: '
                              '${result["NumHandsFound"]}',
                              style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
                          Text('# Correct Hands: '
                              '${result["NumHandsCorrect"]}',
                              style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
                          Text('Failed Fingers: '
                              '${result["FailedFingers0"]}',
                              style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children:
                            [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(18,32,18,18),
                                child: ElevatedButton(
                                  child: const Text("Home"),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => Page6(
                                            title: "Home Page", value: widget.value, camera: widget.camera))
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(18,18,18,18),
                                child: ElevatedButton(
                                  child: const Text("Discover"),
                                  style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.black45),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                            python_test(title: "Discover", value: widget.value, camera: widget.camera))
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(18,18,18,18),
                                child: ElevatedButton(
                                  child: const Text("Account"),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                            Page7(title: "Account Page", value: widget.value, camera: widget.camera))
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        ]))
              ];
            }
          } else if (snapshot.hasError){
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
            ];
          } else{
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              ),
            ];
          }
          return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              )
          );
        },
      ),

    );
  }
}
