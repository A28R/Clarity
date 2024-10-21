import 'dart:io';
import 'dart:ui' as ui;
import 'package:app_settings/app_settings.dart';
import 'package:camera/camera.dart';
import 'package:clarity/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../../shared/loading.dart';

enum ColorblindnessType { normal, protanopia, deuteranopia, tritanopia, blackAndWhite }

class MyColorFilter extends StatefulWidget {
  final dynamic cameras;
  const MyColorFilter({super.key, required this.cameras});
  @override
  State<MyColorFilter> createState() => _MyColorFilterState();
}

class _MyColorFilterState extends State<MyColorFilter> {
  late CameraController _controller;
  late Future<void> _initializeCamFuture;
  late CameraDescription front_cam;
  late CameraDescription back_cam;
  ColorblindnessType _currentFilter = ColorblindnessType.normal;

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
    _initializeCamFuture = _controller.initialize();
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
      setState(()=>_hasCameraPermission = status.isGranted);
  }
  Future<bool> _getCameraPermissions() {
    return Permission.camera.request().isGranted;
  }

  @override
  Widget build(BuildContext context) {
    _checkCameraPermission();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("ColorFilter Page"),
        backgroundColor: Colors.brown.shade900.withOpacity(0.7),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Stack(children: [
            if (!_hasCameraPermission)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Your Camera is Disabled. Open Settings to fix this."),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.red)
                      ),
                      child: Container(
                        child: const Text(
                          'Open Settings',
                        ),
                      ),
                      onPressed: () => AppSettings.openAppSettings(),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.red)
                      ),
                      child: Container(
                        child: const Text(
                          'Reload',
                        ),
                      ),
                      onPressed: () => _hasCameraPermission,
                    ),
                  ],
                ),
              ),
            if (selectedPhoto == -1 && _hasCameraPermission)
              FutureBuilder<void>(
                future: _initializeCamFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      !_isSwitchingCamera) {
                    return Stack(
                      children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: 100,
                            child: Stack(
                                children: [

                                  CustomPaint(
                                    painter: ColorblindnessPainter(_currentFilter),
                                    child: CameraPreview(_controller),
                                  ),
                            ],

                            ),
                          ),
                        ),
                      ),
                        Align(
                          alignment: Alignment.center,
                          child: DropdownButton<ColorblindnessType>(
                            value: _currentFilter,
                            isExpanded: true,
                            onChanged: (ColorblindnessType? newValue) {
                              setState(() {
                                _currentFilter = newValue!;
                              });
                            },
                            items: ColorblindnessType.values.map((ColorblindnessType type) {
                              return DropdownMenuItem<ColorblindnessType>(
                                value: type,
                                child: Text(type.toString().split('.').last),
                              );
                            }).toList(),
                          ),
                        ),
                  ],
                    );
                  } else {
                    return const Loading();
                  }
                },
              ),
            if (selectedPhoto != -1 && _hasCameraPermission)
              SizedBox(
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
              ),
          ]),
          if (_hasCameraPermission)
            DraggableScrollableSheet(
              controller: DraggableScrollableController(),
              initialChildSize: 0.17,
              minChildSize: 0.17,
              maxChildSize: (photos.isNotEmpty) ? 0.46 : 0.3,
              snap: true,
              snapSizes: (photos.isNotEmpty) ? [0.17, 0.3, 0.46] : [0.17, 0.3],
              builder: (context, controller) {
                return Container(
                  padding: EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 0.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    controller: controller,
                    child: Column(
                      children: [
                        SizedBox(height: 40.0),
                        SizedBox(height: 10.0),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              LiamNavBar(
                                  child: TextButton(
                                    onPressed: () async {
                                      if (flash) {
                                        setState(() {
                                          flash = !flash;
                                          _controller.setFlashMode(FlashMode.off);
                                        });
                                      } else {
                                        setState(() {
                                          flash = !flash;
                                          _controller
                                              .setFlashMode(FlashMode.torch);
                                        });
                                      }
                                    },
                                    child: Icon(CupertinoIcons.light_max),
                                  ),
                                  bgcolor: (selectedPhoto != -1)
                                      ? Colors.grey
                                      : Colors.orangeAccent,
                                  width: 75,
                                  radius: 40.0),
                              LiamNavBar(
                                  child: TextButton(
                                    onPressed: () async {
                                      setState(() {
                                        _isSwitchingCamera = true;
                                      });
                                      if (_controller.description == back_cam) {
                                        _controller.setDescription(front_cam);
                                      } else {
                                        _controller.setDescription(back_cam);
                                      }
                                      setState(() {
                                        _isSwitchingCamera = false;
                                      });
                                    },
                                    child: Icon(CupertinoIcons.switch_camera),
                                  ),
                                  bgcolor: (selectedPhoto != -1)
                                      ? Colors.grey
                                      : Colors.orangeAccent,
                                  width: 75,
                                  radius: 40.0),
                              LiamNavBar(
                                  child: TextButton(
                                    onPressed: () async {
                                      XFile photo =
                                      await _controller.takePicture();
                                      setState(() {
                                        photos.add(photo);
                                      });
                                    },
                                    child:
                                    Icon(CupertinoIcons.photo_camera_solid),
                                  ),
                                  bgcolor: (selectedPhoto != -1)
                                      ? Colors.grey
                                      : Colors.orangeAccent,
                                  width: 75,
                                  radius: 40.0),
                              LiamNavBar(
                                  child: TextButton(
                                    onPressed: () {
                                      if (selectedPhoto != -1) {
                                        Share.shareXFiles(
                                          [photos.elementAt(selectedPhoto)],
                                          subject: "Subject Placeholder",
                                          text: "Placeholder",
                                        );
                                      }
                                    },
                                    child: Icon(CupertinoIcons.share),
                                  ),
                                  bgcolor: (selectedPhoto == -1)
                                      ? Colors.grey
                                      : Colors.orangeAccent,
                                  width: 75,
                                  radius: 40.0),
                              LiamNavBar(
                                  child: CupertinoButton(
                                    onPressed: () {
                                      setState(() {
                                        photos.removeAt(selectedPhoto);
                                        selectedPhoto = -1;
                                      });
                                    },
                                    child: Icon(CupertinoIcons.delete),
                                  ),
                                  bgcolor: (selectedPhoto == -1)
                                      ? Colors.grey
                                      : Colors.orangeAccent,
                                  width: 75,
                                  radius: 40.0),
                            ],
                          ),
                        ),
                        if (photos.isNotEmpty) SizedBox(height: 10.0),
                        if (photos.isNotEmpty)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(left: 7, bottom: 30),
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10)),
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
                                                _controller
                                                    .setFlashMode(FlashMode.off);
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
                                              decoration: (selectedPhoto == index)
                                                  ? BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      10),
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
class ColorblindnessPainter extends CustomPainter {
  final ColorblindnessType type;

