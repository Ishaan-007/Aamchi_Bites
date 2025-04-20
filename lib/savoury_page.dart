import 'package:flutter/material.dart';

class SavouryPage extends StatelessWidget {
  final List<Map<String, String>> savouryItems = [
    {
      'name': 'Onion Pakoda',
      'place': 'Kirti Snacks Dadar',
      'image': 'https://www.kamalascorner.com/wp-content/uploads/2015/03/pakoda.jpg'
    },
    {
      'name': 'Samosa',
      'place': 'Shiv Vada Pav Chembur',
      'image': 'http://www.pureindianfoods.com/cdn/shop/articles/indian-samosas-recipe.webp?v=1728682315'
    },
    {
      'name': 'Suka Bhel',
      'place': 'Elco Chat Bandra',
      'image': 'https://b.zmtcdn.com/data/dish_photos/9db/3c3a224522d1efacf8f9c7d31e88c9db.jpg'
    },
    {
      'name': 'Veg Puff',
      'place': 'Irani Canteen Borivali',
      'image': 'https://www.yummytummyaarthi.com/wp-content/uploads/2021/12/1-1.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Savoury Foods")),
      body: ListView.builder(
        itemCount: savouryItems.length,
        itemBuilder: (context, index) {
          final item = savouryItems[index];
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