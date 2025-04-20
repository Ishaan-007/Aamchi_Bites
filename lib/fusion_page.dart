import 'package:flutter/material.dart';

class FusionPage extends StatelessWidget {
  final List<Map<String, String>> fusionItems = [
    {
      'name': 'Kulhad Pizza',
      'place': 'Cheese and Fire Kurla',
      'image': 'https://b.zmtcdn.com/data/pictures/1/21020891/526de01af5be3f8d237f18c64abac6d7_o2_featured_v2.jpg'
    },
    {
      'name': 'Chinese Bhel',
      'place': 'Preeti Chinese Corner Mulund',
      'image': 'https://img-global.cpcdn.com/recipes/3b9c6d673a81d0e8/1200x630cq70/photo.jpg'
    },
    {
      'name': 'Paneer Pasta',
      'place': 'Street Curry Thane',
      'image': 'https://i.ytimg.com/vi/EUe4d6nqZb0/hq720.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fusion Foods")),
      body: ListView.builder(
        itemCount: fusionItems.length,
        itemBuilder: (context, index) {
          final item = fusionItems[index];
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