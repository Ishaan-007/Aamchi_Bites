import 'package:flutter/material.dart';

class FoodCategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  const FoodCategoryCard({super.key, required this.title, required this.icon,});

  @override
  Widget build(BuildContext context) {
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
            title,
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
}

class VendorCard extends StatelessWidget {
  const VendorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            'https://i.pravatar.cc/150?img=${(10 + DateTime.now().second) % 70}',
          ),
          radius: 50,
        ),
        title: const Text("5-Star Vada Pav Stall"),
        subtitle: const Text("Near CST Station - Clean, Tasty, Legendary"),
        trailing: const Icon(Icons.star, color: Colors.amber),
      ),
    );
  }
}
