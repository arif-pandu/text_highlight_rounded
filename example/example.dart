import 'package:flutter/material.dart';
import 'package:text_highlight_rounded/text_highlight_rounded.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const HighlightTextRounded(
              text: "one line only",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            HighlightTextRounded(
              text: "and for this\nhighlightText is more\nthan one line\nwith all rounded corners",
              textAlign: TextAlign.center,
              bold: 7,
              isAllCornerRound: true,
              radius: 10,
              markColor: Colors.red[100]!,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            HighlightTextRounded(
              text: "and for this\nhighlightText is more\nthan one line\nwith basic rounded corner",
              textAlign: TextAlign.right,
              bold: 7,
              radius: 10,
              isAllCornerRound: false,
              markColor: Colors.blue[100]!,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
