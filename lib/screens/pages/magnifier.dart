import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class MyMagnifier extends StatefulWidget {
  const MyMagnifier({super.key});

  @override
  State<MyMagnifier> createState() => _MyMagnifierState();
}

class _MyMagnifierState extends State<MyMagnifier> {
  late File _image = File("assets/logo.png");
  final picker = ImagePicker();

  /*Image Picker function to get image from gallery
  tries to get  photo and gives error msg thangy if fails
   */
  Future getImageFromGallery() async {
    try {
      final _newimage = await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _image = File(_newimage!.path);
      });
    } on PlatformException catch (e) {
      print(e.code);
      if (e.code.contains("photo_access_denied")) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Photos Permission Required'),
            content: Text('This app needs photos access to take photos. Please grant permission in the app settings.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text('Open Settings'),
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
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Camera'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade100,
      appBar: AppBar(
        title: Text("Magnifier Page"),
        backgroundColor: Colors.brown.shade900,
      ),
      body: Container(
        child: ListView(
          children: [
            TextButton(
              child: Text('Select Image'),
              onPressed: showOptions,
            ),
            Center(
              child: (_image != null && _image.path != "assets/logo.png")
                  ? Image.file(_image)
                  : Text('No Image selected'),
            ),
          ],
        ),
      ),
    );
  }
}
