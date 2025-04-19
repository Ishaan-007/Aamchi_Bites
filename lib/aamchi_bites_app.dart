import 'package:flutter/material.dart';

class NewHomePage extends StatelessWidget {
  const NewHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar with Logo and Profile Icon
              _buildAppBar(),
              
              // Main Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildFlavorJourneyButton(),
                    const SizedBox(height: 30),
                    _buildCategorySection(),
                    const SizedBox(height: 30),
                    _buildRecommendationsSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Text(
                'आमची ',
                style: TextStyle(
                  color: Colors.orange[400],
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Bites',
                style: TextStyle(
                  color: Colors.teal[600],
                  fontSize: 28,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          
          // Profile icon
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20,
            child: Icon(
              Icons.person_outline,
              size: 30,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text part
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Hey Ishaan',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[400],
                      ),
                    ),
                    TextSpan(
                      text: 'मिडू',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Ready to taste',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                'Mumbai?',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        
        // Mumbai Map
        Expanded(
          flex: 2,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.teal[600],
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/mumbai_map.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFlavorJourneyButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      decoration: BoxDecoration(
        color: Colors.orange[300],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Start Your Flavour Journey',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              _buildFoodIcon(Icons.spa, Colors.green), // Green chili
              const SizedBox(width: 12),
              _buildFoodIcon(Icons.cake, Colors.pink), // Cupcake
              const SizedBox(width: 12),
              _buildFoodIcon(Icons.restaurant, Colors.amber), // Kebab
              const SizedBox(width: 12),
              _buildFoodIcon(Icons.ramen_dining, Colors.redAccent), // Bowl
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFoodIcon(IconData icon, Color color) {
    return Icon(
      icon,
      color: color,
      size: 24,
    );
  }

  Widget _buildCategorySection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCategoryItem(Icons.star, 'Must try\nfirst'),
        _buildCategoryItem(Icons.lightbulb, 'Safe\n& Clean'),
        _buildCategoryItem(Icons.handshake, 'Suggested\nfor You'),
      ],
    );
  }

  Widget _buildCategoryItem(IconData icon, String text) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.teal[600],
            size: 28,
          ),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'We Think You\'ll Love These...',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildFoodRecommendation(
          'Misal Pav',
          'Shankar Corners, Kandivali',
          'assets/misal_pav.jpg',
          5.0,
        ),
        const SizedBox(height: 16),
        _buildFoodRecommendation(
          'Pizza',
          'Tina & Hellen Snacks, Parel',
          'assets/pizza.jpg',
          4.0,
        ),
      ],
    );
  }

  Widget _buildFoodRecommendation(
      String name, String location, String image, double rating) {
    return Row(
      children: [
        // Food image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            image,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        // Food details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                location,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < rating.floor() ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.home, true),
            _buildNavItem(Icons.people_alt_outlined, false),
            _buildNavItem(Icons.add_circle_outline, false),
            _buildNavItem(Icons.language, false),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.orange[300] : Colors.transparent,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(12),
      child: Icon(
        icon,
        color: isSelected ? Colors.black : Colors.black54,
        size: 28,
      ),
    );
  }
}