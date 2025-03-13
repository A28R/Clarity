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
    if (status.isGranted != _hasCameraPermission)
      setState(() => _hasCameraPermission = status.isGranted);
  }

  Widget _buildControlButton(
      IconData icon, VoidCallback onPressed, bool isActive) {
    return Container(
      decoration: BoxDecoration(
        color: isActive
            ? lighterTertiaryColor.withOpacity(1.0)
            : secondaryColor.withOpacity(0.45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: darkerSecondaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      width: 84,
      height: 84,
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: oppositeTertiaryColor,
          size: 28,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const uiOpacity = 0.5;
    _checkCameraPermission();
    return Scaffold(
      backgroundColor: lighterTertiaryColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Magnifier',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: oppositeTertiaryColor,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: lighterTertiaryColor.withOpacity(uiOpacity),
        iconTheme: IconThemeData(color: oppositeTertiaryColor),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
            HapticFeedback.mediumImpact();
          },
        ),
      ),
      body: Stack(
        children: [
          if (!_hasCameraPermission)
            PermissionScreen(
                checkCameraPermission: _checkCameraPermission,
                context: context),
          if (_hasCameraPermission)
            CamWidget(
                context: context,
                controller: _controller,
                initializeCamFuture: _initializeCamFuture,
                isSwitchingCamera: _isSwitchingCamera,
                selectedPhoto: selectedPhoto,
                photos: photos),
          if (_hasCameraPermission)
            DraggableScrollableSheet(
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
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: lighterTertiaryColor.withOpacity(uiOpacity),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    controller: controller,
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: darkerSecondaryColor.withOpacity(0.3),
                          ),
                        ),
                        SizedBox(height: 24),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: secondaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: darkerSecondaryColor.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Slider(
                                      thumbColor: oppositeTertiaryColor,
                                      secondaryActiveColor: Colors.red,
                                      value: _zoomLevel,
                                      divisions: 10,
                                      activeColor:
                                          darkerSecondaryColor.withOpacity(0.3),
                                      inactiveColor:
                                          secondaryColor.withOpacity(0.2),
                                      min: 1.0,
                                      max: 10.0,
                                      onChanged: (value) {
                                        setState(() {
                                          _zoomLevel = value;
                                          _controller.setZoomLevel(_zoomLevel);
                                        });
                                      },
                                    ),
                                  ),
                                  Icon(
                                    Icons.zoom_in_rounded,
                                    size: 36,
                                    color: oppositeTertiaryColor,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                        if (selectedPhoto == -1)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildControlButton(
                                CupertinoIcons.light_max,
                                () {
                                  if (selectedPhoto == -1) {
                                    setState(() {
                                      flash = !flash;
                                      _controller.setFlashMode(flash
                                          ? FlashMode.torch
                                          : FlashMode.off);
                                    });
                                    HapticFeedback.mediumImpact();
                                  }
                                },
                                flash,
                              ),
                              _buildControlButton(
                                CupertinoIcons.photo_camera_solid,
                                () async {
                                  if (selectedPhoto == -1) {
                                    HapticFeedback.mediumImpact();
                                    XFile photo =
                                        await _controller.takePicture();
                                    setState(() {
                                      photos.add(photo);
                                    });
                                  }
                                },
                                false,
                              ),
                              _buildControlButton(
                                CupertinoIcons.switch_camera,
                                () async {
                                  if (selectedPhoto == -1) {
                                    setState(() => _isSwitchingCamera = true);
                                    _controller.setDescription(
                                        _controller.description == back_cam
                                            ? front_cam
                                            : back_cam);
                                    setState(() => _isSwitchingCamera = false);
                                    HapticFeedback.mediumImpact();
                                  }
                                },
                                _controller.description != back_cam,
                              ),
                            ],
                          ),
                        if (selectedPhoto != -1)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildControlButton(
                                CupertinoIcons.share,
                                () {
                                  if (selectedPhoto != -1) {
                                    HapticFeedback.mediumImpact();
                                    Share.shareXFiles(
                                      [photos[selectedPhoto]],
                                      subject: "Magnified Image from Clarity!",
                                      text: "Check out my magnified image!",
                                    );
                                  }
                                },
                                false,
                              ),
                              _buildControlButton(
                                CupertinoIcons.delete,
                                () {
                                  HapticFeedback.mediumImpact();
                                  setState(() {
                                    photos.removeAt(selectedPhoto);
                                    selectedPhoto = -1;
                                  });
                                },
                                false,
                              ),
                            ],
                          ),
                        if (photos.isNotEmpty) SizedBox(height: 24),
                        if (photos.isNotEmpty)
                          Column(
                            children: [
                              Text(
                                'Magnifier',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: oppositeTertiaryColor,
                                ),
                              ),
                              Container(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: photos.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedPhoto =
                                                selectedPhoto == index
                                                    ? -1
                                                    : index;
                                            if (selectedPhoto != -1) {
                                              _controller
                                                  .setFlashMode(FlashMode.off);
                                            }
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: selectedPhoto == index
                                                ? Border.all(
                                                    color: primaryColor,
                                                    width: 2)
                                                : null,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                spreadRadius: 1,
                                                blurRadius: 4,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.file(
                                              File(photos[index].path),
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
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
