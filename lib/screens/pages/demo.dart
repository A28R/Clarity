import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Demos extends StatefulWidget {
  const Demos({super.key});

  @override
  State<Demos> createState() => _DemosState();
}

class _DemosState extends State<Demos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade100,
      appBar: AppBar(
        title: Text("Demos Page"),
        backgroundColor: Colors.brown.shade700,
      ),
    );
  }
}
