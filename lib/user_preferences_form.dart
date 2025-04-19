import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_food_app/main_page.dart';

class UserPreferencesForm extends StatefulWidget {
  final String email;
  final String name;

  const UserPreferencesForm({
    required this.email,
    required this.name,
    super.key,
  });

  @override
  _UserPreferencesFormState createState() => _UserPreferencesFormState();
}

class _UserPreferencesFormState extends State<UserPreferencesForm> {
  int? vegan;
  int? glutenFree;
  int? lactoseFree;
  int? spicy;
  double healthSensitivity = 0.5;
  int? prefersHygiene;
  int? prefersIngredientQuality;
  int maxCalories = 500;
  String foodTypePreference = 'chaat';

  final foodOptions = ['chaat', 'frankie', 'salad', 'sandwich', 'samosa'];
  final _formKey = GlobalKey<FormState>();

  final Color goldenYellow = const Color(0xFFFFC107);
  final Color backgroundStart = const Color(0xFFFFF3E0);
  final Color backgroundEnd = const Color(0xFFFFE0B2);

  void submitPreferences() async {
    if (_formKey.currentState!.validate()) {
      if ([
        vegan,
        glutenFree,
        lactoseFree,
        spicy,
        prefersHygiene,
        prefersIngredientQuality
      ].contains(null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please answer all binary choices")),
        );
        return;
      }

      await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.email)
          .set({
        "email": widget.email,
        "name": widget.name,
        "vegan": vegan,
        "gluten_free": glutenFree,
        "lactose_free": lactoseFree,
        "spicy": spicy,
        "health_sensitivity": double.parse(healthSensitivity.toStringAsFixed(2)),
        "prefers_high_hygiene": prefersHygiene,
        "prefers_high_ingredient_quality": prefersIngredientQuality,
        "max_calories": maxCalories,
        "food_type_preference": foodTypePreference,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preferences saved successfully!")),
      );

      Navigator.push(context,
          MaterialPageRoute(builder: (_) => HomePage(email: widget.email)));
    }
  }

  Widget binaryChoice(String title, IconData icon, int? value, void Function(int?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: goldenYellow),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ]),
          Row(
            children: [
              Radio<int>(
                value: 1,
                groupValue: value,
                activeColor: goldenYellow,
                onChanged: onChanged,
              ),
              const Text("Yes"),
              Radio<int>(
                value: 0,
                groupValue: value,
                activeColor: goldenYellow,
                onChanged: onChanged,
              ),
              const Text("No"),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundStart, backgroundEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Customize Your Food Preferences",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        binaryChoice("Are you vegan?", Icons.eco, vegan, (val) => setState(() => vegan = val)),
                        binaryChoice("Want gluten-free food?", Icons.no_food, glutenFree, (val) => setState(() => glutenFree = val)),
                        binaryChoice("Need lactose-free options?", Icons.local_cafe, lactoseFree, (val) => setState(() => lactoseFree = val)),
                        binaryChoice("Do you prefer spicy food?", Icons.whatshot, spicy, (val) => setState(() => spicy = val)),
                        binaryChoice("Prefer high hygiene?", Icons.clean_hands, prefersHygiene, (val) => setState(() => prefersHygiene = val)),
                        binaryChoice("Prefer high ingredient quality?", Icons.emoji_food_beverage, prefersIngredientQuality, (val) => setState(() => prefersIngredientQuality = val)),
                        const SizedBox(height: 24),
                        Text("Health Sensitivity (${(healthSensitivity * 100).round()}%)",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Slider(
                          value: healthSensitivity,
                          onChanged: (val) => setState(() => healthSensitivity = val),
                          min: 0,
                          max: 1,
                          divisions: 20,
                          label: "${(healthSensitivity * 100).round()}%",
                          activeColor: goldenYellow,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: const InputDecoration(labelText: "Max Calories", prefixIcon: Icon(Icons.local_fire_department)),
                          initialValue: maxCalories.toString(),
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            final numVal = int.tryParse(val ?? '');
                            if (numVal == null || numVal <= 0) {
                              return "Enter a valid number";
                            }
                            return null;
                          },
                          onChanged: (val) => setState(() => maxCalories = int.tryParse(val) ?? 500),
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: foodTypePreference,
                          items: foodOptions
                              .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                              .toList(),
                          onChanged: (val) => setState(() => foodTypePreference = val!),
                          decoration: const InputDecoration(
                            labelText: "Preferred Food Type",
                            prefixIcon: Icon(Icons.fastfood),
                          ),
                          dropdownColor: Colors.white,
                          iconEnabledColor: goldenYellow,
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.save),
                          label: const Text("Save Preferences"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: goldenYellow,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          onPressed: submitPreferences,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
