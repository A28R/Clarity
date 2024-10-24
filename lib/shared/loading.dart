//file uses flutter spinkit to make a loading animation for when we need to fetch data

import 'package:clarity/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: secondaryColor,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: lighterTertiaryColor),
    ),
      child: Center(
        child: SpinKitWaveSpinner(
          color: darkerSecondaryColor,
          size: 50.0,
        ),
      ),
    );
  }
}
