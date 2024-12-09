import 'package:clarity/firebase_options.dart';
import 'package:clarity/screens/home/home.dart';
import 'package:clarity/screens/pages/ai_questions.dart';
import 'package:clarity/screens/pages/color_filter/color_filter.dart';
import 'package:clarity/screens/pages/demo.dart';
import 'package:clarity/screens/pages/info.dart';
import 'package:clarity/screens/pages/redirect.dart';
import 'package:clarity/screens/pages/settings_stuff/settings.dart';
import 'package:clarity/screens/pages/magnifier_stuff/magnifier.dart';
import 'package:clarity/screens/pages/tts.dart';
import 'package:clarity/services/database_fb.dart';
import 'package:clarity/themes/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'models/data.dart';
import 'package:hive_flutter/hive_flutter.dart';

/*Imports Above ^
All imports of the form 'clarity/screens/...' import classes from other project files

Cupertino imports the library of IOS-style widgets
Material imports all other widgets, including some cupertino needs to be used
Camera handles fetching camera and other data
 */



final List<IconData> icons = [
  CupertinoIcons.mic_circle,
  CupertinoIcons.viewfinder_circle,
  CupertinoIcons.zoom_in,
  CupertinoIcons.color_filter,
  CupertinoIcons.bubble_left_bubble_right
];
final List<String> labels = [
  "Text-To-Speech",
  "Magnifier",
  "Colorblindness Filter",
  "AI Questions"
];
final List<String> descriptions = [
  "Recognizes text from an image, then recites the text",
  "Magnifies the live camera with a slider, allows user to take pictures",
  "Filters live camera using various color blindness presets",
  "Uses AI to answer questions about an image"
];

final List<Color> colors = [
  Colors.blue.shade700.withAlpha(200),
  Colors.red.shade900,
  Colors.pink.shade800,
  Colors.deepPurple.shade800
];
//These lists above contain info for the home widget;
//they have corresponding (by index) icons, labels, and colors displayed in the home widget pageview



void main() async {
  /*
  main() -> void
  runs app
   */


  //since main function has an async* marker, we need this to initialize WidgetsBinding
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Initialize Hive
  Hive.registerAdapter(MyUserDataAdapter()); // Register the adapter

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  await Hive.openBox<MyUserData>('preferences'); // Open the box

  //fetching cameras for the app (will return zero if we have none)
  //also returns 0 if no cameras available
  final cameras = await availableCameras();

  if (cameras.length != 0) {
    //we try to run the app by passing in the first of these cameras (back cam)
    runApp(MyApp(camera:cameras));

  } else {
    //if that doesnt work, we pass no camera in
    runApp(MyApp(camera:null));
  }
}

class MyApp extends StatelessWidget {
  /*
  class MyApp subclass of Stateless Widget
  class from which everything is routed and ran
   */

  //instantiating camera object which is either CameraDescription or null
  final List<CameraDescription>? camera;
  const MyApp({super.key, required this.camera});


  @override //marking that we're about to override a superclass function
  Widget build(BuildContext context) {
    // build func, returns a widget
    //parameter is context

    //we return a material app
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //setting the initial route
      initialRoute: '/',

      //defining named routes -- since we dont have a ton, its easy
      routes: {
        '/': (context) => Home(
          icons:icons,
          labels:labels,
          colors: colors,
          descriptions:descriptions,
        ),
        '/settings': (context) => Settings(),
        '/demos': (context) => Demos(),
        '/info': (context) => Info(),
        '/tts': (context) => TextToSpeech(),
        '/aiquestions': (context) => AIQuestions(),


        //Special route becuase physical devices don't have cameras
        //if we have a camera, we make an instance of the MyMagnifier widget
        //if there's no camera, we go to the Redirect widget
        if (camera != null) '/magnifier': (context) => MyMagnifier(cameras: camera),
        if (camera == null) '/magnifier': (context) => Redirect(),

        if (camera != null) '/colorfilter': (context) => MyColorFilter(cameras:camera),
        if (camera == null) '/colorfilter': (context) => Redirect(),

      },
    );
  }
}
