import 'package:clarity/themes/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lighterTertiaryColor,
      appBar: AppBar(
        title: Text(
          'INFO'.toUpperCase(),
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
      body: Padding(
        padding: const EdgeInsets.all(70.0),
        child: Center(child:
        Text("Meet Your Creators: Liam Mpofu, Ayaan Rege, Ambrose Cole")
        ),
      ),
    );
  }
}
