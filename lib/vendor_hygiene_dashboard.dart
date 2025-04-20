import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vendor Hygiene Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: VendorHygieneDashboard(),
    );
  }
}

class VendorHygieneDashboard extends StatefulWidget {
  @override
  _VendorHygieneDashboardState createState() => _VendorHygieneDashboardState();
}

class _VendorHygieneDashboardState extends State<VendorHygieneDashboard> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _countController = TextEditingController();
  String _searchQuery = '';
  int _itemCount = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
    _countController.addListener(_updateCount);
  }

  void _updateCount() {
    setState(() {
      _itemCount = int.tryParse(_countController.text) ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendor Hygiene Dashboard'),
        elevation: 4,
      ),
      body: Column(
        children: [
          _buildControls(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('vendors').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return _buildErrorWidget(snapshot.error);
                if (!snapshot.hasData) return _buildLoadingWidget();

                List<QueryDocumentSnapshot> vendors = snapshot.data!.docs;
                List<QueryDocumentSnapshot> filteredVendors = _processVendors(vendors);

                return Column(
                  children: [
                    _buildHeatmap(filteredVendors),
                    Expanded(child: _buildVendorList(filteredVendors)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search by Name/Location',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _countController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Number of results to show',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  List<QueryDocumentSnapshot> _processVendors(List<QueryDocumentSnapshot> vendors) {
    return vendors
        .where((v) {
          String name = (v['name'] ?? '').toString().toLowerCase();
          String location = (v['location'] ?? '').toString().toLowerCase();
          return name.contains(_searchQuery) || location.contains(_searchQuery);
        })
        .toList()
      ..sort((a, b) {
        double aScore = (a['avg_hygiene_score'] ?? 0).toDouble();
        double bScore = (b['avg_hygiene_score'] ?? 0).toDouble();
        return bScore.compareTo(aScore);
      })
      ..take(_itemCount > 0 ? _itemCount : vendors.length);
  }

  Widget _buildHeatmap(List<QueryDocumentSnapshot> vendors) {
    if (vendors.isEmpty) return SizedBox.shrink();

    double maxScore = vendors
        .map((v) => (v['avg_hygiene_score'] ?? 0).toDouble())
        .reduce((a, b) => a > b ? a : b);

    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: vendors.length,
        itemBuilder: (context, index) {
          var vendor = vendors[index];
          double score = (vendor['avg_hygiene_score'] ?? 0).toDouble();
          double normalizedScore = maxScore > 0 ? score / maxScore : 0;

          return Container(
            width: 60,
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Color.lerp(Colors.red, Colors.green, normalizedScore),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  score.toStringAsFixed(1),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVendorList(List<QueryDocumentSnapshot> vendors) {
    return ListView.builder(
      itemCount: vendors.length,
      itemBuilder: (context, index) {
        var vendor = vendors[index];
        double score = (vendor['avg_hygiene_score'] ?? 0).toDouble();

        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            title: Text(vendor['name'] ?? 'Unknown'),
            subtitle: Text(vendor['location'] ?? 'Unknown location'),
            trailing: Chip(
              label: Text(
                score.toStringAsFixed(1),
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: _getScoreColor(score),
            ),
          ),
        );
      },
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 4) return Colors.green;
    if (score >= 2) return Colors.orange;
    return Colors.red;
  }

  Widget _buildLoadingWidget() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorWidget(dynamic error) {
    return Center(child: Text('Error: $error'));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _countController.dispose();
    super.dispose();
  }
}