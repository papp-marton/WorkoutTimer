import 'package:flutter/material.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:workouttimer/second_page.dart';
import 'package:workouttimer/timer_page.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Workout Timer'),
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
  List<int> timersList = [];

  @override
  void initState() {
    _loadTimers().then((value){
      print('Async done');
    });
    super.initState();
  }

    void _saveTimers() async {
      List<String> strList = timersList.map((i) => i.toString()).toList();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList("productList", strList);
        setState(() {
          _counter++;
        });
    }
    Future _loadTimers() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? savedStrList = prefs.getStringList('productList');
      timersList = savedStrList!.map((i) => int.parse(i)).toList();
      setState(() {
          _counter++;
        });
  }

  Duration? passedTimer = const Duration(seconds: 10);
  void _addTimer(Duration? time) {
    setState(() {
      timersList.add(time!.inSeconds.toInt());
    });
  }

  String displayDuration(int duration) {
    int minutes = duration ~/ 60;
    int seconds = duration % 60;
    String minutesString = minutes.toString();
    String secondsString = seconds.toString();
    if (seconds == 0) {
      secondsString = '00';
    }
    if (seconds < 10) {
      secondsString = '0$seconds';
    }
    return "$minutesString:$secondsString";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(80, 20, 80, 20),
        child: ListView.builder(
          itemCount: timersList.length,
          // The list items
          itemBuilder: (context, index) {
            return SizedBox(
                height: 100,
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  color: Colors.amberAccent,
                  child: ElevatedButton(
                    child: Text(displayDuration(timersList[index])),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SecondPage(passedTimer: timersList[index])),
                      );
                    },
                    onLongPress: (){
                      setState(() {
                      timersList.remove(timersList[index]);
                      });
                      _saveTimers();
                    },
                  ),
                ));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultingDuration = await showDurationPicker(
            context: context,
            initialTime: const Duration(seconds: 30),
            baseUnit: BaseUnit.second,
          );
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Timer added for: $resultingDuration'),
            ),
          );
          if (resultingDuration != null) {
            _addTimer(resultingDuration);
            _saveTimers();
          }
        },
        tooltip: 'Popup Duration Picker',
        child: const Icon(Icons.add),
      ),
    );
  }
}
