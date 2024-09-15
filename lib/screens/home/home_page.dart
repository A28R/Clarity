import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.cyan,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "CLARITY",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 45.0,
                letterSpacing: 1.0),
          ),
          Text(
            "SWIPE TO START",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 35.0,
                letterSpacing: 1.0),
          ),
        ],
      ),
    );
  }
}
