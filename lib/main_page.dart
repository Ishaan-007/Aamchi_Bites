import 'package:flutter/material.dart';
import 'package:street_food_app/community_feedback_integration.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Khana Khazana"),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            const Text(
              "Explore Mumbai's Street Food Safely 🍴",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Discover delicious eats with hygiene ratings, verified reviews, and cultural food trails.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Hygiene Rating Button
            FeatureCard(
              icon: Icons.star_rate,
              title: "Hygiene Ratings",
              description:
                  "View hygiene scores based on cleanliness, ingredient quality, and water safety.",
              onTap: () {
                // Navigate to Ratings Page
              },
            ),

            // Community Feedback
            FeatureCard(
              icon: Icons.feedback,
              title: "Community Reviews",
              description:
                  "Check trusted feedback from users and professionals for each vendor.",
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => CommunityFeedbackIntegration()),);
              },
            ),

            // Vendor Discovery
            FeatureCard(
              icon: Icons.map,
              title: "Discover Vendors",
              description:
                  "Find verified food stalls with location, hours, and photos.",
              onTap: () {
                // Navigate to Vendor Map
              },
            ),

            // Personalized Suggestions
            FeatureCard(
              icon: Icons.recommend,
              title: "Recommended for You",
              description:
                  "Get food suggestions based on your diet and preferences.",
              onTap: () {
                // Navigate to Recommendation Page
              },
            ),

            // Newcomer's Guide
            FeatureCard(
              icon: Icons.directions_walk,
              title: "Newcomer's Guide",
              description:
                  "Explore curated food trails and beginner-friendly picks around Mumbai.",
              onTap: () {
                // Navigate to Food Trails
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, size: 36, color: Colors.deepOrange),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        onTap: onTap,
      ),
    );
  }
}
