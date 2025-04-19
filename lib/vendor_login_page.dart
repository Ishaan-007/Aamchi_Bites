import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VendorLoginPage extends StatefulWidget {
  @override
  _VendorLoginPageState createState() => _VendorLoginPageState();
}

class _VendorLoginPageState extends State<VendorLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vendor Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            ElevatedButton(
              onPressed: () => _loginVendor(),
              child: Text('Login as Vendor'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loginVendor() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (userCredential.user != null) {
        await _updateVendorLocation(userCredential.user!.uid);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vendor logged in successfully')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error logging in: $e')));
    }
  }

  Future<void> _updateVendorLocation(String userId) async {
    // Retrieve vendor data and update the location if necessary
    CollectionReference vendors = FirebaseFirestore.instance.collection('vendors');
    var vendorData = await vendors.doc(userId).get();
    if (vendorData.exists) {
      // Update vendor location in Firestore if required
    }
  }
}