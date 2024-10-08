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
      backgroundColor: Colors.brown.shade100,
      appBar: AppBar(
        title: Text("Info Page"),
        backgroundColor: Colors.brown.shade700,
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
