import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackForm extends StatefulWidget {
  final String vendorId;
  FeedbackForm({required this.vendorId});

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String title = '';
  String description = '';
  int rating = 1;
  bool recommend = false;
  int cleanliness = 5;
  String ingredientQuality = 'Fresh';
  String waterSafety = 'Safe';
  double hygieneScore = 5.0;

  final List<String> ingredientOptions = ['Fresh', 'Stale', 'Frozen'];
  final List<String> waterSafetyOptions = ['Safe', 'Unsafe'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Submit a Review")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Your Name"),
                validator: (v) => v!.isEmpty ? "Required" : null,
                onSaved: (v) => username = v!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Review Title"),
                validator: (v) => v!.isEmpty ? "Required" : null,
                onSaved: (v) => title = v!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Review Description"),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? "Required" : null,
                onSaved: (v) => description = v!,
              ),
              DropdownButtonFormField<int>(
                value: rating,
                items: List.generate(5, (i) => DropdownMenuItem(child: Text("${i + 1} Stars"), value: i + 1)),
                onChanged: (val) => setState(() => rating = val!),
                decoration: InputDecoration(labelText: "Star Rating"),
              ),
              SwitchListTile(
                title: Text("Would you recommend this vendor?"),
                value: recommend,
                onChanged: (v) => setState(() => recommend = v),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Cleanliness (0-10)"),
                keyboardType: TextInputType.number,
                initialValue: cleanliness.toString(),
                validator: (v) {
                  final val = int.tryParse(v!);
                  if (val == null || val < 0 || val > 10) return "Enter a value between 0 and 10";
                  return null;
                },
                onSaved: (v) => cleanliness = int.parse(v!),
              ),
              DropdownButtonFormField<String>(
                value: ingredientQuality,
                items: ingredientOptions
                    .map((e) => DropdownMenuItem(child: Text(e), value: e))
                    .toList(),
                onChanged: (v) => setState(() => ingredientQuality = v!),
                decoration: InputDecoration(labelText: "Ingredient Quality"),
              ),
              DropdownButtonFormField<String>(
                value: waterSafety,
                items: waterSafetyOptions
                    .map((e) => DropdownMenuItem(child: Text(e), value: e))
                    .toList(),
                onChanged: (v) => setState(() => waterSafety = v!),
                decoration: InputDecoration(labelText: "Water Safety"),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Hygiene Score (0-10)"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                initialValue: hygieneScore.toString(),
                validator: (v) {
                  final val = double.tryParse(v!);
                  if (val == null || val < 0 || val > 10) return "Enter a score between 0 and 10";
                  return null;
                },
                onSaved: (v) => hygieneScore = double.parse(v!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text("Submit Review"),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    await FirebaseFirestore.instance
                        .collection('vendors')
                        .doc(widget.vendorId)
                        .collection('reviews')
                        .add({
                      'username': username,
                      'title': title,
                      'description': description,
                      'rating': rating,
                      'recommend': recommend,
                      'timestamp': Timestamp.now(),
                      'cleanliness': cleanliness,
                      'ingredient_quality': ingredientQuality,
                      'water_safety': waterSafety,
                      'hygiene_score': hygieneScore,
                    });

                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
