import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AIQuestions extends StatefulWidget {
  const AIQuestions({super.key});

  @override
  State<AIQuestions> createState() => _AIQuestionsState();
}

class _AIQuestionsState extends State<AIQuestions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade100,
      appBar: AppBar(
        title: Text("AIQuestions Page"),
        backgroundColor: Colors.brown.shade900,
      ),
    );
  }
}
