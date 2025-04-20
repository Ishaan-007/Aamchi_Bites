import 'package:flutter/material.dart';

class SpicyPage extends StatelessWidget {
  final List<Map<String, String>> spicyItems = [
    {
      'name': 'Veg Frankie',
      'place': 'The Frankie House Vile Parle',
      'image': 'https://ontheflame.com/wp-content/uploads/2022/11/DSC_0207-2-768x1024.jpg'
    },
    {
      'name': 'Club Sandwich',
      'place': 'Bombay Sandwich Thane',
      'image': 'https://static.toiimg.com/thumb/83740315.cms?width=1200&height=900'
    },
    {
      'name': 'Masala Dosa',
      'place': 'Street Curry Borivali',
      'image': 'https://dmlxzvnzyohme.cloudfront.net/2013/08/nk-wgbh-masala-dosa640x360.jpg'
    },
    {
      'name': 'Aloo Tikki Chaat',
      'place': 'Chaat Junction Vile Parle',
      'image': 'https://images.squarespace-cdn.com/content/v1/52bc612ae4b038e4d94a53e6/1686458484363-KEPXW7MXKY4SNEM6BYY8/aloo+tikki+chaat.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2A43D),
      appBar: AppBar(title: Text("Spicy Foods")),
      body: ListView.builder(
        itemCount: spicyItems.length,
        itemBuilder: (context, index) {
          final item = spicyItems[index];
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