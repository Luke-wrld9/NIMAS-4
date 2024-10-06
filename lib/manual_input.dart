import 'package:flutter/material.dart';
import 'indicator_pages/nutrient_display.dart'; // Import the new page

class ManualInputPage extends StatefulWidget {
  @override
  _ManualInputPageState createState() => _ManualInputPageState();
}

class _ManualInputPageState extends State<ManualInputPage> {
  final _productController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _caloriesFromFatController = TextEditingController();
  final _quantityController = TextEditingController();
  final _servingSizeController = TextEditingController();
  final _servingsPerItemController = TextEditingController();
  String _quantityUnit = 'ml';
  String _caloriesFromFatUnit = 'g';

  final List<String> _commonNutrients = [
    'Calories', 'Total Fat', 'Saturated Fat', 'Trans Fat',
    'Cholesterol', 'Sodium', 'Total Carbohydrates', 'Dietary Fiber', 'Sugars', 'Protein',
    'Vitamin A', 'Vitamin C', 'Vitamin D', 'Calcium', 'Iron', 'Custom Nutrient'
  ];

  // List to store selected nutrients and their values
  List<Map<String, String>> _nutrients = [];

  // Method to add a nutrient
  void _addCustomNutrient(String nutrient) {
    setState(() {
      _nutrients.add({'Nutritional Fact': nutrient, 'Amount': '', 'Unit': 'g'});
    });
  }

  // Method to delete a nutrient from the list
  void _deleteNutrient(int index) {
    setState(() {
      _nutrients.removeAt(index);
    });
  }

  // Method to create the nutrient map and navigate to display page
  void _saveAndViewNutritionalInfo() {
  // Create a map from the nutrients list
  Map<String, Map<String, String>> nutrientMap = {};
  for (var nutrient in _nutrients) {
    nutrientMap[nutrient['Nutritional Fact'] ?? ''] = {
      'Amount': nutrient['Amount'] ?? '',
      'Unit': nutrient['Unit'] ?? ''
    };
  }

  // Create a map with all the details
  final productDetails = {
    'Product Name': _productController.text,
    'Calories': _caloriesController.text,
    'Calories from Fat': _caloriesFromFatController.text,
    'Quantity': '${_quantityController.text} ${_quantityUnit}',
    'Serving Size': _servingSizeController.text,
    'Servings Per Item': _servingsPerItemController.text,
  };

  // Navigate to NutrientDisplayPage and pass the details and nutrient map
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => NutrientDisplayPage(
        productDetails: productDetails,
        nutrients: nutrientMap,
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manual Nutrient Input'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _productController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _caloriesController,
                decoration: InputDecoration(labelText: 'Calories'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _caloriesFromFatController,
                      decoration: InputDecoration(labelText: 'Calories from Fat (Optional)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _caloriesFromFatUnit,
                    items: ['g', 'mg', 'oz'].map((unit) {
                      return DropdownMenuItem(
                        value: unit,
                        child: Text(unit),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _caloriesFromFatUnit = value!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _quantityController,
                      decoration: InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _quantityUnit,
                    items: ['ml', 'g', 'kg', 'cups', 'oz'].map((unit) {
                      return DropdownMenuItem(
                        value: unit,
                        child: Text(unit),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _quantityUnit = value!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextField(
                controller: _servingSizeController,
                decoration: InputDecoration(labelText: 'Serving Size'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _servingsPerItemController,
                decoration: InputDecoration(labelText: 'Servings Per Item'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                hint: Text('Select a nutrient to add'),
                items: _commonNutrients.map((nutrient) {
                  return DropdownMenuItem(
                    value: nutrient,
                    child: Text(nutrient),
                  );
                }).toList(),
                onChanged: (nutrient) {
                  if (nutrient != null) {
                    if (nutrient == 'Custom Nutrient') {
                      _showCustomNutrientDialog();
                    } else {
                      _addCustomNutrient(nutrient);
                    }
                  }
                },
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _nutrients.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            _nutrients[index]['Nutritional Fact'] ?? 'Nutritional Fact',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Amount',
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _nutrients[index]['Amount'] = value;
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        DropdownButton<String>(
                          value: _nutrients[index]['Unit'] ?? 'g',
                          items: ['g', 'mg', 'oz'].map((unit) {
                            return DropdownMenuItem(
                              value: unit,
                              child: Text(unit),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _nutrients[index]['Unit'] = value!;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteNutrient(index),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _saveAndViewNutritionalInfo,
                child: Text('Save and View Nutritional Info'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog for adding custom nutrients
  void _showCustomNutrientDialog() {
    final _customNutrientController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Custom Nutrient'),
          content: TextField(
            controller: _customNutrientController,
            decoration: InputDecoration(labelText: 'Custom Nutrient'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_customNutrientController.text.isNotEmpty) {
                  _addCustomNutrient(_customNutrientController.text);
                }
                Navigator.of(context).pop();
              },
              child: Text('Add Nutrient'),
            ),
          ],
        );
      },
    );
  }
}
