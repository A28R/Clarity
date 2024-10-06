import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.cyan,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "CLARITY",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 45.0,
                letterSpacing: 1.0),
          ),
          const Text(
            "SWIPE TO START",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 35.0,
                letterSpacing: 1.0),
          ),
          const SizedBox(height: 50.0),

          //this is the cool part, contains blocks
          Row(
            children: [

              const SizedBox(width: 40.0,),

              //settings block with gesturedetector to nav
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context,"/settings"),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withAlpha(20),
                            blurRadius: 20,
                            spreadRadius: 10),],
                        border: const Border.fromBorderSide(
                            BorderSide(color: Colors.teal,width: 4.0),
                        )

                      ),
                      child: const Column(
                        //center widgets
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Mid page icon
                          Icon(CupertinoIcons.settings),
                          //text below icon
                          Text(
                            "Settings",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 30.0),
              //demos block with gesturedetector to nav
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context,"/demos"),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black.withAlpha(20),
                              blurRadius: 20,
                              spreadRadius: 10),],
                          border: const Border.fromBorderSide(
                            BorderSide(color: Colors.teal,width: 4.0),
                          )

                      ),
                      child: const Column(
                        //center widgets
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Mid page icon
                          Icon(CupertinoIcons.eyeglasses),
                          //text below icon
                          Text(
                            "Demos",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 40.0,),
            ],
          ),
        ],
      ),
    );
  }
}