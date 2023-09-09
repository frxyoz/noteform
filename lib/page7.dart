import 'package:flutter/material.dart';
import "page6.dart";
import 'package:camera/camera.dart';
import "page5.dart";
import "python_test.dart";

class Page7 extends StatefulWidget {
  const Page7({super.key, required this.title, required this.value, required this.camera});
  final String title;
  final String value;
  final CameraDescription camera;
  @override
  State<Page7> createState() => _Page7State();
}

class _Page7State extends State<Page7> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Container(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0,0,0,500),
                  child: Column(

                        children:[Text("Username: ${widget.value}" ,style: TextStyle(fontSize: 50), textAlign: TextAlign.center),
                        ElevatedButton(
                        child: const Text("Log Out"),
                        onPressed: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Page5(title: "Log In", camera: widget.camera)));}),
                        ]
                  ),
            ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children:
                  [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: ElevatedButton(
                        child: const Text("Home"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Page6(title: "Home Page", value: widget.value, camera: widget.camera))
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
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
                      padding: const EdgeInsets.all(18.0),
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
        ]
    )
    ));
  }
}

