import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'dart:convert';

import '../../shared/loading.dart';

class AIQuestions extends StatefulWidget {
  const AIQuestions({super.key});
  _AIQuestionsState createState() => _AIQuestionsState();
}

class _AIQuestionsState extends State<AIQuestions> {
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;
  late TextEditingController _textControl;

  // Replace with your actual API token
  static const String API_TOKEN = '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';
  static const String API_URL1 = 'https://api-inference.huggingface.co/models/dandelin/vilt-b32-finetuned-vqa';
  static const String API_URL2 = 'https://api-inference.huggingface.co/models/meta-llama/Llama-3.2-11B-Vision-Instruct';
  static String API_URL = API_URL1;

  File? _image;
  final ImagePicker _picker = ImagePicker();
  String result = '';
  List<bool> isSelected = [true, false];

  Future<String> processImageForAPI(File image) async {
    final imageBytes = await image.readAsBytes();
    // Don't add any extra formatting - just return the raw base64
    return base64Encode(imageBytes);
  }

  Future<void> analyzeSentiment(String text, String imagePath, File image) async {
    setState(() {
      _isLoading = true;
      result = '';
    });

    if (API_URL == API_URL1) {
      final imageBytes = File(imagePath!).readAsBytesSync();
      final decodedImage = img.decodeImage(imageBytes);
      if (decodedImage == null) throw Exception('Failed to decode image');

      // Resize image to match model input requirements
      final processedImage = img.copyResize(decodedImage, width: 384, height: 384);

      final base64Image = base64Encode(img.encodePng(processedImage));
      try {
        final response = await http.post(
          Uri.parse(API_URL),
          headers: {
            'Authorization': 'Bearer $API_TOKEN',
            'Content-Type': 'application/json',
            "x-wait-for-model": "true"
          },
          body: jsonEncode({
            'inputs': {"question": text, "image": base64Image}
          }),
        );

        if (response.statusCode == 200) {
          print("200");
          print(response.body);
          setState(() {
            result = response.body;
          });
        } else {
          print("not 200");
          print(response.body);
          setState(() {
            result = 'Error: ${response.statusCode}';
          });
        }
      } catch (e) {
        setState(() {
          result = 'Error: $e';
        });
      } finally {
        setState(() {
          _isLoading = false;
          result = result;
        });
      }
    } else {
      final imageBytes = image.readAsBytesSync();
      final decodedImage = img.decodeImage(imageBytes);
      // Resize image to match model input requirements
      //final processedImage = img.copyResize(decodedImage, width: 70, height: 70);

      final base64Image = base64Encode(img.encodePng(decodedImage));
      final input = '<image>data:image/jpeg;base64,${base64Image}</image>\n${text}';
      try {
        final response = await http.post(
          Uri.parse(API_URL),
          headers: {
            'Authorization': 'Bearer $API_TOKEN',
            'Content-Type': 'application/json',
            "x-wait-for-model": "true"
          },
          body: jsonEncode({
            'inputs': input,
            'parameters': {
              'max_new_tokens': 500,
              'temperature': 0.7,
              'top_p': 0.9,
              'top_k': 50,
              'repetition_penalty': 1.2,
              'do_sample': true,
              'return_full_text': false
            },
            'options': {
              'use_cache': true,
              'wait_for_model': true,
              'wait_for_model_timeout': 30000
            }
          }),
        );

        if (response.statusCode == 200) {
          print("200");
          print(response.body);
          setState(() {
            result = response.body;
          });
        } else {
          print("not 200-2");
          print(response.body);
          setState(() {
            result = 'Error: ${response.statusCode}';
          });
        }
      } catch (e) {
        setState(() {
          result = 'Error: $e';
        });
      } finally {
        setState(() {
          _isLoading = false;
          result = result;
        });
      }
    }

  }

  Future<void> _getImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _textControl = TextEditingController();
  }

  @override
  void dispose() {
    _textControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade100,
      appBar: AppBar(
        title: const Text("AIQuestions Page"),
        backgroundColor: Colors.brown.shade900,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Enter a prompt and select an image",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _textControl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your question about the image...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _getImage(ImageSource.gallery),
                  icon: const Icon(Icons.image),
                  label: const Text('Select Image'),
                ),
                ElevatedButton.icon(
                  onPressed: _image == null || _textControl.text.isEmpty
                      ? null
                      : () => analyzeSentiment(_textControl.text, _image!.path, _image!),
                  icon: const Icon(Icons.send),
                  label: const Text('Analyze'),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Align(
              alignment: Alignment.center,
              child: ToggleButtons(
                isSelected: isSelected,
                onPressed: (int index) {
                  setState(() {
                    for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                      if (buttonIndex == index) {
                        isSelected[buttonIndex] = true;
                        API_URL = API_URL1;
                      } else {
                        isSelected[buttonIndex] = false;
                        API_URL = API_URL2;
                      }
                    }
                  });
                },
                children: const <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 5.0),
                    child: Text("API New"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 5.0),
                    child: Text("API Old"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_image != null) ...[
              Image.file(
                _image!,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
            ],
            if (_isLoading)
              const Center(
                child: Column(
                  children: [
                    Loading(),
                    SizedBox(height: 8),
                    Text('Analyzing image...'),
                  ],
                ),
              )
            else if (result.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.brown.shade200),
                ),
                child: Text(result),
              ),
          ],
        ),
      ),
    );
  }
}