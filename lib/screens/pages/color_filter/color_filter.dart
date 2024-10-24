import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:app_settings/app_settings.dart';
import 'package:camera/camera.dart';
import 'package:clarity/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../shared/loading.dart';
import 'color_filter_funcs.dart';

enum ColorblindnessType {
  normal,
  protanopia,
  deuteranopia,
  tritanopia,
  protanomaly,
  deuteranomaly,
  tritanomaly,
  achromatopsia
}

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

  bool flash = false;
  bool _isSwitchingCamera = false;
  bool _hasCameraPermission = false;

  List<XFile> photos = [];
  late XFile photo;
  int selectedPhoto = -1;

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


  Future<void> _showDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Understanding Color Vision',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          content: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection(
                    'Types of Color Vision Deficiency:',
                    'Protan (Red-Weak): Difficulty distinguishing between reds and greens, with reds appearing darker.\n\n'
                        'Deutan (Green-Weak): Similar to protan, but greens appear darker instead of reds.\n\n'
                        'Tritan (Blue-Yellow): Rare condition affecting blue and yellow perception.\n\n'
                        'Achromats: Complete color blindness, seeing only in shades of gray.',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoSection(
                    'Important Note:',
                    'This test is designed for educational purposes and preliminary screening only. For an accurate diagnosis, please consult an eye care professional.',
                    isWarning: true,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4299E1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Take a Test',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.open_in_new,
                    size: 16,
                    color: Colors.white,
                  ),
                ],
              ),
              onPressed: () => _launchURL(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4299E1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Learn More',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.open_in_new,
                    size: 16,
                    color: Colors.white,
                  ),
                ],
              ),
              onPressed: () => _launchURL1(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'Exit',
                style: TextStyle(
                  color: Color(0xFF4A5568),
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

          ],
          actionsPadding: const EdgeInsets.all(16),
        );
      },
    );
  }

  Widget _buildInfoSection(String title, String content, {bool isWarning = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isWarning ? const Color(0xFFFFF5F5) : const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isWarning ? const Color(0xFFFED7D7) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isWarning ? const Color(0xFFE53E3E) : const Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: isWarning ? const Color(0xFF742A2A) : const Color(0xFF4A5568),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL1() async {
    const url = 'https://www.aoa.org/healthy-eyes/eye-and-vision-conditions/color-vision-deficiency';
    if (await canLaunch(url)) {
      await launch(url);
    }
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
                      ? Colors.orangeAccent
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
        _buildSwitchCameraButton(),
        _buildTakePictureButton()
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
        child: const Icon(CupertinoIcons.light_max),
      ),
      bgcolor: (selectedPhoto != -1) ? Colors.grey : Colors.orangeAccent,
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
        },
        child: const Icon(CupertinoIcons.switch_camera),
      ),
      bgcolor: (selectedPhoto != -1) ? Colors.grey : Colors.orangeAccent,
      width: 75,
      radius: 40.0,
    );
  }

  Widget _buildTakePictureButton() {
    return LiamNavBar(
      child: TextButton(
        onPressed: () async {
          XFile photo = await _controller.takePicture();
          photo = await applyColorblindnessFilter(photo, _currentFilter);
          setState(() {
            photos.add(photo);
            selectedPhoto = photos.indexOf(photo);
          });
        },
        child: const Icon(CupertinoIcons.photo_camera_solid),
      ),
      bgcolor: (selectedPhoto != -1) ? Colors.grey : Colors.orangeAccent,
      width: 75,
      radius: 40.0,
    );
  }

  Widget _buildShareButton() {
    return LiamNavBar(
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
        child: const Icon(CupertinoIcons.share),
      ),
      bgcolor: (selectedPhoto == -1) ? Colors.grey : Colors.orangeAccent,
      width: 75,
      radius: 40.0,
    );
  }

  Widget _buildDeleteButton() {
    return LiamNavBar(
      child: CupertinoButton(
        onPressed: () {
          setState(() {
            photos.removeAt(selectedPhoto);
            selectedPhoto = -1;
          });
        },
        child: const Icon(CupertinoIcons.delete),
      ),
      bgcolor: (selectedPhoto == -1) ? Colors.grey : Colors.orangeAccent,
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

  _launchURL() async {
    final Uri url = Uri.parse("https://enchroma.com/pages/color-blindness-test");
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkCameraPermission();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("ColorFilter Page"),
        backgroundColor: Colors.brown.shade900.withOpacity(0.7),
        elevation: 0,
        actions: [
          TextButton(
              onPressed: () => _showDialog(context),
              child: const Icon(CupertinoIcons.info_circle)
          ),
        ],
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
                    const Text("Your Camera is Disabled. Open Settings to fix this."),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.red)),
                      child: const Text(
                        'Open Settings',
                      ),
                      onPressed: () => AppSettings.openAppSettings(),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.red)),
                      child: const Text(
                        'Reload',
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
                              child: CameraPreview(_controller),
                            ),
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
              controller: _dragController,
              initialChildSize: 0.28,
              minChildSize: 0.28,
              maxChildSize: (photos.isNotEmpty) ? 0.45 : 0.28,
              snap: true,
              snapSizes: (photos.isNotEmpty) ? [0.28,0.45] : [0.28],
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
                        if (selectedPhoto == -1) buildColorblindnessSelector(),
                        if (selectedPhoto == -1) const SizedBox(height:10.0),
                        if (selectedPhoto == -1) buildActionButtonsRow1(),
                        if (selectedPhoto != -1) buildActionButtonsRow2(),
                        const SizedBox(height: 10.0), // Top padding
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