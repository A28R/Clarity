import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../../shared/loading.dart';

class CamWidget extends StatelessWidget {
  final BuildContext context;
  final CameraController controller;
  final Future initializeCamFuture;
  final bool isSwitchingCamera;
  final List photos;
  final int selectedPhoto;
  CamWidget({super.key, required this.context, required this.controller,
  required this.initializeCamFuture, required this.isSwitchingCamera, required this.selectedPhoto,
  required this.photos});

  @override
  Widget build(context) {
    if (selectedPhoto == -1)
      return FutureBuilder<void>(
      future: initializeCamFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !isSwitchingCamera) {
          return SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: 100,
                child: CameraPreview(this.controller),
              ),
            ),
          );
        } else {
          return const Loading();
        }
      },
    );
    else
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: 100,
            child: Image(
              opacity: const AlwaysStoppedAnimation(07),
              image: FileImage(
                File(photos[selectedPhoto].path),
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
  }
}
