import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SessionDetailsPage extends StatefulWidget{

  final SessionData sessionData;

  const SessionDetailsPage({super.key, required this.sessionData});

  @override
  State<SessionDetailsPage> createState() => _SessionDetailsPateState();

}

class _SessionDetailsPateState extends State<SessionDetailsPage>{

  late final SessionData sd;

  Widget rowInfo(String label, String info){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(info),
      ],
    );
  }

  String prettyDuration(Duration duration) {
    var components = <String>[];

    var days = duration.inDays;
    if (days != 0) {
      components.add('${days}d');
    }
    var hours = duration.inHours % 24;
    if (hours != 0) {
      components.add('${hours}h');
    }
    var minutes = duration.inMinutes % 60;
    if (minutes != 0) {
      components.add('${minutes}m');
    }

    var seconds = duration.inSeconds % 60;
    var centiseconds =
        (duration.inMilliseconds % 1000) ~/ 10;
    if (components.isEmpty || seconds != 0 || centiseconds != 0) {
      components.add('$seconds');
      if (centiseconds != 0) {
        components.add('.');
        components.add(centiseconds.toString().padLeft(2, '0'));
      }
      components.add('s');
    }
    return components.join();
  }


  Widget sessionInfoCard(){

    String percentString = (widget.sessionData.correctFingerPercent * 100).toStringAsFixed(2);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

              rowInfo('Date Time', widget.sessionData.startTimeString),
              const Divider(),
              rowInfo('Duration', prettyDuration(widget.sessionData.timeDuration)),
              const Divider(),


              rowInfo('Valid Data Points', widget.sessionData.validDataPoints.toString()),
              const Divider(),
              rowInfo('Total Data Points', widget.sessionData.totalDataPoints.toString()),
              const Divider(),


              rowInfo('Correct Fingers Detected', widget.sessionData.totalCorrectFingers.toString()),
              const Divider(),
              rowInfo('Fingers Detected', widget.sessionData.totalDetectedFingers.toString()),
              const Divider(),
              rowInfo('Correct Fingers Percent', '$percentString%'),


            ],
          ),
        ),
      ),
    );
  }


  Widget sessionListViewCard(int timestamp) {
    final f = DateFormat('hh:mm:ss.SSS a');
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);

    if (widget.sessionData.sessionDataRaw['$timestamp']['handsStatus'] < 1){
      return Card(
          child: ListTile(
            leading: Text(f.format(date)),
            title: const Text("No Hands Detected"),
          )
      );
    }

    int hands = widget.sessionData.sessionDataRaw['$timestamp']['handsStatus'];
    int correctHands = widget.sessionData.sessionDataRaw['$timestamp']['correctHandsStatus'];
    int failedFingers = widget.sessionData.sessionDataRaw['$timestamp']['failedFingersStatus'];

    return Card(
        child: ListTile(
          leading: Text(f.format(date)),
          title: Column(
            children: [
              rowInfo("Hands Detected",'$hands'),
              rowInfo("Correct Hands",'$correctHands'),
              rowInfo("Failed Fingers",'$failedFingers'),
            ],
          ),
        )
    );
  }


    Widget sessionListView(){

    int count = widget.sessionData.totalDataPoints;
    List<dynamic> keys = widget.sessionData.sessionDataRaw.keys.toList();
    keys.sort();


    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: ListView.builder(
          itemCount: count,
          itemBuilder: (context, index){
            return sessionListViewCard(int.parse(keys[index]));
          }
        ),
      ),
    );
  }


  @override
  Widget build(context){

    return Scaffold(
      appBar: AppBar(title: const Text("Session")),
      body: Column(
        children: [

          sessionInfoCard(),
          Text('Session History', style: Theme.of(context).textTheme.titleLarge),
          sessionListView()
        ],
      ),
    );
  }



}


class SessionData{

  late final Map<dynamic, dynamic> sessionDataRaw;

  int validDataPoints = 0;
  int totalDataPoints = 0;

  double handDetectedPercent = 0.0;

  int totalDetectedFingers = 0;
  int totalCorrectFingers = 0;

  double correctFingerPercent = 0.0;

  late String startTimeString;

  late Duration timeDuration;

  SessionData({required Map<dynamic, dynamic> data}){
    sessionDataRaw = data;

    List<dynamic> timestampEntries = sessionDataRaw.keys.toList();
    timestampEntries.sort();

    int starttime = int.parse(timestampEntries.first);
    int endtime = int.parse(timestampEntries.last);

    final timeFormat = DateFormat('MM/dd/yyyy hh:mm a');
    DateTime startdate = DateTime.fromMillisecondsSinceEpoch(starttime);
    DateTime enddate = DateTime.fromMillisecondsSinceEpoch(endtime);

    timeDuration = enddate.difference(startdate);


    startTimeString = timeFormat.format(startdate);
    totalDataPoints = timestampEntries.length;


    for(dynamic key in timestampEntries){

      try {
        print(sessionDataRaw[key]);

        int hands = sessionDataRaw[key]['handsStatus'];

        if(sessionDataRaw[key]['handsStatus'] > 0){
          validDataPoints ++;

          int failedFingers = sessionDataRaw[key]['failedFingersStatus'];

          // print('failedFingers $failedFingers');

          totalDetectedFingers = totalDetectedFingers + 5 * hands;
          // print('totalDetectedFingers $totalDetectedFingers');
          totalCorrectFingers = totalCorrectFingers + 5 - failedFingers;
          // print('totalCorrectFingers $totalCorrectFingers');
        }

      } catch (e) {
        print(e);
      }


    }
    print('validDataPoints $validDataPoints');

    handDetectedPercent = validDataPoints/totalDataPoints;
    print('handDetectedPercent $handDetectedPercent');

    correctFingerPercent = totalCorrectFingers / totalDetectedFingers;
    print('correctFingerPercent $correctFingerPercent');

  }



}