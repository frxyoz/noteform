import 'package:flutter/material.dart';
import "account_page.dart";
import "python_test.dart";
import 'package:camera/camera.dart';


class HomePage extends StatefulWidget {


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Home"),
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
                                MaterialPageRoute(builder: (context) => HomePage()
                            ));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: ElevatedButton(
                          child: const Text("Discover"),
                          onPressed: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(builder: (context) =>
                            //         python_test()
                            // );
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
                                    AccountPage())
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