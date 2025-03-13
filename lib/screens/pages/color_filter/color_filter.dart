import 'dart:io';
import 'package:clarity/screens/pages/magnifier_stuff/permission_screen.dart';
import 'package:clarity/themes/theme.dart';
import 'package:app_settings/app_settings.dart';
import 'package:camera/camera.dart';
import 'package:clarity/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:clarity/screens/pages/color_filter/info_dialog.dart';
import '../../../shared/loading.dart';
import '../magnifier_stuff/cam_widget.dart';
import 'color_filter_funcs.dart';

class MyColorFilter extends StatefulWidget {
  final dynamic cameras;
  const MyColorFilter({super.key, required this.cameras});
  @override
  State<MyColorFilter> createState() => _MyColorFilterState();
}

class _MyColorFilterState extends State<MyColorFilter> {
  late CameraController _controller;
  late DraggableScrollableController _dragController;
  bool _isControllerAttached = false;
  late Future<void> _initializeCamFuture;
  late CameraDescription front_cam;
  late CameraDescription back_cam;
  ColorblindnessType _currentFilter = ColorblindnessType.normal;
  bool _isProcessingPhoto = false;

  bool flash = false;
  bool _isSwitchingCamera = false;
  bool _hasCameraPermission = false;

  List<XFile> photos = [];
  late XFile photo;
  int selectedPhoto = -1;

  dynamic _getChildSize() {
    if (photos.isEmpty)
      return [0.28,[0.28]];
    if (photos.isNotEmpty && selectedPhoto == -1)
      return [0.45,[0.28,0.45]];
    if (photos.isNotEmpty && selectedPhoto != -1)
      return [0.34,[0.34]];
  }

  dynamic _getMinSize() {
    if (photos.isEmpty)
      return 0.28;
    if (photos.isNotEmpty && selectedPhoto == -1)
      return 0.28;
    if (photos.isNotEmpty && selectedPhoto != -1)
      return 0.34;
  }

  @override
  void initState() {
    super.initState();
    _dragController = DraggableScrollableController()
      ..addListener(() {
        if (!_isControllerAttached && _dragController.isAttached) {
          setState(() {
            _isControllerAttached = true;
          });
        }
      });
    back_cam = widget.cameras.first;
    front_cam = widget.cameras[1];
    _initializeCamera(back_cam);
  }

