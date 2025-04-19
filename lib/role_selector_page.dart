import 'package:flutter/material.dart';
import 'package:street_food_app/sign_up_page.dart';
import 'package:street_food_app/vendor_sign_up_page.dart';
  // Vendor signup page

class RoleSelectorPage extends StatefulWidget {
  const RoleSelectorPage({super.key});

  @override
  State<RoleSelectorPage> createState() => _RoleSelectorPageState();
}

class _RoleSelectorPageState extends State<RoleSelectorPage> {
  bool isUser = false;
  bool isVendor = false;

  void _continue() {
    if (isUser && !isVendor) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SignUpPage()),
      );
    } else if (isVendor && !isUser) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VendorSignUpPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select only one role to continue.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Role'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Register as:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            CheckboxListTile(
              title: const Text("User"),
              value: isUser,
              onChanged: (bool? value) {
                setState(() {
                  isUser = value!;
                  if (isUser) isVendor = false;
                });
              },
              activeColor: Colors.deepOrange,
            ),
            CheckboxListTile(
              title: const Text("Vendor"),
              value: isVendor,
              onChanged: (bool? value) {
                setState(() {
                  isVendor = value!;
                  if (isVendor) isUser = false;
                });
              },
              activeColor: Colors.green,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _continue,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}