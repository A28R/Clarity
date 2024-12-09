//file containing shared styles, functions, values, that may be used in all classes
import 'package:flutter/material.dart';

Widget LiamNavBar({required Widget child, required Color bgcolor,
  double height=75, double width=0.0, double radius=20.0}) {

  return Container(

    //how thick is it
    height: (height > 0) ? height : null,

    width: (width > 0) ? width : null,

    //margins control how far off the bottom of the screen this nav bar is
    margin: const EdgeInsets.only(right:24,left:24,bottom:24),

    //decoration sets bg color, border radius, boxshadow, and much more
    decoration: BoxDecoration(
      color: bgcolor,
      borderRadius: BorderRadius.circular((radius > 0.0) ? radius : 20),
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

String capitalize(String s) {
  return s.substring(0,1).toUpperCase()+s.substring(1).toLowerCase();
}

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0)),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.pink, width: 2.0)),
);