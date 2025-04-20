import 'package:flutter/material.dart';
import 'package:street_food_app/optimized_route_map.dart';

import 'package:flutter/material.dart';

class FoodCategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget route;
  
  const FoodCategoryCard({
    super.key, 
    required this.title, 
    required this.icon, 
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => route));
      },
      child: Container(
        width: 120, // Increased width to better accommodate text
        height: 140, // Fixed height to ensure consistent sizing
        padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.teal.shade50],
          ),
          border: Border.all(
            color: Colors.teal.withOpacity(0.12),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.teal[700],
                size: 34, // Slightly adjusted icon size
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2, // Allow up to two lines for longer titles
                  style: TextStyle(
                    fontSize: 17, // Slightly reduced font size for better fit
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VendorCard extends StatelessWidget {
  final String imagePath; // Asset or network image path
  final String vendorName;
  final String vendorSubtitle;
  final double rating;

  const VendorCard({
    super.key,
    required this.imagePath,
    this.vendorName = "5-Star Vada Pav Stall",
    this.vendorSubtitle = "Near CST Station - Clean, Tasty, Legendary",
    this.rating = 5.0,
  });

  bool _isNetworkImage(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Beautiful image banner
          SizedBox(
            height: 180,
            width: double.infinity,
            child: _isNetworkImage(imagePath)
                ? Image.network(imagePath, fit: BoxFit.cover)
                : Image.asset(imagePath, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(Icons.storefront_rounded, size: 30, color: Colors.amber[800]),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vendorName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        vendorSubtitle,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber[700]),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
