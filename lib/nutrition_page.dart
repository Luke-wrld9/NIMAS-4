// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class NutritionPage extends StatefulWidget {
  @override
  _NutritionPageState createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  final List<Map<String, String>> _foodItems = [];
  final _searchController = TextEditingController();
  final _foodNameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _fatController = TextEditingController();
  final _carbsController = TextEditingController();

  void _addFoodItem() {
    if (_foodNameController.text.isEmpty) return;
    setState(() {
      _foodItems.add({
        'name': _foodNameController.text,
        'calories': _caloriesController.text,
        'protein': _proteinController.text,
        'fat': _fatController.text,
        'carbs': _carbsController.text,
      });
    });
    _foodNameController.clear();
    _caloriesController.clear();
    _proteinController.clear();
    _fatController.clear();
    _carbsController.clear();
    Navigator.of(context).pop();
  }

  void _showAddFoodDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add New Food Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(_foodNameController, 'Food Name'),
            _buildTextField(_caloriesController, 'Calories', keyboardType: TextInputType.number),
            _buildTextField(_proteinController, 'Protein (g)', keyboardType: TextInputType.number),
            _buildTextField(_fatController, 'Fat (g)', keyboardType: TextInputType.number),
            _buildTextField(_carbsController, 'Carbs (g)', keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: _addFoodItem,
            child: Text('Add'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700), // Adjusted blue shade
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrition'),
        backgroundColor: Colors.blue.shade700, // Adjusted blue shade
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for food',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showAddFoodDialog,
              child: Text('Add New Food Item'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700), // Adjusted blue shade
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _foodItems.length,
                itemBuilder: (ctx, index) {
                  final item = _foodItems[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(item['name']!),
                      subtitle: Text(
                        'Calories: ${item['calories']} kcal\n'
                        'Protein: ${item['protein']} g\n'
                        'Fat: ${item['fat']} g\n'
                        'Carbs: ${item['carbs']} g',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}