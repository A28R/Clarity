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
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;
  late TextEditingController _textControl;

  // Replace with your actual API token
  static const String API_TOKEN = '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';
  static const String API_URL = 'https://api-inference.huggingface.co/models/dandelin/vilt-b32-finetuned-vqa';

  File? _image;
  final ImagePicker _picker = ImagePicker();
  String result = '';
  String result1 = '';
  String result2 = '';
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


        List<Map<String, dynamic>> results = List<Map<String, dynamic>>.from(
            jsonDecode(response.body).map((item) => Map<String, dynamic>.from(item))
        );

        //top 2 answers
        result1 = results[0]['answer'];
        result2 = results[1]['answer'];
        print("Top 2 results in descending order (1-2)");
        print(result1);
        print(result2);


        if (response.statusCode == 200) {
        } else {
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
      backgroundColor: lighterTertiaryColor,
      appBar: AppBar(
        title: Text(
          'AI Questions'.toUpperCase(),
          style: TextStyle(
              color: lighterTertiaryColor,
              fontWeight: FontWeight.w800,
              fontSize: 24),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: oppositeTertiaryColor,
        leading: TextButton(
          child: Icon(
            Icons.arrow_back_ios,
            color: tertiaryColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();

        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: darkerSecondaryColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: lighterTertiaryColor),
                  ),
                  child:                 Text(
                    "QUESTION PROMPT:".toUpperCase(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: lighterTertiaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 24),
                TextFormField(
                  controller: _textControl,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your question about the image...',
                  ),
                  minLines: 5,
                  maxLines: 10,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(

                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(lighterTertiaryColor), elevation: MaterialStateProperty.all<double>(7)),
                      onPressed: () => _getImage(ImageSource.gallery),
                      icon: Icon(Icons.image, color: oppositeTertiaryColor,),
                      label: Text('Select Image'.toUpperCase(), style: TextStyle(color: oppositeTertiaryColor),),
                    ),
                    ElevatedButton.icon(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(darkerSecondaryColor), elevation: MaterialStateProperty.all<double>(7)),
                      onPressed: _image == null || _textControl.text.isEmpty
                          ? null
                          : () => analyzeSentiment(_textControl.text, _image!.path, _image!),
                      icon: Icon(Icons.send, color: lighterTertiaryColor,),
                      label: Text('Analyze'.toUpperCase(), style: TextStyle(color: lighterTertiaryColor),),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                const SizedBox(height: 16),
                if (_image != null) ...[
                  Image.file(
                    _image!,
                    height: 250,
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
                else if (result1.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: darkerSecondaryColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: lighterTertiaryColor),
                    ),
                    child: Text(result1.toUpperCase(),style:  TextStyle(fontSize: 24, color: lighterTertiaryColor, fontWeight: FontWeight.w700), textAlign: TextAlign.center,),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}