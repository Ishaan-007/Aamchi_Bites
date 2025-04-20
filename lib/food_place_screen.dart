import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class Vendor {
  final String name;
  final String location;
  final String contact;
  final double rating;
  final int recentReviewCount;
  final String timings;
  final List<Map<String, dynamic>> menu;

  Vendor({
    required this.name,
    required this.location,
    required this.contact,
    required this.rating,
    required this.recentReviewCount,
    required this.timings,
    required this.menu,
  });

  factory Vendor.fromFirestore(Map<String, dynamic> data) {
    return Vendor(
      name: data['name'] ?? 'Unknown Vendor',
      location: data['location'] ?? 'Address not available',
      contact: data['contact'] ?? 'Contact not available',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      recentReviewCount: data['recentReviewCount'] ?? 0,
      timings: data['timings'] ?? 'Timings not available',
      menu: List<Map<String, dynamic>>.from(
        (data['menu'] as List<dynamic>?)?.map((item) => {
          'name': item['name'] ?? '',
          'price': item['price'] ?? 0,
        }) ?? [],
      ),
    );
  }
}

class FoodPlaceScreen extends StatefulWidget {
  @override
  _FoodPlaceScreenState createState() => _FoodPlaceScreenState();
}

class _FoodPlaceScreenState extends State<FoodPlaceScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<List<Vendor>> _vendorsFuture;

  Future<List<Vendor>> _fetchVendors() async {
    try {
      // Fetch vendor names from API
      final apiResponse = await http.get(Uri.parse('http://10.0.2.2:5000'));
      if (apiResponse.statusCode != 200) throw Exception('API request failed');
      
      final List<dynamic> jsonData = json.decode(apiResponse.body);
      final List<String> vendorNames = jsonData
          .map((item) => item['vendor_name'] as String?)
          .where((name) => name != null)
          .cast<String>()
          .toList();

      // Fetch vendor details from Firestore
      List<Vendor> vendors = [];
      for (String name in vendorNames) {
        final query = await _firestore
            .collection('vendors')
            .where('name', isEqualTo: name)
            .limit(1)
            .get();

        if (query.docs.isNotEmpty) {
          vendors.add(Vendor.fromFirestore(query.docs.first.data()));
        }
      }

      return vendors;
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _vendorsFuture = _fetchVendors();
  }

  Widget _buildVendorCard(Vendor vendor) {
    return Card(
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    vendor.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A7A69),
                    ),
                  ),
                ),
                Chip(
                  label: Text('⭐ ${vendor.rating.toStringAsFixed(1)}'),
                  backgroundColor: Colors.amber[100],
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildInfoRow(Icons.location_on, vendor.location),
            _buildInfoRow(Icons.phone, vendor.contact),
            _buildInfoRow(Icons.access_time, vendor.timings),
            SizedBox(height: 12),
            Text(
              'Menu Items:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: vendor.menu.length,
              itemBuilder: (context, index) => Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(vendor.menu[index]['name']),
                    Text(
                      '₹${vendor.menu[index]['price']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2A43D),
      appBar: AppBar(
        title: Text('Top Food Vendors'),
        elevation: 0,
      ),
      body: FutureBuilder<List<Vendor>>(
        future: _vendorsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No vendors found'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => _buildVendorCard(snapshot.data![index]),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: FoodPlaceScreen()));
}