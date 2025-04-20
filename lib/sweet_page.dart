import 'package:flutter/material.dart';

class SweetPage extends StatelessWidget {
  final List<Map<String, String>> sweetItems = [
    {
      'name': 'Jalebi',
      'place': 'Prashant Corner Thane',
      'image': 'https://aartiatmaram.com/wp-content/uploads/2021/09/Jalebi-Crispy-scaled.jpg'
    },
    {
      'name': 'Gulab Jamun',
      'place': 'Mumbai Bites Thane',
      'image': 'http://prashantcorner.com/cdn/shop/files/DakGulabJamunSR-2.jpg?v=1718083866'
    },
    {
      'name': 'Falooda',
      'place': 'Baba Falooda Andheri',
      'image': 'https://www.mygingergarlickitchen.com/wp-content/rich-markup-images/4x3/4x3-falooda-recipe.jpg'
    },
    {
      'name': 'Chocolate Pastry',
      'place': 'Bonnies Bakery Mulund',
      'image': 'https://patelbakery.in/wp-content/uploads/2021/06/chocolate-pastry-2-new.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2A43D),
      appBar: AppBar(title: Text("Sweet Cravings")),
      body: ListView.builder(
        itemCount: sweetItems.length,
        itemBuilder: (context, index) {
          final item = sweetItems[index];
          return Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    item['image']!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    '${item['name']} - ${item['place']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}