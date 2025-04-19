import 'package:flutter/material.dart';
import 'package:street_food_app/role_selector_page.dart';
import 'sign_up_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      //ackgroundColor: Colors.white,
      body: Stack(
        children: [
          // Zoomed-out background image
          SizedBox.expand(
            child: Transform.scale(
              scale: 1, // Adjust this to control zoom-out level
              child: Image.asset(
                'assets/images/aamchi_bites.png',
                //fit: BoxFit.cover,
              ),
            ),
          ),

          // Button image with limited gesture area
          Positioned(
            top: 130,
            bottom: 0,
            left: screenSize.width * 0.5 - 115, // Center the button (half screen - half image width)
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RoleSelectorPage()),
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
