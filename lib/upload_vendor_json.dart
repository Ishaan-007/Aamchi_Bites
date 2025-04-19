import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadVendorJsonToFirestore extends StatelessWidget {
  const UploadVendorJsonToFirestore({super.key});

  Future<void> uploadJsonToFirestore() async {
    try {
      // Load the JSON file from assets
      String jsonString = await rootBundle.loadString('assets/mumbai_vendors_50_updated.json');
      Map<String, dynamic> data = json.decode(jsonString);

      // Loop through each vendor
      for (String vendorId in data.keys) {
        Map<String, dynamic> vendorData = data[vendorId];

        // Extract and remove reviews from main data
        Map<String, dynamic>? reviews = vendorData.remove('reviews');

        // Upload vendor document
        await FirebaseFirestore.instance.collection('vendors').doc(vendorId).set(vendorData);

        // Upload reviews to subcollection if present
        if (reviews != null) {
          for (String reviewId in reviews.keys) {
            await FirebaseFirestore.instance
                .collection('vendors')
                .doc(vendorId)
                .collection('reviews')
                .doc(reviewId)
                .set(reviews[reviewId]);
          }
        }
      }

      print('✅ Vendor data uploaded from assets!');
    } catch (e) {
      print('❌ Error uploading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Vendor JSON to Firestore')),
      body: Center(
        child: ElevatedButton(
          onPressed: uploadJsonToFirestore,
          child: Text('Upload from Assets'),
        ),
      ),
    );
  }
}
