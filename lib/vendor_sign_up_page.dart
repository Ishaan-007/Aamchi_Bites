import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_food_app/vendor_main_page.dart';

class VendorSignUpPage extends StatefulWidget {
  @override
  _VendorSignUpPageState createState() => _VendorSignUpPageState();
}

class _VendorSignUpPageState extends State<VendorSignUpPage> {
  final Color themeColor = const Color(0xFFF2A43D);
  bool _isLogin = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _vendorNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _contactController = TextEditingController();
  final _timingsController = TextEditingController();

  File? _image;
  final _picker = ImagePicker();
  String _response = '';
  double? _currentLatitude;
  double? _currentLongitude;
  String? _locationName;

  List<_MenuItem> _menuItems = [];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _vendorNameController.dispose();
    _cityController.dispose();
    _contactController.dispose();
    _timingsController.dispose();
    for (var item in _menuItems) {
      item.nameController.dispose();
      item.priceController.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _response = 'Enable location services.');
      return;
    }
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) {
        setState(() => _response = 'Location permission denied.');
        return;
      }
    }
    if (perm == LocationPermission.deniedForever) {
      setState(() => _response = 'Permission permanently denied.');
      return;
    }
    try {
      Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLatitude = pos.latitude;
        _currentLongitude = pos.longitude;
        _response = 'Coordinates fetched.';
      });
      await _reverseGeocode(pos.latitude, pos.longitude);
    } catch (e) {
      setState(() => _response = 'Error: $e');
    }
  }

  Future<void> _reverseGeocode(double lat, double lon) async {
    try {
      List<Placemark> places = await placemarkFromCoordinates(lat, lon);
      if (places.isNotEmpty) {
        final p = places.first;
        final parts = [
          p.subThoroughfare,
          p.thoroughfare,
          p.subLocality,
          p.locality,
          p.subAdministrativeArea,
          p.administrativeArea,
          p.country,
        ].whereType<String>().where((part) => part.isNotEmpty).toList();
        setState(() {
          _locationName = parts.join(', ');
          _response = 'Resolved location.';
        });
      } else {
        setState(() => _response = 'No placemark found.');
      }
    } catch (e) {
      setState(() => _response = 'Geocode error: $e');
    }
  }

  Future<void> _toggleMode() async {
    setState(() {
      _isLogin = !_isLogin;
      _response = '';
    });
  }

  Future<void> _authenticate() async {
    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } else {
        final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        await _saveVendorData(cred.user!.uid);
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => VendorHomePage()));
    } catch (e) {
      setState(() => _response = '${_isLogin ? 'Login' : 'Signup'} error: $e');
    }
  }

  Future<void> _saveVendorData(String uid) async {
    final col = FirebaseFirestore.instance.collection('vendors');
    final query = await col.where('user_id', isEqualTo: uid).get();

    final menu = _menuItems.map((item) {
      final price = double.tryParse(item.priceController.text);
      return {
        'name': item.nameController.text,
        'price': price ?? 0.0,
      };
    }).toList();

    final data = {
      'user_id': uid,
      'name': _vendorNameController.text,
      'email': _emailController.text,
      'city': _cityController.text,
      'contact': _contactController.text,
      'location': _locationName,
      'timings': _timingsController.text,
      'menu': menu,
      'rating': 0.0,
      'recentReviewCount': 0,
    };

    if (query.docs.isNotEmpty) {
      await col.doc(query.docs.first.id).update(data);
    } else {
      await col.add(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Vendor Login' : 'Vendor Sign Up'),
        backgroundColor: themeColor,
        actions: [
          TextButton(
            onPressed: _toggleMode,
            child: Text(
              _isLogin ? 'Switch to Sign Up' : 'Switch to Login',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(_emailController, 'Email'),
            _buildTextField(_passwordController, 'Password', obscure: true),
            if (!_isLogin) ...[
              _buildTextField(_vendorNameController, 'Vendor Name'),
              _buildTextField(_cityController, 'City'),
              _buildTextField(_contactController, 'Contact'),
              _buildTextField(_timingsController, 'Timings'),
              _spacer(),
              ElevatedButton(
                style: _elevatedStyle(),
                onPressed: _pickImage,
                child: Text('Pick Shop Image'),
              ),
              if (_image != null) ...[
                _spacer(),
                Image.file(_image!, height: 150),
              ],
              _spacer(),
              ElevatedButton(
                style: _elevatedStyle(),
                onPressed: _getCurrentLocation,
                child: Text('Fetch Current Location'),
              ),
              if (_locationName != null) ...[
                _spacer(8),
                Text('Location: $_locationName', style: TextStyle(color: Colors.grey[700])),
              ],
              _spacer(),
              Text('Menu Items:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ..._menuItems.map((item) => Row(
                    children: [
                      Expanded(child: _buildTextField(item.nameController, 'Item Name')),
                      SizedBox(width: 8),
                      Expanded(
                        child: _buildTextField(item.priceController, 'Price', inputType: TextInputType.number),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: themeColor),
                        onPressed: () => setState(() => _menuItems.remove(item)),
                      )
                    ],
                  )),
              TextButton.icon(
                onPressed: () => setState(() => _menuItems.add(_MenuItem())),
                icon: Icon(Icons.add, color: themeColor),
                label: Text('Add Menu Item', style: TextStyle(color: themeColor)),
              ),
            ],
            _spacer(24),
            ElevatedButton(
              style: _elevatedStyle(),
              onPressed: _authenticate,
              child: Text(_isLogin ? 'Login' : 'Sign Up'),
            ),
            if (_response.isNotEmpty) ...[
              _spacer(),
              Text(
                _response,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscure = false, TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: themeColor, width: 2),
          ),
        ),
      ),
    );
  }

  ButtonStyle _elevatedStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: themeColor,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 12),
    );
  }

  Widget _spacer([double height = 16]) => SizedBox(height: height);
}

class _MenuItem {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
}
