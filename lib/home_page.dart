import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:piano/discover_page.dart';
import "account_page.dart";
import "python_test.dart";
import 'package:camera/camera.dart';


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void navigateToDiscoverPage(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=> DiscoverPage() )
    );
  }

  void navigateToAccountPage(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=> AccountPage() )
    );
  }

  Widget progressChart(){
    return Container(
      padding: const EdgeInsets.fromLTRB(0,0,0,180),
      child: Column(

          children:[Text("Your Progress:" ,style: TextStyle(fontSize: 50), textAlign: TextAlign.center),
            Image.asset("assets/graph.png")

          ]
      ),
    );
  }

  Widget navigationBar(){
    return Container(
      color: Theme.of(context).colorScheme.inversePrimary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
          [
            ElevatedButton(
              onPressed: navigateToDiscoverPage,
              child: const Text("Discover"),
            ),
            ElevatedButton(
              onPressed: navigateToAccountPage,
              child: const Text("Account"),
            ),
          ],
        ),
      ),
    );
  }


  FutureBuilder progressFutureBuilder(){
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String path = 'user_data/$uid/sessions';

    return FutureBuilder(
      future: FirebaseDatabase.instance.ref(path).get(),
      builder: (context, snapshot){
        if (snapshot.hasError){
          return Expanded(
            child: Center(
              child: Text(
                'No Sessions Recorded',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )
          );
        }
        else if (snapshot.hasData) {

        }

        // Waiting for the future
        return const Center( child: CircularProgressIndicator());
      },
    );
  }


  Widget streamSessionListView(DataSnapshot snapshotData){
    if (! snapshotData.exists){
      return Center(child: Text(
          'You do not have any sessions recorded',
          style: Theme.of(context).textTheme.titleMedium,

        )
      );
    }

    print(snapshotData.value);
    Map<dynamic, dynamic> mapData = snapshotData.value as Map<dynamic, dynamic>;
    List<dynamic> dataKeys =  mapData.keys.toList();
    dataKeys.sort();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: dataKeys.length,
        itemBuilder: (context, index){
          int milliseconds = int.parse(dataKeys[index]);
          String date = DateTime.fromMillisecondsSinceEpoch(milliseconds).toIso8601String();
          return Card(
            child: ListTile(
              trailing: const Icon(Icons.chevron_right),
              onTap: (){},
              title: Text('$date'),
            ),
          );
        }
      ),
    );

    return Text("hello");
  }

  StreamBuilder sessionStreamBuilder(){
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String refPath = "sessiondata/$uid";

    return StreamBuilder(
      stream: FirebaseDatabase.instance.ref(refPath).onValue,
      builder: (context, streamSnapshot){
        if (streamSnapshot.hasError){
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline),
                Text("An Error Has Occurred.")
              ],
            ),
          );
        }
        else{
          switch(streamSnapshot.connectionState){
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              return streamSessionListView(streamSnapshot.data.snapshot);
            case ConnectionState.none:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return const Center(child: CircularProgressIndicator());
          }
        }
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Home"),
        ),
        body: Column(
            children: [
              Expanded(child: sessionStreamBuilder()),
              navigationBar(),
            ]
        ));
  }
}