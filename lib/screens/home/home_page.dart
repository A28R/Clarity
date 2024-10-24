import 'package:clarity/themes/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: tertiaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 100,),
          const Text(
            "CLARITY",
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 72.0,
                letterSpacing: -3.0),
          ),
         Text(
            "Swipe To Start".toUpperCase(),
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 38.0,
                ),
          ),
          Image.asset('assets/claritydemo2.png', height: 330,),
          //this is the cool part, contains blocks
          Row(
            children: [

              const SizedBox(width: 40.0,),

              //settings block with gesturedetector to nav
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context,"/settings");
                    HapticFeedback.mediumImpact();
                  },
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          color: tertiaryColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: primaryColor,
                            blurRadius: 30,
                            spreadRadius: 1),],
                        border: Border.fromBorderSide(
                            BorderSide(color: oppositeTertiaryColor,width: 2.0),
                        )

                      ),
                      child: const Column(
                        //center widgets
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Mid page icon
                          Icon(CupertinoIcons.settings, size: 40,),
                          //text below icon
                          // Text(
                          //   "Settings".toUpperCase(),
                          //   style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.bold),
                          // ),
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
                  onTap: () {
                    Navigator.pushNamed(context,"/demos");
                    HapticFeedback.mediumImpact();
                  },
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: tertiaryColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: primaryColor,
                              blurRadius: 30,
                              spreadRadius: 1),],
                          border: Border.fromBorderSide(
                            BorderSide(color: oppositeTertiaryColor,width: 2.0),
                          )

                      ),
                      child: const Column(
                        //center widgets
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Mid page icon
                          Icon(CupertinoIcons.eyeglasses, size: 40,),
                          //text below icon
                          // Text(
                          //   "Demos".toUpperCase(),
                          //   style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.bold),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 30.0,),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context,"/info");
                    HapticFeedback.mediumImpact();
                  },
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          color: tertiaryColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: primaryColor,
                              blurRadius: 30,
                              spreadRadius: 1),],
                          border: Border.fromBorderSide(
                            BorderSide(color: oppositeTertiaryColor,width: 2.0),
                          )

                      ),
                      child: const Column(
                        //center widgets
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Mid page icon
                          Icon(CupertinoIcons.info_circle, size: 40,),
                          //text below icon
                          // Text(
                          //   "Info".toUpperCase(),
                          //   style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.bold),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40.0,),
            ],
          ),
        ],
      ),
    );
  }
}