  ColorblindnessPainter(this.type);

  @override
  void paint(Canvas canvas, Size size) {
    if (type == ColorblindnessType.normal) return;

    final paint = Paint();
    paint.blendMode = BlendMode.modulate;

    switch (type) {
      case ColorblindnessType.protanopia:
        paint.colorFilter = ColorFilter.matrix([
          0.567, 0.433, 0, 0, 0,
          0.558, 0.442, 0, 0, 0,
          0, 0.242, 0.758, 0, 0,
          0, 0, 0, 1, 0,
        ]);
        print("ayy3");
        break;
      case ColorblindnessType.deuteranopia:
        paint.colorFilter = ColorFilter.matrix([
          0.625, 0.375, 0, 0, 0,
          0.7, 0.3, 0, 0, 0,
          0, 0.3, 0.7, 0, 0,
          0, 0, 0, 1, 0,
        ]);
        print("ayy2");
        break;
      case ColorblindnessType.tritanopia:
        paint.colorFilter = ColorFilter.matrix([
          0.95, 0.05, 0, 0, 0,
          0, 0.433, 0.567, 0, 0,
          0, 0.475, 0.525, 0, 0,
          0, 0, 0, 1, 0,
        ]);
        print("ayy");
        break;
      case ColorblindnessType.blackAndWhite:
        paint.colorFilter = ColorFilter.matrix([
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0, 0, 0, 1, 0,
        ]);
        print("lil tecca");
        break;
      default:
        return;
    }

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is ColorblindnessPainter && oldDelegate.type != type;
  }
}