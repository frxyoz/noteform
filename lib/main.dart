import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:camera/camera.dart';
import 'GlobalData.dart';
import 'home_page.dart';
import "login_page.dart";
import "python_test.dart";
import "user_simple_preferences.dart";

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // final cameras = await availableCameras();
  // GlobalData.cameras = cameras;

  await UserSimplePreferences.init();
  runApp( MyApp() );
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white24),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Piano Tracker Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void navigateToLoginScreen(){
    if( FirebaseAuth.instance.currentUser == null){
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage())
      );
    }
    else{
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (route) => false
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const Text("Welcome to Piano Tracker", style: TextStyle(fontSize: 50), textAlign: TextAlign.center,),
            ElevatedButton(
              child: const Text("Login", style: TextStyle(fontSize: 32),),
              onPressed: navigateToLoginScreen
            ),
          ],
        ),
      ),

    );
  }
}
