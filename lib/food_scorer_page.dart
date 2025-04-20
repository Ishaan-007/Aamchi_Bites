import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class FoodScorerPage extends StatefulWidget {
  @override
  _FoodScorerPageState createState() => _FoodScorerPageState();
}

class _FoodScorerPageState extends State<FoodScorerPage> {
  File? _image;
  Map<String, dynamic>? scores;
  bool isLoading = false;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        scores = null;
      });
      await sendImageToModel(_image!);
    }
  }

  Future<void> sendImageToModel(File image) async {
    setState(() {
      isLoading = true;
    });
    
    // Replace with your actual backend URL
    final uri = Uri.parse('https://your-actual-backend-url.com/predict');
    
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', image.path));
    
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        setState(() {
          scores = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        print('Error: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Exception when sending image: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildScore(String title, dynamic score) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          score.toStringAsFixed(1),
          style: const TextStyle(fontSize: 24, color: Colors.teal),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Food Image Scorer")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_image != null) Image.file(_image!, height: 200),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.image),
              label: const Text("Pick Image"),
              onPressed: pickImage,
            ),
            const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
            if (scores != null) ...[
              buildScore("Cleanliness", scores!["cleanliness"]),
              buildScore("Ingredient Quality", scores!["ingredient_quality"]),
              buildScore("Water Safety", scores!["water_safety"]),
            ],
          ],
        ),
      ),
    );
  }
}