import 'package:flutter/material.dart';
import 'package:street_food_app/community_feedback_integration.dart';
import 'package:street_food_app/food_category_card.dart';// Assuming this exists

class HomePage extends StatelessWidget {
  final String email;
  const HomePage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF2A43D),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // White Top Box
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left column - texts + buttons + icons
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo
                        Image.asset(
                          'assets/images/title.png',
                          height: 80,
                        ),
                        const SizedBox(height: 20),

                        // Greeting texts
                        const Text(
                          "Hey Ishaan भिडू!",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Ready to taste Mumbai?",
                          style: TextStyle(fontSize: 18, color: Colors.black87),
                        ),
                        const SizedBox(height: 20),

                        // Start Journey Button
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF2A43D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Text(
                              "Start your flavour journey!",
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Icons row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Icon(Icons.local_fire_department, size: 30),
                            Icon(Icons.icecream, size: 30),
                            Icon(Icons.spa, size: 30),
                            Icon(Icons.ramen_dining, size: 30),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Right column - Profile button + Mumbai Image
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.account_circle_rounded, size: 30),
                          onPressed: () {},
                        ),
                        const SizedBox(height: 10),
                        Image.asset(
                          'assets/images/mumbai.png',
                          height: 250,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Horizontal Food Category Cards
            SizedBox(
              height: 130,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
               children: const [
  FoodCategoryCard(title: "Must try first", icon: Icons.star),
  SizedBox(width: 12),
  FoodCategoryCard(title: "Specially for you", icon: Icons.lightbulb),
  SizedBox(width: 12),
  FoodCategoryCard(title: "Safe & Clean", icon: Icons.handshake),
],

              ),
            ),

            const SizedBox(height: 30),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "We think you'll love this...",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Vendor Cards
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (context, index) => const VendorCard(),
            ),

            const SizedBox(height: 80), // Leave space for bottom nav bar
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  // TODO: Add new vendor navigation
                },
              ),
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  // Already on home
                },
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => CommunityFeedbackIntegration()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
