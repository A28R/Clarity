import 'package:clarity/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lighterTertiaryColor,
      appBar: AppBar(
        title: Text(
          'SETTINGS'.toUpperCase(),
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
