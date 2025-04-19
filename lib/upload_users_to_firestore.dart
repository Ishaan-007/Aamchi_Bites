import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadUsersJsonToFirestore extends StatelessWidget {
  const UploadUsersJsonToFirestore({super.key});

  Future<void> uploadJsonToFirestore() async {
    try {
      // Load the JSON file from assets
      String jsonString = await rootBundle.loadString('assets/user_profile.json');
      List<dynamic> users = json.decode(jsonString);

      for (var user in users) {
        String email = user['email'];
        await FirebaseFirestore.instance
            .collection('user')
            .doc(email)
            .set(Map<String, dynamic>.from(user));
      }

      print('✅ User data uploaded from assets!');
    } catch (e) {
      print('❌ Error uploading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload User JSON to Firestore')),
      body: Center(
        child: ElevatedButton(
          onPressed: uploadJsonToFirestore,
          child: Text('Upload Users from Assets'),
        ),
      ),
    );
  }
}
