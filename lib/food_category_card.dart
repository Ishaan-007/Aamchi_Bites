import 'package:flutter/material.dart';
import 'package:street_food_app/optimized_route_map.dart';

class FoodCategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget route;
  const FoodCategoryCard({super.key, required this.title, required this.icon, required this.route});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => route));
      },
      child: Container(
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
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
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
