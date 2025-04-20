import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class VendorHomePage extends StatefulWidget {
  final String vendorEmail;
  VendorHomePage({required this.vendorEmail});

  @override
  _VendorHomePageState createState() => _VendorHomePageState();
}

class _VendorHomePageState extends State<VendorHomePage> {
  bool isOnline = true;
  int? selectedRating;
  final ScrollController _scrollController = ScrollController();

  Future<DocumentSnapshot?> fetchVendorData() async {
    final query = await FirebaseFirestore.instance
        .collection('vendors')
        .where('email', isEqualTo: widget.vendorEmail)
        .limit(1)
        .get();
    return query.docs.isEmpty ? null : query.docs.first;
  }

  Stream<QuerySnapshot> fetchReviews(String vendorId) {
    Query ref = FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorId)
        .collection('reviews');

    if (selectedRating != null) {
      ref = ref.where('rating', isEqualTo: selectedRating);
    }

    return ref.orderBy('timestamp', descending: true).snapshots();
  }

  String _formatTimestamp(String timestamp) {
    try {
      return DateFormat('dd MMM yyyy • HH:mm')
          .format(DateTime.parse(timestamp));
    } catch (e) {
      return 'Invalid date';
    }
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 18,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2A43D),
      body: FutureBuilder<DocumentSnapshot?>(
        future: fetchVendorData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.white));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Vendor not found', style: TextStyle(color: Colors.white)));
          }

          final vendorData = snapshot.data!;
          final vendorId = vendorData.id;
          final menuItems = List<Map<String, dynamic>>.from(vendorData['menu'] ?? []);
          final name = vendorData['name'] ?? 'Vendor';
          final hygieneScore = (vendorData['avg_hygiene_score'] ?? 0).toDouble();
          final rating = (vendorData['rating'] ?? 0).toDouble();
          final timings = vendorData['timings'] ?? '';

          return SafeArea(
            child: Column(
              children: [
                // Header Section
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'नमस्ते,',
                                style: TextStyle(
                                  fontFamily: "TiroDevanagariHindi",
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),),
                            child: Row(
                              children: [
                                Icon(
                                  isOnline ? Icons.check_circle : Icons.cancel,
                                  color: isOnline ? Colors.green : Colors.red,
                                ),
                                Switch(
                                  value: isOnline,
                                  onChanged: (value) => setState(() => isOnline = value),
                                  activeColor: Colors.green,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatCard(
                            'Hygiene',
                            '${hygieneScore.toStringAsFixed(1)}/10',
                            Icons.health_and_safety,
                          ),
                          _buildStatCard(
                            'Rating',
                            rating.toStringAsFixed(1),
                            Icons.star,
                          ),
                          _buildStatCard(
                            'Timings',
                            timings,
                            Icons.access_time,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Content Section
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Menu Section
                          Text('🍔 Menu', style: _sectionTitleStyle),
                          SizedBox(height: 10),
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              itemCount: menuItems.length,
                              itemBuilder: (context, index) {
                                final item = menuItems[index];
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(item['name'], 
                                      style: TextStyle(fontWeight: FontWeight.w500)),
                                  trailing: Text('₹${item['price']}', 
                                      style: TextStyle(color: Color(0xFFF2A43D))),
                                );
                              },
                            ),
                          ),
                          
                          // Reviews Filter
                          Divider(thickness: 1),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Text('🔍 Filter Reviews:', style: _sectionTitleStyle),
                                SizedBox(width: 10),
                                DropdownButton<int>(
                                  value: selectedRating,
                                  hint: Text("All Ratings"),
                                  dropdownColor: Colors.white,
                                  onChanged: (val) => setState(() => selectedRating = val),
                                  items: [
                                    DropdownMenuItem(value: null, child: Text('All')),
                                    ...List.generate(5, (i) => 
                                      DropdownMenuItem(value: i+1, child: Text('${i+1} ★')))
                                  ],
                                ),
                                if (selectedRating != null)
                                  TextButton(
                                    onPressed: () => setState(() => selectedRating = null),
                                    child: Text('Clear', style: TextStyle(color: Colors.red)),
                                  )
                              ],
                            ),
                          ),

                          // Reviews List
                          Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: fetchReviews(vendorId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                  return Center(child: Text("No reviews found"));
                                }

                                return ListView.builder(
                                  controller: _scrollController,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    final review = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                                    return _buildReviewCard(review);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(review['username'] ?? 'Anonymous', 
                    style: TextStyle(fontWeight: FontWeight.bold)),
                _buildRatingStars(review['rating'] ?? 0),
              ],
            ),
            SizedBox(height: 8),
            if (review['title'] != null)
              Text(review['title'], 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            if (review['description'] != null)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(review['description'], 
                    style: TextStyle(color: Colors.grey[600])),
              ),
            SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildRatingChip('🧼 Cleanliness', review['cleanliness']),
                _buildRatingChip('🥦 Ingredients', review['ingredient_quality']),
                _buildRatingChip('💧 Water Safety', review['water_safety']),
                if (review['recommend'] != null)
                  Chip(
                    avatar: Icon(review['recommend'] ? Icons.thumb_up : Icons.thumb_down,
                        size: 18),
                    label: Text(review['recommend'] ? 'Recommends' : "Doesn't recommend"),
                    backgroundColor: review['recommend'] ? Colors.green[50] : Colors.red[50],
                  ),
              ],
            ),
            SizedBox(height: 8),
            //Text(_formatTimestamp(review['timestamp'])),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingChip(String label, dynamic value) {
    return Chip(
      avatar: Text(value?.toString() ?? '-', 
          style: TextStyle(color: Color(0xFFF2A43D))),
      label: Text(label),
      backgroundColor: Colors.grey[100],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12),
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Color(0xFFF2A43D), size: 28),
          SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  TextStyle get _sectionTitleStyle => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );
}