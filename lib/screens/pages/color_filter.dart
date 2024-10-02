import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ColorFilter extends StatefulWidget {
  const ColorFilter({super.key});

  @override
  State<ColorFilter> createState() => _ColorFilterState();
}

class _ColorFilterState extends State<ColorFilter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade100,
      appBar: AppBar(
        title: Text("ColorFilter Page"),
        backgroundColor: Colors.brown.shade900,
      ),
    );
  }
}
