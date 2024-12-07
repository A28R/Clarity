import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../themes/theme.dart';

class Demos extends StatefulWidget {
  const Demos({super.key});

  @override
  State<Demos> createState() => _DemosState();
}

class _DemosState extends State<Demos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lighterTertiaryColor,
      appBar: AppBar(
        title: Text(
          'DEMO'.toUpperCase(),
          style: TextStyle(
              color: lighterTertiaryColor,
              fontWeight: FontWeight.w800,
              fontSize: 24),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: oppositeTertiaryColor,
        leading: TextButton(
          child: Icon(
            Icons.arrow_back_ios,
            color: tertiaryColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
