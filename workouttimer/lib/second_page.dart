import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:just_audio/just_audio.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key, this.title, required this.passedTimer}) : super(key: key);
  final  int passedTimer;
  final String? title;

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
final CountDownController _controller = CountDownController();
  late AudioPlayer player;
  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
  Future<void> playSound() async {
    await player.setAsset('assets/audio/alarm-clock.mp3');
    await player.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('You got this!'),
      ),
      body: Center(
        child: CircularCountDownTimer(
          // Countdown duration in Seconds.
          duration: widget.passedTimer,
          // Countdown initial elapsed Duration in Seconds.
          initialDuration: 0,
          // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
          controller: _controller,
          // Width of the Countdown Widget.
          width: MediaQuery.of(context).size.width / 2,
          // Height of the Countdown Widget.
          height: MediaQuery.of(context).size.height / 2,
          // Ring Color for Countdown Widget.
          ringColor: Colors.grey[300]!,
          // Ring Gradient for Countdown Widget.
          ringGradient: null,
          // Filling Color for Countdown Widget.
          fillColor: Colors.blueAccent[100]!,
          // Filling Gradient for Countdown Widget.
          fillGradient: null,
          // Background Color for Countdown Widget.
          backgroundColor: Colors.blue[500],
          // Background Gradient for Countdown Widget.
          backgroundGradient: null,
          // Border Thickness of the Countdown Ring.
          strokeWidth: 20.0,
          // Begin and end contours with a flat edge and no extension.
          strokeCap: StrokeCap.round,
          // Text Style for Countdown Text.
          textStyle: const TextStyle(
            fontSize: 33.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          // Format for the Countdown Text.
          textFormat: CountdownTextFormat.MM_SS,
          // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
          isReverse: true,
          // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
          isReverseAnimation: true,
          // Handles visibility of the Countdown Text.
          isTimerTextShown: true,
          // Handles the timer start.
          autoStart: true,
          // This Callback will execute when the Countdown Starts.
          onStart: () {
            // Here, do whatever you want
            debugPrint('Countdown Started');
          },
          // This Callback will execute when the Countdown Ends.
          onComplete: () async {
            // Here, do whatever you want
            await playSound();
            debugPrint('Countdown Ended');
            Navigator.of(context).pop();
          },
          // This Callback will execute when the Countdown Changes.
          onChange: (String timeStamp) {
            // Here, do whatever you want
            debugPrint('Countdown Changed $timeStamp');
          },
          /* 
            * Function to format the text.
            * Allows you to format the current duration to any String.
            * It also provides the default function in case you want to format specific moments
              as in reverse when reaching '0' show 'GO', and for the rest of the instances follow 
              the default behavior.
          */
          timeFormatterFunction: (defaultFormatterFunction, duration) {
            if (duration.inSeconds == 0) {
              // only format for '0'
              return "Over";
            } else {
              // other durations by it's default format
              return Function.apply(defaultFormatterFunction, [duration]);
            }
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 30,
          ),
          _button(
            title: "Start",
            onPressed: () => _controller.start(),
          ),
          const SizedBox(
            width: 10,
          ),
          _button(
            title: "Pause",
            onPressed: () => _controller.pause(),
          ),
          const SizedBox(
            width: 10,
          ),
          _button(
            title: "Resume",
            onPressed: () => _controller.resume(),
          ),
          const SizedBox(
            width: 10,
          ),
          _button(
            title: "Restart",
            onPressed: () => _controller.restart(duration: widget.passedTimer),
          ),
        ],
      ),
    );
  }

  Widget _button({required String title, VoidCallback? onPressed}) {
    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}