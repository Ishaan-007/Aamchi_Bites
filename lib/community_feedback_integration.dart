import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_food_app/vendor_profile_page.dart';

class CommunityFeedbackIntegration extends StatefulWidget {
  @override
  _CommunityFeedbackIntegrationState createState() => _CommunityFeedbackIntegrationState();
}

class _CommunityFeedbackIntegrationState extends State<CommunityFeedbackIntegration> {
  String searchQuery = '';

  final Color goldenYellow = const Color(0xFFFFC107);

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'red':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget buildRatingStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(Icons.star,
            size: 20, color: index < rating.round() ? goldenYellow : Colors.grey[300]);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: goldenYellow,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: goldenYellow,
          secondary: goldenYellow,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Community Feedback"),
          backgroundColor: goldenYellow,
          foregroundColor: Colors.black,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                onChanged: (value) => setState(() => searchQuery = value.toLowerCase()),
                decoration: InputDecoration(
                  hintText: 'Search by vendor or location',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: goldenYellow, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('vendors').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                  var filteredDocs = snapshot.data!.docs.where((doc) {
                    final name = doc['name'].toString().toLowerCase();
                    final location = doc['location'].toString().toLowerCase();
                    return name.contains(searchQuery) || location.contains(searchQuery);
                  });

                  return ListView(
                    children: filteredDocs.map((doc) {
                      double rating = doc['rating']?.toDouble() ?? 0.0;
                      String name = doc['name'];
                      String location = doc['location'];
                      String contact = doc['contact'];
                      String timings = doc['timings'];
                      int reviewsInLastHour = doc['recentReviewCount'] ?? 0;
                      double hygieneScore = doc['avg_hygiene_score']?.toDouble() ?? 0.0;
                      String status = doc['status'] ?? 'unknown';
                      List<dynamic> menuItems = doc['menu'] ?? [];

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => VendorProfilePage(vendorId: doc.id),
                            ));
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                    ),
                                    CircleAvatar(
                                      radius: 7,
                                      backgroundColor: getStatusColor(status),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                buildRatingStars(rating),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.location_pin, size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Expanded(child: Text(location)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.phone, size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(contact),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(timings),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text("🧼 Hygiene Score: ${hygieneScore.toStringAsFixed(1)}",
                                    style: const TextStyle(fontWeight: FontWeight.w500)),
                                if (menuItems.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      "🍽 Menu: ${menuItems.map((item) => item['name']).take(3).join(', ')}...",
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  ),
                                if (reviewsInLastHour >= 2)
                                  Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      "🔥 Hot & Happening",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
