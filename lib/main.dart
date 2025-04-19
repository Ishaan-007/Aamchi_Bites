import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:street_food_app/aamchi_bites_app.dart';
import 'package:street_food_app/chat_screen.dart';
import 'package:street_food_app/community_feedback_integration.dart';
import 'package:street_food_app/flavour_passport_profile.dart';
import 'package:street_food_app/food_place_screen.dart';
import 'package:street_food_app/main_page.dart';
import 'package:street_food_app/optimized_route_map.dart';
import 'package:street_food_app/recommendation_screen.dart';
import 'package:street_food_app/sign_up_page.dart';
import 'package:street_food_app/upload_users_to_firestore.dart';
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