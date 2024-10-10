import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
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

  double volume=.5;
  String language='English';
  String selectedLanguage='en-US';

  bool isPlaying = false;
  final speech=FlutterTts();



  void _ocr(url) async {
    _ocrText =
    await FlutterTesseractOcr.extractText(url, language: 'english', args: {
      "preserve_interword_spaces": "1",
    });
  }
  Future getImageFromGallery() async {
    try {
      final newimage = await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _image = File(newimage!.path);
        _ocr(newimage.path);
        text.text = _ocrText;
        print("asdihaosidhaosihdoaishdoiahsdoihasoidhaosihdoaish");
      });
    } on PlatformException catch (e) {
      print(e.code);
      if (e.code.contains("photo_access_denied")) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Photos Permission Required'),
            content: const Text('This app needs photos access to import photos. Please grant permission in the app settings.'),
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
    } catch (e) {
      print(e);
    }
    //check whether we have photos permission

  }

//Image Picker function to get image from camera
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
      print(e.code);
      if (e.code.contains("camera_access_denied")) {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              AlertDialog(
                title: const Text('Camera Permission Required'),
                content: const Text(
                    'This app needs camera access to take photos. Please grant permission in the app settings.'),
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
    } catch(e) {
      print(e);
    }
  }

  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

    Widget buildButton(IconData icon, String label, Color color,
        VoidCallback onPressed, bool isPlay) {
      return Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: MaterialButton(
          onPressed: onPressed,
          child: Row(
            children: [
              Icon(
                isPlay ? Icons.pause : icon,
                color: isPlay ? Colors.orange : Colors.white,
              ),
              const SizedBox(width: 5.0),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Text To Speech',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
        leading: TextButton(
          child: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: (_image.path != "assets/logo.png")
                    ? InteractiveViewer(
                  maxScale: 5.0,
                  minScale: 0.1,
                  boundaryMargin: const EdgeInsets.all(double.infinity),
                  child: ClipRRect(
                      borderRadius:BorderRadius.circular(24),
                      child: Image.file(_image)
                  ),
                )
                    : const Text('No Image selected'),
              ),
              CupertinoButton(
                onPressed: showOptions,
                child: const Text('Select Image'),
              ),

              const SizedBox(height: 40,),

              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextField(
                        maxLength: null,
                        maxLines: null,
                        controller: text,
                        decoration: InputDecoration(
                          hintText: 'Type or paste text to convert to speech',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      DropdownButton<String>(
                        value: language,
                        onChanged: (newLang) async {
                          setState(() {
                            language=newLang!;
                          });

                          switch(language){
                            case 'English':
                              setState(() {
                                selectedLanguage='en-US';
                              });
                              break;
                            case 'Spanish':
                              setState(() {
                                selectedLanguage='es-ES';
                              });
                              break;
                            case 'French':
                              setState(() {
                                selectedLanguage='fr-FR';
                              });
                              break;

                          }
                        },
                        items: ['English', 'Spanish', 'French'].map((language) {
                          return DropdownMenuItem<String>(
                            value: language,
                            child: Text(language),
                          );
                        }).toList(),
                      ),
                      Slider(
                        value: volume,
                        thumbColor: Colors.redAccent,
                        activeColor: Colors.blue,
                        onChanged: (newVolume) {
                          setState(() {
                            volume=newVolume;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildButton(Icons.play_arrow, 'Play', Colors.green,
                          () async {
                        if(isPlaying){
                          await speech.pause();
                        }else{
                          await speech.setLanguage(selectedLanguage);
                          await speech.setVolume(volume);
                          await speech.speak(text.text);

                        }
                        setState(() {
                          isPlaying=!isPlaying;
                        });
                        speech.setCompletionHandler(() {
                          setState(() {
                            isPlaying=!isPlaying;
                          });
                        });
                      }, isPlaying),
                  const SizedBox(
                    width: 10,
                  ),
                  buildButton(
                      Icons.stop, 'Stop', Colors.red, () async {
                    speech.stop();
                    setState(() {
                      isPlaying=false;
                    });
                  }, false),
                ],
              ),
              const SizedBox(height: 30,),

            ],
          ),
        ),
      ),
    );
  }


}


