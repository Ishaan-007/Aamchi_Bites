import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_food_app/main_page.dart';
import 'package:street_food_app/login_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final firestore = FirebaseFirestore.instance;
  final dbRef = FirebaseDatabase.instance.ref("users");

  Future<void> createUserWithEmailAndPassword() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());

      // Firestore: store user data
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        "email": emailController.text.trim(),
        "uid": userCredential.user!.uid,
        "createdAt": DateTime.now(),
      });

      // Realtime DB: optional
      await dbRef.child(userCredential.user!.uid).set({
        "email": emailController.text.trim(),
        "uid": userCredential.user!.uid,
      });

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => MainPage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup failed: ${e.toString()}")));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: createUserWithEmailAndPassword,
                  child: Text("Sign Up")),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => LoginPage()));
                },
                child: Text("Already have an account? Sign in"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//signupdart