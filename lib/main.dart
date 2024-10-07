import 'package:clarity/screens/home/home.dart';
import 'package:clarity/screens/pages/demo.dart';
import 'package:clarity/screens/pages/settings.dart';
import 'package:clarity/screens/pages/magnifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

final List<IconData> icons = [
  CupertinoIcons.mic,
  CupertinoIcons.viewfinder_circle,
  CupertinoIcons.zoom_in,
  CupertinoIcons.color_filter,
  CupertinoIcons.bubble_left_bubble_right
];
final List<String> labels = [
  "Text-To-Speech",
  "Text-Magnifier",
  "AI Zoom",
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();

  //COMMENT THIS LINE FOR VIRTUAL TESTING/ UNCOMMENT FOR PHYSICAL TESTING
  // runApp(MyApp(camera:cameras.first));

  //COMMENT THIS LINE FOR PHYSICAL TESTING/ UNCOMMENT FOR VIRTUAL TESTING
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  //UNCOMMENT THESE LINES FOR TESTING ON A PHYSICAL DEVICE/ COMMENT FOR VIRTUAL TESTING
  // final CameraDescription camera;
  // const MyApp({super.key, required this.camera});

  //COMMENT THESE LINES FOR PHYSICAL TESTING/ UNCOMMENT FOR VIRTUAL TESTING
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Home(
            icons:icons,
            labels:labels,
            colors:colors,

            //UNCOMMENT FOR PHYSICAL TESTING
            // camera: camera,
        ),
        '/settings': (context) => Settings(),
        '/demos': (context) => Demos(),
        //UNCOMMENT FOR PHYSICAL TESTING
        // '/magnifier': (context) => MyMagnifier(
        //   camera: camera,
        // ),
      },
    );
  }
}
