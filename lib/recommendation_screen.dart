import 'dart:convert';
import 'package:http/http.dart' as http;

/// Model representing a vendor recommendation
class VendorRecommendation {
  final String vendorName;
  final double suitabilityScore;

  VendorRecommendation({
    required this.vendorName,
    required this.suitabilityScore,
  });

  factory VendorRecommendation.fromJson(Map<String, dynamic> json) {
    return VendorRecommendation(
      vendorName: json['vendor_name'],
      suitabilityScore: (json['suitability_score'] as num).toDouble(),
    );
  }
}

/// Service that communicates with your ML backend
class MLService {
  final String baseUrl;

  /// Change this to your deployed server URL (e.g., ngrok or Render)
  MLService({this.baseUrl = "http://127.0.0.1:8000"});

  /// Sends user profile to backend and retrieves recommendations
  Future<List<VendorRecommendation>> getRecommendations(Map<String, dynamic> userProfile) async {
    final response = await http.post(
      Uri.parse('$baseUrl/recommend/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userProfile),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => VendorRecommendation.fromJson(item)).toList();
    } else {
      print("Error: ${response.statusCode}, ${response.body}");
      throw Exception('Failed to get recommendations');
    }
  }
}

/// Example usage function (can be called from a button or screen)
Future<void> exampleUsage() async {
  final mlService = MLService();

  final userProfile = {
    'vegan': 0,
    'gluten_free': 1,
    'lactose_free': 1,
    'spicy': 0,
    'health_sensitivity': 0.8,
    'prefers_high_hygiene': 1,
    'prefers_high_ingredient_quality': 1,
    'max_calories': 500,
    'food_type_preference': 'chaat'
  };

  try {
    final recommendations = await mlService.getRecommendations(userProfile);
    for (var vendor in recommendations) {
      print('${vendor.vendorName} → Score: ${vendor.suitabilityScore.toStringAsFixed(2)}');
    }
  } catch (e) {
    print("Error fetching recommendations: $e");
  }
}