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

  Color _getScoreColor(double score) {
    if (score >= 4.0) return Colors.green;
    if (score >= 2.0) return Colors.orange;
    return Colors.red;
  }

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
                  Row(
                    children: [
                      Icon(Icons.store, size: 28),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text("📍 $location\n📞 $contact\n🕘 $timings"),
                  SizedBox(height: 10),
                  
                  Text("🧼 Hygiene Score", style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: hygieneScore / 5,
                          backgroundColor: Colors.grey[300],
                          color: _getScoreColor(hygieneScore),
                          minHeight: 10,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text("${hygieneScore.toStringAsFixed(1)}/5", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),

                  Divider(height: 30),
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
                  }).toList(),

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
                  ),
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
  // Store the user ID to track votes (in a real app, you'd get this from auth)
  final String userId = 'current_user_id';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("📣 User Reviews", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<int?>(
              hint: Text("🔍 Filter"),
              value: filter,
              isDense: true,
              onChanged: (val) => setState(() => filter = val),
              items: [
                DropdownMenuItem(child: Text("All"), value: null),
                ...List.generate(5, (i) => DropdownMenuItem(
                  child: Text("${i + 1} Stars"),
                  value: i + 1,
                )),
              ],
            ),
          ],
        ),
        SizedBox(height: 8),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('vendors')
              .doc(widget.vendorId)
              .collection('reviews')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

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
              children: reviews.map((reviewDoc) {
                var review = reviewDoc.data() as Map<String, dynamic>;
                var reviewId = reviewDoc.id;
                
                // Extract voting data or set defaults
                var upvotes = review['upvotes'] ?? 0;
                var downvotes = review['downvotes'] ?? 0;
                var voteScore = upvotes - downvotes;
                
                // Check if user has already voted
                var userVotes = review['userVotes'] as Map<String, dynamic>? ?? {};
                int userVote = userVotes[userId] ?? 0; // 1 for upvote, -1 for downvote, 0 for no vote
                
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "${review['title'] ?? 'Review'} (${review['rating']}⭐)",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            Text(
                              "by ${review['username'] ?? 'Anonymous'}",
                              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(review['description'] ?? ''),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                _buildVoteButton(
                                  icon: Icons.thumb_up,
                                  color: userVote == 1 ? Colors.green : Colors.grey,
                                  onPressed: () => _handleVote(reviewId, 1, userVote),
                                ),
                                SizedBox(width: 4),
                                _buildVoteButton(
                                  icon: Icons.thumb_down,
                                  color: userVote == -1 ? Colors.red : Colors.grey,
                                  onPressed: () => _handleVote(reviewId, -1, userVote),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  "$voteScore",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: voteScore > 0 
                                      ? Colors.green 
                                      : voteScore < 0 ? Colors.red : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            if (review['timestamp'] != null)
                              Text(
                                _formatDate(review['timestamp'].toDate()),
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildVoteButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  void _handleVote(String reviewId, int vote, int currentUserVote) async {
    // Reference to the review document
    DocumentReference reviewRef = FirebaseFirestore.instance
        .collection('vendors')
        .doc(widget.vendorId)
        .collection('reviews')
        .doc(reviewId);

    // Get the current review data
    DocumentSnapshot reviewDoc = await reviewRef.get();
    var reviewData = reviewDoc.data() as Map<String, dynamic>;
    
    // Initialize vote counts if they don't exist
    var upvotes = reviewData['upvotes'] ?? 0;
    var downvotes = reviewData['downvotes'] ?? 0;
    var userVotes = reviewData['userVotes'] as Map<String, dynamic>? ?? {};

    // Handle different vote scenarios
    if (currentUserVote == vote) {
      // User is toggling their vote off
      if (vote == 1) upvotes--;
      if (vote == -1) downvotes--;
      userVotes[userId] = 0;
    } else {
      // Remove previous vote if exists
      if (currentUserVote == 1) upvotes--;
      if (currentUserVote == -1) downvotes--;
      
      // Add new vote
      if (vote == 1) upvotes++;
      if (vote == -1) downvotes++;
      
      userVotes[userId] = vote;
    }

    // Update the document
    await reviewRef.update({
      'upvotes': upvotes,
      'downvotes': downvotes,
      'userVotes': userVotes,
    });
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}