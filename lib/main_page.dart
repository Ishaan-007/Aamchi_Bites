import 'package:flutter/material.dart';
import 'package:street_food_app/community_feedback_integration.dart';
import 'package:street_food_app/flavour_passport_profile.dart';
import 'package:street_food_app/food_category_card.dart';
import 'package:street_food_app/food_place_screen.dart';
import 'package:street_food_app/optimized_route_map.dart';
import 'package:street_food_app/vendor_hygiene_dashboard.dart';
import 'package:street_food_app/vendor_sign_up_page.dart';

class HomePage extends StatelessWidget {
  final String email;
  const HomePage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final List<Map<String, dynamic>> vendorData = [
  {
    'image': 'assets/images/food_1.jpg',
    'title': 'Chaat Junction, Thane',
    'subtitle': 'Thane – Spicy, Quick & Famous',
    'rating': 4.8,
  },
  {
    'image': 'assets/images/food_2.png',
    'title': 'Dosa Delights, Mulund',
    'subtitle': 'Mulund – South Indian Delight',
    'rating': 4.5,
  },
  {
    'image': 'assets/images/food_3.png',
    'title': 'Bombay Sandwich, Thane',
    'subtitle': 'Thane – Maharashtrian Punch',
    'rating': 4.3,
  },
  {
    'image': 'assets/images/food_4.png',
    'title': 'Spicy Tandoor, Andheri',
    'subtitle': 'Andheri – Creamy & Filling',
    'rating': 4.6,
  },
  {
    'image': 'assets/images/food_5.jpg',
    'title': 'The Frankie House, Thane',
    'subtitle': 'Thane – Simple & Soothing',
    'rating': 4.7,
  },
];

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
                          width: 1000,
                        ),
                        const SizedBox(height: 10),

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
                              style: TextStyle(fontFamily: "PlaywriteAUSA", fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
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
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => FlavorPassportProfile(email: email,)));
                          },
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
               children:  [
  FoodCategoryCard(title: "Must try first", icon: Icons.star, route: OSMOptimizedRouteMap(),),
  SizedBox(width: 12),
  FoodCategoryCard(title: "For you", icon: Icons.lightbulb, route: FoodPlaceScreen(),),
  SizedBox(width: 12),
  FoodCategoryCard(title: "Safe & Clean", icon: Icons.handshake, route: VendorHygieneDashboard(),),
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
                    fontFamily: "Fredoka",
                      fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Vendor Cards
            ListView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  itemCount: vendorData.length,
  itemBuilder: (context, index) {
    final vendor = vendorData[index];
    return VendorCard(
      imagePath: vendor['image'],
      vendorName: vendor['title'],
      vendorSubtitle: vendor['subtitle'],
      rating: vendor['rating'],
    );
  },
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
                  Navigator.push(context, MaterialPageRoute(builder: (_) => VendorSignUpPage()));
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
