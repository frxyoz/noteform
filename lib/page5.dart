import 'package:flutter/material.dart';
import "page6.dart";
import 'package:camera/camera.dart';


class Page5 extends StatefulWidget {
  const Page5({super.key, required this.title, required this.camera});
  final String title;
  final CameraDescription camera;




  @override
  State<Page5> createState() => _Page5State();
}

class _Page5State extends State<Page5> {
  late String username;

  @override
  Widget build(BuildContext context) {
    const color1 = Color(0xff126827);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black12,
          title: const Text("Login Page"),
        ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Input Username'
              ),
              onSubmitted: (String name) {
                username = name;
              },
            ),
            const SizedBox(height: 30),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your password'
              ),
              onSubmitted: (String pass) {
                print("Password set!");
              },
            ),
          ElevatedButton(
            child: const Text("Submit"),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  Page6(title:"Home Page", value : username, camera: widget.camera))
                );
              }
          ),
          ],
        ),
      ),
    );
  }
}

