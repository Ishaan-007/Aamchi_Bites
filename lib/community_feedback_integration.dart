import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_food_app/vendor_profile_page.dart';

class CommunityFeedbackIntegration extends StatefulWidget {
  @override
  _CommunityFeedbackIntegrationState createState() => _CommunityFeedbackIntegrationState();
}

class _CommunityFeedbackIntegrationState extends State<CommunityFeedbackIntegration> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Community Feedback")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value.toLowerCase()),
              decoration: InputDecoration(
                labelText: 'Search by location or vendor name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('vendors').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                var filteredDocs = snapshot.data!.docs.where((doc) {
                  final name = doc['name'].toString().toLowerCase();
                  final location = doc['location'].toString().toLowerCase();
                  return name.contains(searchQuery) || location.contains(searchQuery);
                });

                return ListView(
                  children: filteredDocs.map((doc) {
                    double rating = doc['rating'] ?? 0.0;
                    String name = doc['name'];
                    String location = doc['location'];
                    String contact = doc['contact'];
                    String timings = doc['timings'];
                    int reviewsInLastHour = doc['recentReviewCount'] ?? 0;

                    return Card(
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(Icons.star, size: 20, color: index < rating.round() ? Colors.amber : Colors.grey);
                              }),
                            ),
                            Text("📍 $location"),
                            Text("📞 $contact"),
                            Text("🕘 $timings"),
                            if (reviewsInLastHour >= 2)
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(4)),
                                child: Text("🔥 Hot & Happening", style: TextStyle(color: Colors.white)),
                              )
                          ],
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (_) => VendorProfilePage(vendorId: doc.id),
                          ));
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}