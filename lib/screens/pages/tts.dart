import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:clarity/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech extends StatefulWidget {
  const TextToSpeech({super.key});

  @override
  State<TextToSpeech> createState() => _TextToSpeechState();
}

enum TtsState { playing, stopped, paused, continued }

class _TextToSpeechState extends State<TextToSpeech> {
  late File _image = File("assets/logo.png");
  final picker = ImagePicker();
  String _ocrText = "";
  TextEditingController text = TextEditingController();
  double volume = .5;
  String language = 'English';
  String selectedLanguage = 'en-US';
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  bool isPlaying = false;
  final speech = FlutterTts();
  List<Map> _voices = [];
  Map? _currentVoice;

  @override
  void initState() {
    super.initState();
    initTTS();
  }

  // Existing functionality methods remain the same
  void initTTS() {
    speech.getVoices.then((data) {
      try {
        List<Map> voices = List<Map>.from(data);
        setState(() {
          _voices = voices.where((voice) => voice["name"].contains("e")).toList();
          _currentVoice = _voices.last;
          setVoice(_currentVoice!);
        });
      } catch (e) {
        print(e);
      }
    });
  }

  void setVoice(Map voice) {
    speech.setVoice({"name": voice["name"], "locale": voice["locale"]});
  }

  void _ocr(url) async {
    final RecognizedText recognizedText = await textRecognizer.processImage(
      InputImage.fromFilePath(url),
    );
    _ocrText = recognizedText.text;
    text.text = recognizedText.text;
  }

  Future getImageFromGallery() async {
    try {
      final newimage = await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _image = File(newimage!.path);
        _ocr(newimage.path);
        text.text = _ocrText;
      });
    } on PlatformException catch (e) {
      if (e.code.contains("photo_access_denied")) {
        _showPermissionDialog(
          'Photos Permission Required',
          'This app needs photos access to import photos. Please grant permission in the app settings.',
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future getImageFromCamera() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          _ocr(pickedFile.path);
          text.text = _ocrText;
        }
      });
    } on PlatformException catch (e) {
      if (e.code.contains("camera_access_denied")) {
        _showPermissionDialog(
          'Camera Permission Required',
          'This app needs camera access to take photos. Please grant permission in the app settings.',
        );
      }
    } catch (e) {
      print(e);
    }
  }

  void _showPermissionDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Open Settings'),
            onPressed: () => AppSettings.openAppSettings(),
          ),
        ],
      ),
    );
  }

  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Photo Gallery'),
            onPressed: () {
              Navigator.of(context).pop();
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () {
              Navigator.of(context).pop();
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(
      IconData icon,
      String label,
      Color color,
      VoidCallback onPressed,
      bool isPlay,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPlay ? Icons.pause : icon,
              color: lighterTertiaryColor,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: lighterTertiaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_image.path != "assets/logo.png") {
      return Container(
        width: 400,
        height: 500,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InteractiveViewer(
          maxScale: 5.0,
          minScale: 1,
          boundaryMargin: const EdgeInsets.all(double.infinity),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.file(_image),
          ),
        ),
      );
    }

    return Container(
      width: 360,
      height: 360,
      decoration: BoxDecoration(
        color: secondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: darkerSecondaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Icon(
        Icons.photo_camera_back_outlined,
        size: 120,
        color: darkerSecondaryColor.withOpacity(0.5),
      ),
    );
  }

  Widget _buildVoiceControls() {
    return Card(
      color: lighterPrimaryColor.withOpacity(0.1),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: darkerSecondaryColor.withOpacity(0.5)
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              minLines: 5,
              maxLines: null,
              controller: text,
              decoration: InputDecoration(
                filled: true,
                fillColor: lighterTertiaryColor,
                hintText: 'Edit the recognized text to correct for any errors.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: darkerSecondaryColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: darkerSecondaryColor.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLanguageDropdown(),
                _buildVoiceDropdown(),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: volume,
                    min: 0.0,
                    max: 0.8,
                    activeColor: primaryColor,
                    inactiveColor: secondaryColor.withOpacity(0.2),
                    onChanged: (value) => setState(() => volume = value),
                  ),
                ),
                Icon(
                  CupertinoIcons.speedometer,
                  size: 24,
                  color: primaryColor,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildControlButton(
                  Icons.play_arrow,
                  'PLAY',
                  Colors.green,
                      () async {
                    if (isPlaying) {
                      await speech.pause();
                    } else {
                      await speech.setSpeechRate(volume);
                      await speech.setLanguage(selectedLanguage);
                      await speech.speak(text.text);
                    }
                    setState(() => isPlaying = !isPlaying);
                    speech.setCompletionHandler(() {
                      setState(() => isPlaying = !isPlaying);
                    });
                  },
                  isPlaying,
                ),
                const SizedBox(width: 16),
                _buildControlButton(
                  Icons.stop,
                  'STOP',
                  Colors.red,
                      () async {
                    speech.stop();
                    setState(() => isPlaying = false);
                  },
                  false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: darkerSecondaryColor.withOpacity(0.3),
        ),
      ),
      child: DropdownButton<String>(
        value: language,
        underline: const SizedBox(),
        items: ['English', 'Spanish', 'French'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            language = newValue!;
            selectedLanguage = {
              'English': 'en-US',
              'Spanish': 'es-ES',
              'French': 'fr-FR',
            }[newValue]!;
          });
        },
      ),
    );
  }

  Widget _buildVoiceDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: darkerSecondaryColor.withOpacity(0.3),
        ),
      ),
      child: DropdownButton(
        value: _currentVoice,
        underline: const SizedBox(),
        items: _voices.map((voice) {
          return DropdownMenuItem(
            value: voice,
            child: Text(voice["name"]),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _currentVoice = value as Map?;
            if (_currentVoice != null) {
              setVoice(_currentVoice!);
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lighterTertiaryColor,
      appBar: AppBar(
        title: Text(
          'Text to Speech',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: oppositeTertiaryColor,
          ),
        ),

        scrolledUnderElevation: 0.0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: oppositeTertiaryColor),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePreview(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: showOptions,
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkerSecondaryColor,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "SELECT IMAGE",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: lighterTertiaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildVoiceControls(),
            ],
          ),
        ),
      ),
    );
  }
}