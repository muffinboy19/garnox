import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class NoContentAnimatedText extends StatelessWidget {
  const NoContentAnimatedText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedTextKit(
        onTap: () {
          // print("Tap Event");
        },
        animatedTexts: [
          TyperAnimatedText(
            "Oops😵",
            speed: Duration(milliseconds: 100),
            textStyle: TextStyle(
              fontSize: 25.0,
            ),
          ),
          TyperAnimatedText(
            "It feels Lonely Here🙄",
            speed: Duration(milliseconds: 100),
            textStyle: TextStyle(
              fontSize: 25.0,
            ),
          ),
          TyperAnimatedText(
            "¯\\_(ツ)_/¯",
            speed: Duration(milliseconds: 100),
            textStyle: TextStyle(
              fontSize: 25.0,
            ),
          ),
        ],
        totalRepeatCount: 1,
        pause: Duration(milliseconds: 1000),
        displayFullTextOnTap: true,
        stopPauseOnTap: true,
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('No Content Animation'),
      ),
      body: NoContentAnimatedText(),
    ),
  ));
}
