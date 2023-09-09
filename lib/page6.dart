import 'package:flutter/material.dart';
import "page7.dart";
import "python_test.dart";
import 'package:camera/camera.dart';


class Page6 extends StatefulWidget {
  const Page6({super.key, required this.title, required this.value, required this.camera});
  final String title;
  final String value;
  final CameraDescription camera;

  @override
  State<Page6> createState() => _Page6State();
}

class _Page6State extends State<Page6> {

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
                    padding: const EdgeInsets.fromLTRB(0,0,0,180),
                    child: Column(

                        children:[Text("Your Progress:" ,style: TextStyle(fontSize: 50), textAlign: TextAlign.center),
                          Image.asset("assets/graph.png")

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
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black45),
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