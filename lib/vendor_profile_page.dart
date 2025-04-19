import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'feedback_form.dart';

final goldenTheme = ThemeData(
  primarySwatch: Colors.amber,
  scaffoldBackgroundColor: const Color(0xFFFFF8E1),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFFD54F),
    foregroundColor: Colors.black,
    elevation: 2,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFFFC107),
      foregroundColor: Colors.black,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
  cardColor: Color(0xFFFFF9C4),
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: Colors.black87),
  ),
);

class VendorProfilePage extends StatelessWidget {
  final String vendorId;
  VendorProfilePage({required this.vendorId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: goldenTheme,
      home: Scaffold(
        appBar: AppBar(title: Text("Vendor Profile")),
        body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('vendors').doc(vendorId).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

            var vendor = snapshot.data!;
            var data = vendor.data() as Map<String, dynamic>;

            var name = data['name'] ?? 'Unnamed';
            var location = data['location'] ?? 'Unknown';
            var contact = data['contact'] ?? 'N/A';
            var timings = data['timings'] ?? 'N/A';
            var menu = data['menu'] ?? [];
            var hygieneScore = data['avg_hygiene_score']?.toDouble() ?? 0.0;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text("📍 $location\n📞 $contact\n🕘 $timings"),
                  SizedBox(height: 6),
                  Text("🧼 Hygiene Score: ${hygieneScore.toStringAsFixed(1)}"),
                  Divider(),

                  ReviewList(vendorId: vendorId),

                  Divider(),
                  Text("🍽 Menu & Best Sellers", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ...menu.map<Widget>((item) {
                    var itemName = item['name'] ?? 'Unnamed';
                    var itemPrice = item['price'] != null ? "₹${item['price']}" : 'N/A';
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 0),
                      title: Text(itemName),
                      trailing: Text(itemPrice),
                    );
                  }),

                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.add_comment),
                      label: Text("Add Review"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FeedbackForm(vendorId: vendorId),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ReviewList extends StatefulWidget {
  final String vendorId;
  ReviewList({required this.vendorId});

  @override
  _ReviewListState createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  int? filter;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<int?>(
          hint: Text("🔍 Filter by Star Rating"),
          value: filter,
          onChanged: (val) => setState(() => filter = val),
          items: [
            DropdownMenuItem(child: Text("All"), value: null),
            ...List.generate(5, (i) => DropdownMenuItem(
              child: Text("${i + 1} Stars"),
              value: i + 1,
            )),
          ],
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('vendors')
              .doc(widget.vendorId)
              .collection('reviews')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();

            var reviews = snapshot.data!.docs;
            if (filter != null) {
              reviews = reviews.where((r) => r['rating'] == filter).toList();
            }

            if (reviews.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text("No reviews found for this filter."),
              );
            }

            return Column(
              children: reviews.map((r) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  elevation: 3,
                  child: ListTile(
                    title: Text("${r['title']} (${r['rating']}⭐)"),
                    subtitle: Text(r['description']),
                    trailing: Text("by ${r['username']}"),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
