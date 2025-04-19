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
  bool _isLogin = false;

  // Shared controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Signup-specific controllers
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
        final subThoroughfare = p.subThoroughfare ?? '';
        final thoroughfare = p.thoroughfare ?? '';
        final subLocality = p.subLocality ?? '';
        final locality = p.locality ?? '';
        final subAdminArea = p.subAdministrativeArea ?? '';
        final adminArea = p.administrativeArea ?? '';
        final country = p.country ?? '';
        final parts = [
          if (subThoroughfare.isNotEmpty) subThoroughfare,
          if (thoroughfare.isNotEmpty) thoroughfare,
          if (subLocality.isNotEmpty) subLocality,
          if (locality.isNotEmpty) locality,
          if (subAdminArea.isNotEmpty) subAdminArea,
          if (adminArea.isNotEmpty) adminArea,
          if (country.isNotEmpty) country,
        ];
        setState(() {
          _locationName = parts.join(', ');
          _response = 'Resolved location.';
        });
        print('Resolved address: $_locationName');
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
    if (_isLogin) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => VendorHomePage()),
        );
      } catch (e) {
        setState(() => _response = 'Login error: $e');
      }
    } else {
      try {
        final cred = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        await _saveVendorData(cred.user!.uid);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => VendorHomePage()),
        );
      } catch (e) {
        setState(() => _response = 'Signup error: $e');
      }
    }
  }

  Future<void> _saveVendorData(String uid) async {
    final col = FirebaseFirestore.instance.collection('vendors');
    final query = await col.where('user_id', isEqualTo: uid).get();

    // Build menu list
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
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (!_isLogin) ...[
              SizedBox(height: 16),
              TextField(
                controller: _vendorNameController,
                decoration: InputDecoration(labelText: 'Vendor Name'),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'City'),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _contactController,
                decoration: InputDecoration(labelText: 'Contact'),
              ),
              SizedBox(height: 16),
              ElevatedButton(onPressed: _pickImage, child: Text('Pick Shop Image')),
              if (_image != null) ...[
                SizedBox(height: 8),
                Image.file(_image!, height: 150),
              ],
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _getCurrentLocation,
                child: Text('Fetch Current Location'),
              ),
              if (_locationName != null) ...[
                SizedBox(height: 8),
                Text('Location: $_locationName'),
              ],
              SizedBox(height: 16),
              TextField(
                controller: _timingsController,
                decoration: InputDecoration(labelText: 'Timings'),
              ),
              SizedBox(height: 16),
              Text('Menu Items:', style: TextStyle(fontWeight: FontWeight.bold)),
              ..._menuItems.map((item) => Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: item.nameController,
                          decoration: InputDecoration(labelText: 'Item Name'),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: item.priceController,
                          decoration: InputDecoration(labelText: 'Price'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _menuItems.remove(item);
                          });
                        },
                      )
                    ],
                  )),
              TextButton.icon(
                onPressed: () => setState(() => _menuItems.add(_MenuItem())),
                icon: Icon(Icons.add),
                label: Text('Add Menu Item'),
              ),
            ],
            SizedBox(height: 24),
            ElevatedButton(onPressed: _authenticate, child: Text(_isLogin ? 'Login' : 'Sign Up')),
            if (_response.isNotEmpty) ...[
              SizedBox(height: 16),
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
}

class _MenuItem {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
}
