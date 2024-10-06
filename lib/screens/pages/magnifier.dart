import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class MyMagnifier extends StatefulWidget {
  final CameraDescription camera;
  const MyMagnifier({super.key, required this.camera});

  @override
  State<MyMagnifier> createState() => _MyMagnifierState();
}

class _MyMagnifierState extends State<MyMagnifier> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  double _zoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.max);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade100,
      appBar: AppBar(
        title: Text("Magnifier Page"),
        backgroundColor: Colors.brown.shade900,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CameraPreview(_controller),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    //how thick is it
                    height: 75,

                    //margins control how far off the bottom of the screen this nav bar is
                    margin:
                        const EdgeInsets.only(right: 24, left: 24, bottom: 24),

                    //decoration sets bg color, border radius, boxshadow, and much more
                    decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withAlpha(20),
                              blurRadius: 20,
                              spreadRadius: 10),
                        ]),

                    //allows for a child widget to go inside
                    child: Slider(
                      value: _zoomLevel,
                      min: 1.0,
                      max: 5.0,
                      onChanged: (value) {
                        setState(() {
                          _zoomLevel = value;
                          _controller.setZoomLevel(_zoomLevel);
                        });
                      },
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
