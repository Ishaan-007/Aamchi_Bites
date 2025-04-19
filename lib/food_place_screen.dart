import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FoodPlace {
  final String name;
  final double rating;

  FoodPlace({required this.name, required this.rating});

  factory FoodPlace.fromJson(Map<String, dynamic> json) {
  return FoodPlace(
    name: json['vendor_name'] ?? 'Unknown',
    rating: (json['suitability_score'] ?? 0).toDouble(),
  );
}
}

class FoodPlaceScreen extends StatefulWidget {
  @override
  _FoodPlaceScreenState createState() => _FoodPlaceScreenState();
}

class _FoodPlaceScreenState extends State<FoodPlaceScreen> {
  late Future<List<FoodPlace>> topFoodPlaces;

  Future<List<FoodPlace>> fetchTopFoodPlaces() async {
    http.Response response = await http.get(
      Uri.parse('http://10.0.2.2:5000')
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      print(response.body);

      return jsonResponse.map((place) => FoodPlace.fromJson(place)).toList();
    } else {
      throw Exception('Failed to load food places');
    }
  }

  @override
  void initState() {
    super.initState();
    topFoodPlaces = fetchTopFoodPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top Food Places')),
      body: FutureBuilder<List<FoodPlace>>(
        future: topFoodPlaces,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No top food places found'));
          } else {
            final foodPlaces = snapshot.data!;
            return ListView.builder(
              itemCount: foodPlaces.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                    backgroundColor: Colors.orangeAccent,
                  ),
                  title: Text(foodPlaces[index].name),
                  subtitle: Text('Rating: ${foodPlaces[index].rating}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: FoodPlaceScreen()));
}