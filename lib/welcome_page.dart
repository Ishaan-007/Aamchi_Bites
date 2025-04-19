import 'package:flutter/material.dart';
import 'sign_up_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Zoomed-out background image
          SizedBox.expand(
            child: Transform.scale(
              scale: 0.9, // Adjust this to control zoom-out level
              child: Image.asset(
                'assets/images/aamchi_bites.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Button image with limited gesture area
          Positioned(
            bottom: 50,
            left: screenSize.width * 0.5 - 175, // Center the button (half screen - half image width)
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Image.asset(
                'assets/images/chal_bhidu.png',
                width: 350, // Increased size for button
              ),
            ),
          ),
        ],
      ),
    );
  }
}
