import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:camera/camera.dart';
import 'package:clarity/screens/pages/magnifier_stuff/cam_widget.dart';
import 'package:clarity/screens/pages/magnifier_stuff/permission_screen.dart';
import 'package:clarity/shared/constants.dart';
import 'package:clarity/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class MyMagnifier extends StatefulWidget {
  final dynamic cameras;
  const MyMagnifier({super.key, required this.cameras});
  @override
  State<MyMagnifier> createState() => _MyMagnifierState();
}

class _MyMagnifierState extends State<MyMagnifier> {
  late CameraController _controller;
  late Future<void> _initializeCamFuture;
  late CameraDescription front_cam;
  late CameraDescription back_cam;

  double _zoomLevel = 1.0;
  bool flash = false;
  bool _isSwitchingCamera = false;
  bool _hasCameraPermission = false;

  List<XFile> photos = [];
  int selectedPhoto = -1;

  @override
  void initState() {
    super.initState();
    back_cam = widget.cameras.first;
    front_cam = widget.cameras[1];
    _initializeCamera(back_cam);
  }

  void _initializeCamera(CameraDescription camera) async {
    _controller = CameraController(camera, ResolutionPreset.max);
    try {
      _initializeCamFuture = _controller.initialize();
    } catch (e) {
      print('error');
    }
    _controller.setFlashMode(FlashMode.off);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkCameraPermission() async {
    final status = await Permission.camera.status;
    print(status.isGranted);
    if (status.isGranted != _hasCameraPermission)
      setState(() => _hasCameraPermission = status.isGranted);
  }

  @override
  Widget build(BuildContext context) {
    _checkCameraPermission();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Magnifier'.toUpperCase(),
          style: TextStyle(
              color: lighterTertiaryColor,
              fontWeight: FontWeight.w800,
              fontSize: 24),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: oppositeTertiaryColor.withOpacity(0.7),
        leading: TextButton(
          child: Icon(
            Icons.arrow_back_ios,
            color: tertiaryColor,
          ),
          onPressed: () {Navigator.of(context).pop();HapticFeedback.mediumImpact();},
        ),
      ),
      body: Stack(
        children: [
          Stack(children: [
            if (!_hasCameraPermission)
              PermissionScreen(
                  checkCameraPermission: _checkCameraPermission,
                  context:context
              ),
            if (_hasCameraPermission)
              CamWidget(
                  context: context,
                  controller: _controller,
                  initializeCamFuture: _initializeCamFuture,
                  isSwitchingCamera: _isSwitchingCamera,
                  selectedPhoto: selectedPhoto,
                  photos:photos
              ),
          ]),
          if (_hasCameraPermission)
            DraggableScrollableSheet
              (
              controller: DraggableScrollableController(),
              initialChildSize: 0.17,
              minChildSize: 0.17,
              maxChildSize: (photos.isNotEmpty) ? 0.47 : 0.32,
              snap: true,
              snapAnimationDuration: Duration(milliseconds: 300),
              snapSizes:
                  (photos.isNotEmpty) ? [0.17, 0.32, 0.47] : [0.17, 0.32],
              builder: (context, controller) {
                return Container(
                  padding: EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 0.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    controller: controller,
                    child: Column(
                      children: [
                        SizedBox(height: 40.0),
                        LiamNavBar(
                          child: Slider(
                            value: _zoomLevel,
                            divisions: 9,
                            secondaryActiveColor: tertiaryColor,
                            inactiveColor: darkerPrimaryColor,
                            activeColor: darkerSecondaryColor,
                            min: 1.0,
                            max: 10.0,
                            allowedInteraction: SliderInteraction.slideOnly,
                            onChanged: (value) {
                              setState(() {
                                _zoomLevel = value;
                                _controller.setZoomLevel(_zoomLevel);
                              });
                            },
                          ),
                          bgcolor: lighterTertiaryColor,
                        ),
                        if (photos.isNotEmpty) SizedBox(height: 10.0),
                        if (photos.isNotEmpty)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 7, bottom: 30),
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: photos.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (selectedPhoto != index) {
                                              setState(() {
                                                selectedPhoto = index;
                                                _controller.setFlashMode(
                                                    FlashMode.off);
                                              });
                                            } else if (selectedPhoto == index) {
                                              setState(() {
                                                selectedPhoto = -1;
                                              });
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: Container(
                                              decoration: (selectedPhoto ==
                                                      index)
                                                  ? BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(10),
                                                      border:
                                                          Border.fromBorderSide(
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 2.0)))
                                                  : null,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image(
                                                  height: 100,
                                                  width: 100,
                                                  opacity:
                                                      const AlwaysStoppedAnimation(
                                                          07),
                                                  image: FileImage(
                                                    File(photos[index].path),
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: 10.0),
                        if (selectedPhoto == -1)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                LiamNavBar(
                                    child: TextButton(
                                      onPressed: () async {
                                        if (selectedPhoto == -1) {
                                          if (flash) {
                                            setState(() {
                                              flash = !flash;
                                              _controller
                                                  .setFlashMode(FlashMode.off);
                                            });
                                          } else {
                                            setState(() {
                                              flash = !flash;
                                              _controller.setFlashMode(
                                                  FlashMode.torch);
                                            });
                                          }
                                        }
                                        HapticFeedback.mediumImpact();
                                      },
                                      child: Icon(CupertinoIcons.light_max),
                                    ),
                                    bgcolor: (flash)
                                        ? Colors.grey.shade600
                                        : Colors.grey.shade100,
                                    width: 75,
                                    radius: 40.0),
                                LiamNavBar(
                                    child: TextButton(
                                      onPressed: () async {
                                        if (selectedPhoto == -1) {
                                          setState(() {
                                            _isSwitchingCamera = true;
                                          });
                                          if (_controller.description ==
                                              back_cam) {
                                            _controller
                                                .setDescription(front_cam);
                                          } else {
                                            _controller
                                                .setDescription(back_cam);
                                          }
                                          setState(() {
                                            _isSwitchingCamera = false;
                                          });
                                        }
                                        HapticFeedback.mediumImpact();
                                      },
                                      child: Icon(CupertinoIcons.switch_camera),
                                    ),
                                    bgcolor: (_controller.description==back_cam)
                                        ? Colors.grey.shade600
                                        : Colors.grey.shade100,
                                    width: 75,
                                    radius: 40.0),
                                LiamNavBar(
                                    child: TextButton(
                                      onPressed: () async {
                                        if (selectedPhoto == -1) {
                                          HapticFeedback.mediumImpact();
                                          XFile photo =
                                              await _controller.takePicture();
                                          setState(() {
                                            photos.add(photo);
                                          });
                                        }
                                      },
                                      child: Icon(
                                          CupertinoIcons.photo_camera_solid),
                                    ),
                                    bgcolor: Colors.grey.shade600,
                                    width: 75,
                                    radius: 40.0),
                              ],
                            ),
                          ),
                        if (selectedPhoto != -1)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                LiamNavBar(
                                    child: TextButton(
                                      onPressed: () {
                                        if (selectedPhoto != -1) {
                                          HapticFeedback.mediumImpact();
                                          Share.shareXFiles(
                                            [photos.elementAt(selectedPhoto)],
                                            subject: "Subject Placeholder",
                                            text: "Placeholder",
                                          );
                                        }

                                      },
                                      child: Icon(CupertinoIcons.share),
                                    ),
                                    bgcolor: Colors.grey.shade600,
                                    width: 75,
                                    radius: 40.0),
                                LiamNavBar(
                                    child: CupertinoButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        setState(() {
                                          photos.removeAt(selectedPhoto);
                                          selectedPhoto = -1;
                                        });
                                      },
                                      child: Icon(CupertinoIcons.delete),
                                    ),
                                    bgcolor: Colors.grey.shade600,
                                    width: 75,
                                    radius: 40.0),
                              ],
                            ),
                          ), // Padding between rows
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
