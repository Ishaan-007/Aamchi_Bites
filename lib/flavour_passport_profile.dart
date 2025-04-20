import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FlavorPassportProfile extends StatefulWidget {
  final String email;

  const FlavorPassportProfile({Key? key, required this.email}) : super(key: key);

  @override
  State<FlavorPassportProfile> createState() => _FlavorPassportProfileState();
}

class _FlavorPassportProfileState extends State<FlavorPassportProfile> {
  late Future<Map<String, dynamic>?> userDataFuture;

  @override
  void initState() {
    super.initState();
    userDataFuture = fetchUserData(widget.email);
  }

  Future<Map<String, dynamic>?> fetchUserData(String email) async {
    final query = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: email)
        .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first.data();
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('User not found.'));
          }

          final user = snapshot.data!;
          print(user);
          final name = user['name'];
          final location = user['location'] ?? 'Thane';
          final personality = user['personality'] ?? 'Spice Master';
          final imageUrl = user['imageUrl'] ?? 'https://media.licdn.com/dms/image/v2/D5603AQGDGJ13N1UhkA/profile-displayphoto-shrink_800_800/B56ZVNE5i4GoAg-/0/1740754885805?e=1750896000&v=beta&t=LsenV8tZj__X4XBr_tlx5jRDcXtF7nFDpGAxPOEZhsw';
          final isSpicy = user['spicy'] == 1;
          final foodPreference = user['food_type_preference'] ?? 'Not specified';

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFEF8D32),
                  Color(0xFFFFCA7A),
                  Color(0xFFFFECB3),
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Profile Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFA726).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(imageUrl),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      "Hey, $name! Here's your Flavor Passport",
                                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.menu, color: Colors.black87),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.black87, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Exploring from: $location',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildPersonalityButton(personality, personality),
                              _buildPersonalityButton('Clean Bite Seeker', personality),
                              _buildPersonalityButton('Foodie Scout', personality),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Preference Cards
                    GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.2,
                      children: [
                        _buildPreferenceCard(
                          icon: Icons.local_fire_department,
                          iconColor: isSpicy ? Colors.red : Colors.grey,
                          title: 'Spicy Food',
                          content: isSpicy
                              ? const Text("Loves the heat 🌶")
                              : const Text("Prefers mild flavors"),
                        ),
                        _buildPreferenceCard(
                          icon: Icons.restaurant_menu,
                          iconColor: Colors.deepPurple,
                          title: 'Food Type Preference',
                          content: Text(foodPreference),
                        ),
                        _buildPreferenceCard(
                          icon: Icons.eco,
                          iconColor: Colors.green,
                          title: 'Vegan',
                          content: Text(user['vegan'] == 1 ? 'Yes' : 'No'),
                        ),
                        _buildPreferenceCard(
                          icon: Icons.no_food,
                          iconColor: Colors.blueGrey,
                          title: 'Gluten Free',
                          content: Text(user['gluten_free'] == 1 ? 'Yes' : 'No'),
                        ),
                        _buildPreferenceCard(
                          icon: Icons.icecream,
                          iconColor: Colors.purple,
                          title: 'Lactose Free',
                          content: Text(user['lactose_free'] == 1 ? 'Yes' : 'No'),
                        ),
                        _buildPreferenceCard(
                          icon: Icons.health_and_safety,
                          iconColor: Colors.pink,
                          title: 'Health Sensitivity',
                          content: Text(
                            (user['health_sensitivity'] as num).toStringAsFixed(2),
                          ),
                        ),
                        _buildPreferenceCard(
                          icon: Icons.verified,
                          iconColor: Colors.teal,
                          title: 'High Hygiene',
                          content: Text(user['prefers_high_hygiene'] == 1 ? 'Yes' : 'No'),
                        ),
                        _buildPreferenceCard(
                          icon: Icons.emoji_food_beverage,
                          iconColor: Colors.amber,
                          title: 'Ingredient Quality',
                          content: Text(user['prefers_high_ingredient_quality'] == 1 ? 'Yes' : 'No'),
                        ),
                        _buildPreferenceCard(
                          icon: Icons.local_dining,
                          iconColor: Colors.brown,
                          title: 'Max Calories',
                          content: Text('${user['max_calories']} kcal'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPersonalityButton(String text, String selected) {
    final isSelected = text == selected;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.white54,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black26),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.deepOrange : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildPreferenceCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget content,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          content,
        ],
      ),
    );
  }
}