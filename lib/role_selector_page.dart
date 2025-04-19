import 'package:flutter/material.dart';
import 'package:street_food_app/sign_up_page.dart';
import 'package:street_food_app/vendor_sign_up_page.dart';

class RoleSelectorPage extends StatefulWidget {
  const RoleSelectorPage({Key? key}) : super(key: key);

  @override
  State<RoleSelectorPage> createState() => _RoleSelectorPageState();
}

class _RoleSelectorPageState extends State<RoleSelectorPage> {
  bool isUser = false;
  bool isVendor = false;

  void _continue() {
    if (isUser ^ isVendor) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => isUser ? SignUpPage() : VendorSignUpPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select exactly one role to continue.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Widget _buildRoleCard({
    required IconData icon,
    required String label,
    required String description,
    required bool selected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: selected 
                ? color.withOpacity(0.3) 
                : Colors.black.withOpacity(0.05),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: selected ? color : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon, 
                size: 28, 
                color: selected ? Colors.white : color,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: selected ? color : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Radio(
              value: true,
              groupValue: selected,
              onChanged: (_) => onTap(),
              activeColor: color,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topSectionHeight = screenHeight * 0.25; // 25% of screen for top section
    
    return Scaffold(
      backgroundColor: Color(0xFFF2A43D),
      body: SafeArea(
        child: Column(
          children: [
            // Top Design Section - Height constrained
            Container(
              height: topSectionHeight,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'पुढील स्थानक',
                      style: TextStyle(
                        fontFamily: "TiroDevanagariHindi",
                        fontSize: screenHeight * 0.06, // Responsive font size
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'MUMBAI',
                      style: TextStyle(
                        fontFamily: "Fredoka",
                        fontSize: screenHeight * 0.07, // Responsive font size
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF457c43),
                        letterSpacing: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Main Content - Remaining space
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    // Title Section
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      child: Text(
                        'Choose Your Role',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    
                    // Role Selection Cards - Flex space
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildRoleCard(
                            icon: Icons.person_outline,
                            label: 'Foodie',
                            description: 'Explore local street food vendors and discover culinary gems',
                            color: Color(0xFFF2A43D),
                            selected: isUser,
                            onTap: () => setState(() {
                              isUser = true;
                              isVendor = false;
                            }),
                          ),
                          
                          _buildRoleCard(
                            icon: Icons.storefront_outlined,
                            label: 'Street Food Vendor',
                            description: 'Showcase your food stall and connect with customers',
                            color: Color(0xFF457c43),
                            selected: isVendor,
                            onTap: () => setState(() {
                              isVendor = true;
                              isUser = false;
                            }),
                          ),
                          
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              'Your Street Food Journey Begins Here',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Bottom section with button and image - Flex space
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          // Continue Button
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _continue,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFF2A43D),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 2,
                                ),
                                child: Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Train Image - Expanded to fill remaining space
                          
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}