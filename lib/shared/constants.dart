//file containing shared styles, functions, values, that may be used in all classes
import 'package:flutter/material.dart';

Widget LiamNavBar(Widget child, Color bgcolor) {
  return Container(

    //how thick is it
    height: 75,

    //margins control how far off the bottom of the screen this nav bar is
    margin: const EdgeInsets.only(right:24,left:24,bottom:24),

    //decoration sets bg color, border radius, boxshadow, and much more
    decoration: BoxDecoration(
      color: bgcolor,
      borderRadius: BorderRadius.circular(20.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(20),
          blurRadius: 20,
          spreadRadius: 10
        ),
      ]
    ),

    //allows for a child widget to go inside
    child: child,
  );
}