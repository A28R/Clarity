import 'package:clarity/themes/theme.dart';
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
  bool _isLoading = false;
  late TextEditingController _textControl;
  final FocusNode _questionFocusNode = FocusNode();

  // Replace with your actual API token
  static const String API_TOKEN = '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';
  static const String API_URL =
      'https://api-inference.huggingface.co/models/dandelin/vilt-b32-finetuned-vqa';

  File? _image;
  final ImagePicker _picker = ImagePicker();
  String result = '';
  String result1 = '';
  double score1 = 0.0;

  @override
  void initState() {
    super.initState();
    _textControl = TextEditingController();
  }

  @override
  void dispose() {
    _textControl.dispose();
    _questionFocusNode.dispose();
    super.dispose();
  }

  Future<void> _getImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> analyzeSentiment(
      String text, String imagePath, File image) async {
    setState(() {
      _isLoading = true;
      result = '';
    });

    final imageBytes = File(imagePath).readAsBytesSync();
    final decodedImage = img.decodeImage(imageBytes);
    if (decodedImage == null) throw Exception('Failed to decode image');

    // Resize image to match model input requirements
    final processedImage =
    img.copyResize(decodedImage, width: 384, height: 384);

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

      List<Map<String, dynamic>> results = List<Map<String, dynamic>>.from(
          jsonDecode(response.body)
              .map((item) => Map<String, dynamic>.from(item)));

      //top answer
      result1 = results[0]['answer'];
      score1 = results[0]['score'];

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          result = 'Error: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        result = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside text field
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'AI Questions',
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
        backgroundColor: lighterTertiaryColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_image != null) ...[
                      Container(
                        height: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: InteractiveViewer(
                            maxScale: 5.0,
                            child: Image.file(_image!, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ] else ...[
                      Container(
                        height: 280,
                        decoration: BoxDecoration(
                          color: secondaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
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
                      ),
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                            actions: [
                              CupertinoActionSheetAction(
                                child: const Text('Photo Gallery'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _getImage(ImageSource.gallery);
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: const Text('Camera'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _getImage(ImageSource.camera);
                                },
                              ),
                            ],
                          ),
                        );
                      },
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
                    TextFormField(
                      focusNode: _questionFocusNode,
                      controller: _textControl,
                      decoration: InputDecoration(
                        hintText: 'Ask a question about the image...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      minLines: 3,
                      maxLines: 5,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: (_image == null || _textControl.text.isEmpty)
                          ? null
                          : () {
                        // Dismiss keyboard
                        FocusScope.of(context).unfocus();
                        // Call analyze method
                        analyzeSentiment(
                            _textControl.text, _image!.path, _image!);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkerSecondaryColor,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "ANALYZE IMAGE",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_isLoading)
                      Loading()
                    else if (result1.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: lighterPrimaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'AI ANSWER',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '${(score1 * 100).toStringAsPrecision(3)}% Confidence',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              result1,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}