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
  bool _isLoading = false;
  bool _obscurePassword = true;

  final firestore = FirebaseFirestore.instance;
  final dbRef = FirebaseDatabase.instance.ref("users");

  Future<void> createUserWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
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
          SnackBar(
            content: Text("Signup failed: ${e.toString()}"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
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
      backgroundColor: Color(0xFFF2A43D), // Orange background
      resizeToAvoidBottomInset: false, // Prevent scrolling when keyboard opens
      body: SafeArea(
        child: Column(
          children: [
            // Top Design Section - Made more compact
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: Column(
                children: [
                  Text(
                    'पुढील स्थानक',
                    style: TextStyle(
                      fontFamily: "TiroDevanagariHindi",
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'MUMBAI',
                    style: TextStyle(
                      fontFamily: "Fredoka",
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF457c43),
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
            ),

            // Form Container - Made smaller
            Container(
              height: MediaQuery.of(context).size.height * 0.45, // Reduced from 0.6 to 0.45
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Sign Up Text
                    Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),

                    // Compact Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email Field - Compact
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(color: Colors.grey[700], fontSize: 14),
                              prefixIcon: Icon(Icons.email_outlined, color: Color(0xFFF2A43D), size: 20),
                              filled: true,
                              fillColor: Colors.grey[100],
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFFF2A43D), width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.red, width: 1),
                              ),
                              errorStyle: TextStyle(fontSize: 10), // Smaller error text
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),

                          // Password Field - Compact
                          TextFormField(
                            controller: passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(color: Colors.grey[700], fontSize: 14),
                              prefixIcon: Icon(Icons.lock_outline, color: Color(0xFFF2A43D), size: 20),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey[600],
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() => _obscurePassword = !_obscurePassword);
                                },
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFFF2A43D), width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.red, width: 1),
                              ),
                              errorStyle: TextStyle(fontSize: 10), // Smaller error text
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),

                          // Sign Up Button - Compact
                          Container(
                            width: double.infinity,
                            height: 42,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : createUserWithEmailAndPassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFF2A43D),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              child: _isLoading
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      'Get Started',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: 12),

                          // Sign In Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: TextStyle(color: Colors.grey[600], fontSize: 13),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) => LoginPage()));
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size(50, 30),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Color(0xFFF2A43D),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Mumbai-themed text
                          SizedBox(height: 8),
                          Text(
                            'Your Street Food Journey Begins Here',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Train Image Container with original background
            Expanded(
              child: Container(
                width: double.infinity,
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'assets/images/train.png',
                  height: 500, // You wanted 500 based on your code
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}