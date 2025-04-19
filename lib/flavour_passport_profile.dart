import 'package:flutter/material.dart';

class FlavorPassportProfile extends StatefulWidget {
  const FlavorPassportProfile({Key? key}) : super(key: key);

  @override
  State<FlavorPassportProfile> createState() => _FlavorPassportProfileState();
}

class _FlavorPassportProfileState extends State<FlavorPassportProfile> {
  // Selected food personality type
  String selectedPersonality = 'Spice Master';

  // Function to handle personality selection
  void selectPersonality(String personality) {
    setState(() {
      selectedPersonality = personality;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEF8D32), // Top orange
              Color(0xFFFFCA7A), // Middle yellow-orange
              Color(0xFFFFECB3), // Bottom light yellow
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile header section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFA726).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          // Profile info and menu
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Profile picture and name
                              Expanded(
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white,
                                      child: ClipOval(
                                        child: Image(
                                          image: NetworkImage('https://a.storyblok.com/f/202591/702x473/a064611e1c/network-images-on-the-web-platform.png/m/3072x2098/filters:format(webp):quality(90)'),
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'Priya',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            'Hey, Priya! Here\'s your Flavor Passport',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Menu button
                              IconButton(
                                icon: const Icon(
                                  Icons.menu,
                                  size: 28,
                                  color: Colors.black87,
                                ),
                                onPressed: () {
                                  // Show menu functionality
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Menu pressed')),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Location info
                          Row(
                            children: const [
                              Icon(Icons.location_on, color: Colors.black87, size: 20),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Exploring from: Bandra, Mumbai',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Personality type selection
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildPersonalityButton('Spice Master'),
                              _buildPersonalityButton('Clean Bite Seeker'),
                              _buildPersonalityButton('Foodie Scout'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Food preferences grid
                    GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.2,
                      children: [
                        // Spice Tolerance Card
                        _buildPreferenceCard(
                          icon: Icons.whatshot,
                          iconColor: Colors.deepOrange,
                          title: 'Spice Tolerance',
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 12,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Colors.deepOrange, Colors.orange, Colors.amber],
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Firestarter',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        // Diet Type Card
                        _buildPreferenceCard(
                          icon: Icons.eco,
                          iconColor: Colors.green,
                          title: 'Diet Type',
                          content: const Center(
                            child: Text(
                              'Vegetarian',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        // Salty/Umami Card
                        _buildPreferenceCard(
                          icon: Icons.waves,
                          iconColor: Colors.orange,
                          title: 'Salty / Umami',
                          content: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Indian,\nIndo-Chinese',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // Favorite Cuisines Card
                        _buildPreferenceCard(
                          icon: Icons.restaurant,
                          iconColor: Colors.orange,
                          title: 'Favorite Cuisines',
                          content: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Indian, Indo-Chinese',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Insights & Preferences section
                    const Text(
                      'Insights & Preferences',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Insights row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Most Tried Dishes
                        _buildInsightItem(
                          icon: Icons.dinner_dining,
                          iconColor: Colors.brown,
                          title: 'Most Tried\nDishes',
                          value: 'Vada Pav, Misal Pav',
                        ),
                        // Areas Explored
                        _buildInsightItem(
                          icon: Icons.place,
                          iconColor: Colors.orange,
                          title: 'Areas\nExplored',
                          value: 'South Mumbai',
                        ),
                        // Preferred Time
                        _buildInsightItem(
                          icon: Icons.nightlight,
                          iconColor: Colors.blueGrey,
                          title: 'Preferred\nTime',
                          value: 'Night Snacker',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Update profile button
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Update Profile pressed')),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.edit, color: Colors.black87),
                            SizedBox(width: 10),
                            Text(
                              'Update My Flavor Profile',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for personality selection buttons
  Widget _buildPersonalityButton(String label) {
    final isSelected = selectedPersonality == label;
    
    return GestureDetector(
      onTap: () => selectPersonality(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber.shade800 : Colors.amber.shade200,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  // Helper widget for preference cards
  Widget _buildPreferenceCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget content,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE9C3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          content,
          const Spacer(),
        ],
      ),
    );
  }

  // Helper widget for insight items
  Widget _buildInsightItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: iconColor),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}