import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:street_food_app/chat_screen.dart';
import 'package:street_food_app/main_page.dart';
import 'package:street_food_app/sign_up_page.dart';
import 'package:street_food_app/upload_vendor_json.dart';
import 'package:street_food_app/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khana Khazaana', // 🍲 Updated title
      home: WelcomePage(),      // App starts with Sign Up
      debugShowCheckedModeBanner: false,
    );
  }
}