import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clarity/themes/theme.dart';
import 'package:flutter/services.dart';

class Redirect extends StatefulWidget {
  const Redirect({super.key});

  @override
  State<Redirect> createState() => _RedirectState();
}

class _RedirectState extends State<Redirect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          "Redirect Page".toUpperCase(),
          style: TextStyle(
            color: lighterTertiaryColor,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        color: darkerPrimaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: tertiaryColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: darkerSecondaryColor,
                  width: 2,
                ),
              ),
              child: Text(
                "Something went wrong! You may be on a device that cannot access certain features such as camera. This is here to inform you of that! Click the button below to navigate back to the last screen!",
                style: TextStyle(
                  color: oppositeTertiaryColor,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: tertiaryColor,
                foregroundColor: oppositeTertiaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: darkerSecondaryColor, width: 2),
                ),
                elevation: 0,
              ),
              child: const Icon(
                CupertinoIcons.arrow_turn_up_left,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
