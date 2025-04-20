import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VendorHomePage extends StatefulWidget {
  final String vendorEmail;
  VendorHomePage({required this.vendorEmail});

  @override
  _VendorHomePageState createState() => _VendorHomePageState();
}

class _VendorHomePageState extends State<VendorHomePage> {
  bool isOnline = true;

  Future<DocumentSnapshot?> fetchVendorData() async {
    final query = await FirebaseFirestore.instance
        .collection('vendors')
        .where('email', isEqualTo: widget.vendorEmail)
        .limit(1)
        .get();
    if (query.docs.isNotEmpty) {
      return query.docs.first;
    }
    return null;
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
          final menuItems = List<Map<String, dynamic>>.from(vendorData['menu'] ?? []);
          final name = vendorData['name'] ?? 'Vendor';
          final hygieneScore = vendorData['avg_hygiene_score'] != null? (vendorData['avg_hygiene_score'] as num).toStringAsFixed(2)
          : '-';
          final rating = vendorData['rating']?.toString() ?? '-';
          final timings = vendorData['timings'] ?? '';

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar & Info
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Greeting
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('नमस्ते,',
                                  style: TextStyle(
                                    fontFamily: "TiroDevanagariHindi",
                                    fontSize: 22,
                                    color: Colors.white,
                                  )),
                              Text(name,
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                          // Online toggle
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isOnline ? Icons.wifi : Icons.wifi_off,
                                  color: isOnline ? Colors.green : Colors.red,
                                  size: 22,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  isOnline ? 'Online' : 'Offline',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isOnline ? Colors.green : Colors.red,
                                  ),
                                ),
                                Switch(
                                  value: isOnline,
                                  onChanged: (value) {
                                    setState(() => isOnline = value);
                                  },
                                  activeColor: Colors.green,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 24),
                      // Stat Cards
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatCard('Hygiene', hygieneScore, Icons.clean_hands),
                          _buildStatCard('Rating', rating, Icons.star_rounded),
                          _buildStatCard('Timings', timings, Icons.schedule_rounded),
                        ],
                      ),
                    ],
                  ),
                ),

                // Menu Section
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Menu",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            )),
                        SizedBox(height: 12),
                        Expanded(
                          child: ListView.separated(
                            itemCount: menuItems.length,
                            separatorBuilder: (_, __) => SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = menuItems[index];
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    )
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(item['name'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        )),
                                    Text("₹${item['price']}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFF2A43D),
                                        )),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      width: 110,
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 36, color: Color(0xFFF2A43D)),
          SizedBox(height: 10),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