  Widget buildColorblindnessSelector() {
    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: ColorblindnessType.values.map((ColorblindnessType type) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentFilter = type;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: _currentFilter == type
                      ? lighterTertiaryColor
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(type.toString().split('.').last),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget buildActionButtonsRow1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildFlashButton(),
        _buildTakePictureButton(),
        _buildSwitchCameraButton(),
      ],
    );
  }

  Widget buildActionButtonsRow2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildShareButton(),
        _buildDeleteButton(),
      ],
    );
  }

  Widget buildActionButton({required IconData icon, required VoidCallback onPressed}) {
    return SizedBox(
      width: 75,
      child: TextButton(
        onPressed: onPressed,
        child: Icon(icon),
      ),
    );
  }

  Widget buildPhotoSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 7, bottom: 30),
        child: SizedBox(
          height: 100,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: photos.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedPhoto = (selectedPhoto != index) ? index : -1;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    decoration: (selectedPhoto == index)
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: const Border.fromBorderSide(
                                BorderSide(color: Colors.white, width: 2.0)),
                          )
                        : null,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(
                        height: 100,
                        width: 100,
                        opacity: const AlwaysStoppedAnimation(0.7),
                        image: FileImage(File(photos[index].path)),
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
    );
  }

  Widget _buildFlashButton() {
    return LiamNavBar(
      child: TextButton(
        onPressed: () async {
          HapticFeedback.mediumImpact();
          if (flash) {
            setState(() {
              flash = !flash;
              _controller.setFlashMode(FlashMode.off);
            });
          } else {
            setState(() {
              flash = !flash;
              _controller.setFlashMode(FlashMode.torch);
            });
          }

        },
        child: Icon(CupertinoIcons.light_max, color: oppositeTertiaryColor,),
      ),
      bgcolor: (flash) ? Colors.grey.shade600
        : Colors.grey.shade100,
      width: 75,
      radius: 40.0,
    );
  }

  Widget _buildSwitchCameraButton() {
    return LiamNavBar(
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
          HapticFeedback.mediumImpact();
        },
        child: Icon(CupertinoIcons.switch_camera, color: oppositeTertiaryColor,),
      ),
      bgcolor: (_controller.description == back_cam) ? Colors.grey.shade600
          : Colors.grey.shade100,
      width: 75,
      radius: 40.0,
    );
  }

  Widget _buildTakePictureButton() {
    return LiamNavBar(
      child: TextButton(
        onPressed: _isProcessingPhoto ? null : () async {
          setState(()
          {
            _isProcessingPhoto = true;
          });
          HapticFeedback.mediumImpact();
          try {
            XFile photo = await _controller.takePicture();
            photo = await applyColorblindnessFilter(photo, _currentFilter);
            setState(() {
              photos.add(photo);
              selectedPhoto = photos.indexOf(photo);
              _isProcessingPhoto = false;
            });
          } catch (e) {
            setState(() {
              _isProcessingPhoto = false;
            });
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to process photo'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          }

        },
        child: Icon(CupertinoIcons.photo_camera_solid, color: oppositeTertiaryColor,),
      ),
      bgcolor: Colors.grey.shade600,
      width: 75,
      radius: 40.0,
    );
  }

  Widget _buildShareButton() {
    return LiamNavBar(
      child: TextButton(
        onPressed: () {
          HapticFeedback.mediumImpact();
          if (selectedPhoto != -1) {
            Share.shareXFiles(
              [photos.elementAt(selectedPhoto)],
              subject: "Subject Placeholder",
              text: "Placeholder",
            );
          }
        },
        child: Icon(CupertinoIcons.share, color: oppositeTertiaryColor,),
      ),
      bgcolor: Colors.grey.shade600,
      width: 75,
      radius: 40.0,
    );
  }

  Widget _buildDeleteButton() {
    return LiamNavBar(
      child: CupertinoButton(
        onPressed: () {
          HapticFeedback.mediumImpact();
          setState(() {
            photos.removeAt(selectedPhoto);
            selectedPhoto = -1;
          });
        },
        child: Icon(CupertinoIcons.delete, color: oppositeTertiaryColor,),
      ),
      bgcolor: Colors.grey.shade600,
      width: 75,
      radius: 40.0,
    );
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
    if (status.isGranted != _hasCameraPermission) {
      setState(() => _hasCameraPermission = status.isGranted);
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkCameraPermission();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Color Filter'.toUpperCase(),
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
          onPressed: () {
            Navigator.of(context).pop();
            HapticFeedback.mediumImpact();
          },
        ),
        actions: [
          TextButton(
            child: Icon(
              Icons.info_outlined,
              color: tertiaryColor,
            ),
            onPressed: () { HapticFeedback.mediumImpact();myShowDialog(context);},
          ),
        ],
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
            if (_isProcessingPhoto)
              Loading(),
          ]),
          if (_hasCameraPermission)
            DraggableScrollableSheet(
              controller: _dragController,
              initialChildSize: _getMinSize(),
              minChildSize: _getMinSize(),
              maxChildSize: _getChildSize()[0],
              snap: true,
              snapAnimationDuration: Duration(milliseconds: 300),
              snapSizes: _getChildSize()[1],
              builder: (context, controller) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(6.0, 10.0, 6.0, 10.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    controller: controller,
                    child: Column(
                      children: [
                        if (selectedPhoto == -1) const Text(
                          "COLORBLINDNESS MODE",
                          style: TextStyle(
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w700,
                            fontSize: 23.0,
                            color: Colors.white
                          ),
                        ),
                        if (selectedPhoto == -1) const SizedBox(height: 5.0,),
                        const SizedBox(height: 14.0), // Top padding
                        if (selectedPhoto == -1) buildColorblindnessSelector(),
                        if (selectedPhoto == -1) const SizedBox(height:10.0),
                        if (selectedPhoto == -1) buildActionButtonsRow1(),
                        if (selectedPhoto != -1) buildActionButtonsRow2(),
                        const SizedBox(height: 14.0), // Top padding
                        if (photos.isNotEmpty) buildPhotoSelector(), // Padding between rows
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