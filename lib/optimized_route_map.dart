import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

//void main() => runApp(MaterialApp(home: OSMOptimizedRouteMap()));

class OSMOptimizedRouteMap extends StatefulWidget {
  @override
  _OSMOptimizedRouteMapState createState() => _OSMOptimizedRouteMapState();
}

class _OSMOptimizedRouteMapState extends State<OSMOptimizedRouteMap> {
  List<LatLng> vendorLocations = [
    LatLng(19.1006, 72.8489),
    LatLng(18.9682, 72.8180),
    LatLng(18.9402, 72.8356),
    LatLng(19.0550, 72.8295),
    LatLng(18.9218, 72.8330),
    LatLng(18.9696, 72.8086),
    LatLng(18.9510, 72.8310),
    LatLng(18.9606, 72.8282),
    LatLng(19.0259, 72.8545),
    LatLng(19.0555, 72.8304),
  ];
  List<String> vendorNames = ["Anand Stall, Vile Parle","Sardar Pav Bhaji, Tardeo","Cannon Pav Bhaji, Fort","Elco, Bandra","Bademiya, Colaba","Muchhad Paanwala","Gulshan-e-Iran, Crawford","Noor Mohammadi, Bhendi Bazaar","Ram Ashraya, Matunga","Nandu's Dosa Stall, Bandra"];
  List<Polyline> routePolylines = [];

  @override
  void initState() {
    super.initState();
    _getOSMRouting();
  }

  Future<void> _getOSMRouting() async {
    final coords = vendorLocations
        .map((loc) => '${loc.longitude},${loc.latitude}')
        .join(';');

    final url = Uri.parse(
        'http://router.project-osrm.org/route/v1/driving/$coords?overview=full&geometries=geojson');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final coordinates =
          data['routes'][0]['geometry']['coordinates'] as List<dynamic>;

      List<LatLng> points = coordinates
          .map((coord) => LatLng(coord[1], coord[0]))
          .toList();

      setState(() {
        routePolylines = [
          Polyline(
            points: points,
            strokeWidth: 4.0,
            color: Colors.blue,
          ),
        ];
      });
    } else {
      print('Failed to load route from OSRM');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Free Map Food Trail")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: vendorLocations[0],
          initialZoom: 12,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          PolylineLayer(polylines: routePolylines),
          MarkerLayer(
  markers: vendorLocations
      .asMap()
      .entries
      .map((entry) => Marker(
            width: 80.0,
            height: 60.0,
            point: entry.value,
            child: Column(
              children: [
                Icon(Icons.location_pin, color: Colors.red, size: 30),
                Text(
                  vendorNames[entry.key],
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              ],
            ),
          ))
      .toList(),
),

        ],
      ),
    );
  }
}