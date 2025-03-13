import 'package:clarity/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lighterTertiaryColor,
      body: Center(
        child: Container(
          width: 360,
          height: 360,
          decoration: BoxDecoration(
            color: lighterPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: darkerSecondaryColor.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: SpinKitWaveSpinner(
              color: primaryColor,
              size: 100.0,
            ),
          ),
        ),
      ),
    );
  }
}