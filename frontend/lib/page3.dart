import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: const Page3(title: 'Flutter Demo Home Page'),
    );
  }
}

class Page3 extends StatefulWidget {
  const Page3({super.key, required this.title});
  final String title;

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  @override
  Widget build(BuildContext context) {
    const color1 = Color(0xff126827);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
    ),
      body: Center(
        child: Container(
          height: 500,
          width: 300,
          color: Colors.blue,
          padding: const EdgeInsets.fromLTRB(30,0,0,0),
          margin: const EdgeInsets.fromLTRB(100,0,0,0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Container(width: 100, color: Colors.pink)),
              Expanded(child: Container(width: 100, color: Colors.orange)),
              Expanded(child: Container(width: 100, color: Colors.yellow)),
            ],
          ),
          alignment: Alignment.,
          child: Container(width: 100, height: 100, color: Colors.pinkAccent),
        ),
    )
  }

        // ROWS AND COLUMNS
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children:[
        //       Expanded(
        //         flex: 1,
        //         child: Container(
        //           color: Colors.yellow,
        //           child: const Center(child: Text("Flex: 1")),
        //         ),
        //       ),
        //       Expanded(
        //         flex: 2,
        //         child: Container(
        //           color: Colors.orange,
        //           child: const Center(child: Text("Flex: 2")),
        //         ),
        //       ),
        //       Expanded(
        //         flex: 3,
        //         child: Container(
        //           color: Colors.blueAccent,
        //           child: const Center(child: Text("Flex: 3")),
        //         ),
        //       ),
        //     ],
        //   )