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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      home: const Page2(title: 'Flutter Demo Home Page'),
    );
  }
}

class Page2 extends StatefulWidget {
  const Page2({super.key, required this.title});
  final String title;

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title),
      ),
      //DEFAULT PAGE SETUP
      // appBar: AppBar(
      //   title: const Text("Page 2"),
      // ),
      // body: const Center(
      //   child: Text("This is the second page.")
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //     print("Pressed button!");
      //   },
      //   child: const Icon(Icons.help),
      // ),

      // body: Center(
      //
      //   //ICONS
      //   // child: Row(
      //   //   mainAxisAlignment: MainAxisAlignment.center,
      //   //   children: [
      //   //     Icon(
      //   //       Icons.ac_unit,
      //   //       color: Colors.purpleAccent,
      //   //       size: 50.0,
      //   //     ),
      //   //     Icon(
      //   //       Icons.add_alert_outlined,
      //   //       color: Colors.blue,
      //   //       size: 50.0,
      //   //     ),
      //   //     Icon(
      //   //       Icons.arrow_circle_down_rounded,
      //   //       color: Colors.orange,
      //   //       size: 50.0,
      //   //     ),
      //   //   ],
      //   // )
      //
      //   //BUTTONS
      //   // child: Column(
      //   //   mainAxisAlignment: MainAxisAlignment.center,
      //   //   children: [
      //   //     TextButton(
      //   //       child: const Text("Text Button"),
      //   //       onPressed: (){
      //   //         print("Pressed the text button");
      //   //       },
      //   //     ),
      //   //     ElevatedButton(
      //   //       child: const Text("Elevated Button"),
      //   //       onPressed: (){
      //   //         print("Pressed the elevated button");
      //   //       },
      //   //     ),
      //   //     IconButton(
      //   //       icon: const Icon(Icons.surfing_outlined, color:color1,),
      //   //       onPressed: (){
      //   //         print("Pressed the icon button");
      //   //       },
      //   //     ),
      //   //   ],
      //   // ),
      //
      //   //TEXT
      //   // child: Row(
      //   //   mainAxisAlignment: MainAxisAlignment.center,
      //   //   children: [
      //   //     Container(
      //   //       height: 100.0,
      //   //       width: 200.0,
      //   //       color: Colors.greenAccent,
      //   //       child: const Text("Something there is that doesn’t love a wall, That sends the frozen-ground-swell under it,And spills the upper boulders in the sun;And makes gaps even two can pass abreast.",
      //   //         softWrap: true,
      //   //         textAlign: TextAlign.center,
      //   //         style: TextStyle(
      //   //           fontWeight: FontWeight.bold,
      //   //           fontSize: 20,
      //   //         ),
      //   //       ),
      //   //     ),
      //   //     Container(
      //   //       height: 100.0,
      //   //       width: 200.0,
      //   //       color: Colors.yellowAccent,
      //   //       child: const Text("Something there is that doesn’t love a wall, That sends the frozen-ground-swell under it,And spills the upper boulders in the sun;And makes gaps even two can pass abreast.",
      //   //         textAlign: TextAlign.center,
      //   //         style: TextStyle(
      //   //           fontSize: 20,
      //   //         ),
      //   //       ),
      //   //     ),
      //   //   ],
      //   // ),
      // ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username'
              ),
              onSubmitted: (String name) {
                print("Username set to $name");
              },
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password'
              ),
              onSubmitted: (String pass) {
                print("Password set!");
              },
            ),
          ],
        ),
      ),
    );
  }
}