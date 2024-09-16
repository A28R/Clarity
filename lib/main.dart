import 'package:clarity/screens/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final List<IconData> icons = [
  CupertinoIcons.mic,
  CupertinoIcons.viewfinder_circle,
  CupertinoIcons.signature,
  CupertinoIcons.color_filter,
  CupertinoIcons.bubble_left_bubble_right
];
final List<String> labels = [
  "Text-To-Speech",
  "Text-Magnifier",
  "Image-Text-Selection",
  "Colorblindness-Filtration",
  "Ai-Questions"
];
final List<Color> colors = [
  Colors.blue,
  Colors.yellow,
  Colors.green,
  Colors.orange,
  Colors.deepPurple
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(
            icons: [
              CupertinoIcons.mic,
              CupertinoIcons.viewfinder_circle,
              CupertinoIcons.signature,
              CupertinoIcons.color_filter,
              CupertinoIcons.bubble_left_bubble_right
            ], labels: [
          "Text-To-Speech",
          "Text-Magnifier",
          "Image-Text-Selection",
          "Colorblindness-Filtration",
          "Ai-Questions"
        ], colors: [
          Colors.blue,
          Colors.yellow,
          Colors.green,
          Colors.orange,
          Colors.deepPurple
        ]),

      },
    );
  }
}
