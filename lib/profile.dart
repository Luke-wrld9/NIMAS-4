import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Import Hive Flutter
import 'profile_model.dart'; // Import your profile model

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  Profile? _profile; // Use nullable Profile

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    var box = await Hive.openBox<Profile>('profileBox');
    setState(() {
      _profile = box.get('profile', defaultValue: Profile(
        name: '',
        age: '',
        height: '',
        weight: '',
        dailyNutrientGoals: {},
        nutrientDeficiencies: '',
        dietaryRestrictions: [],
      ));
    });
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var box = await Hive.openBox<Profile>('profileBox');
      await box.put('profile', _profile!);
      _toggleEdit();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_profile == null) {
      // Show a loading indicator while profile is being loaded
      return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          backgroundColor: Colors.blue.shade700,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isEditing)
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField('Name', _profile!.name, (value) => _profile!.name = value ?? ''),
                    _buildTextField('Age', _profile!.age, (value) => _profile!.age = value ?? '', keyboardType: TextInputType.number),
                    _buildTextField('Height (cm)', _profile!.height, (value) => _profile!.height = value ?? '', keyboardType: TextInputType.number),
                    _buildTextField('Weight (kg)', _profile!.weight, (value) => _profile!.weight = value ?? '', keyboardType: TextInputType.number),

                    SizedBox(height: 20),
                    _buildNutrientGoalsSection(),
                    SizedBox(height: 20),
                    _buildNutrientDeficienciesSection(),
                    SizedBox(height: 20),
                    _buildDietaryRestrictionsSection(),
                    SizedBox(height: 20),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: _saveProfile,
                          child: Text('Save'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _toggleEdit,
                          child: Text('Cancel'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            else ...[
              _buildProfileCard('Name', _profile!.name, Icons.person),
              _buildProfileCard('Age', _profile!.age, Icons.cake),
              _buildProfileCard('Height (cm)', _profile!.height, Icons.height),
              _buildProfileCard('Weight (kg)', _profile!.weight, Icons.monitor_weight),
              _buildProfileCard('Daily Nutrient Goals', _formatNutrientGoals(_profile!.dailyNutrientGoals), Icons.trending_up),
              _buildProfileCard('Nutrient Deficiencies', _profile!.nutrientDeficiencies, Icons.warning),
              _buildProfileCard('Dietary Restrictions', _profile!.dietaryRestrictions.join(', '), Icons.restaurant_menu),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _toggleEdit,
                  icon: Icon(Icons.edit),
                  label: Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue, FormFieldSetter<String?> onSaved, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onSaved: onSaved,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildNutrientGoalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Daily Nutrient Goals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ..._profile!.dailyNutrientGoals.entries.map((entry) {
          return _buildTextField(entry.key, entry.value, (value) {
            if (value != null) {
              setState(() {
                _profile!.dailyNutrientGoals[entry.key] = value;
              });
            }
          });
        }).toList(),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _profile!.dailyNutrientGoals[''] = ''; // Add empty goal entry for new nutrient
            });
          },
          child: Text('Add Nutrient Goal'),
        ),
      ],
    );
  }

  Widget _buildNutrientDeficienciesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nutrient Deficiencies', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        _buildTextField('Deficiencies', _profile!.nutrientDeficiencies, (value) => _profile!.nutrientDeficiencies = value ?? ''),
      ],
    );
  }

  Widget _buildDietaryRestrictionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dietary Restrictions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        CheckboxListTile(
          title: Text('Low-Sodium'),
          value: _profile!.dietaryRestrictions.contains('Low-Sodium'),
          onChanged: (value) {
            setState(() {
              if (value == true) {
                _profile!.dietaryRestrictions.add('Low-Sodium');
              } else {
                _profile!.dietaryRestrictions.remove('Low-Sodium');
              }
            });
          },
        ),
        CheckboxListTile(
          title: Text('Low-Carb'),
          value: _profile!.dietaryRestrictions.contains('Low-Carb'),
          onChanged: (value) {
            setState(() {
              if (value == true) {
                _profile!.dietaryRestrictions.add('Low-Carb');
              } else {
                _profile!.dietaryRestrictions.remove('Low-Carb');
              }
            });
          },
        ),
        CheckboxListTile(
          title: Text('Gluten-Free'),
          value: _profile!.dietaryRestrictions.contains('Gluten-Free'),
          onChanged: (value) {
            setState(() {
              if (value == true) {
                _profile!.dietaryRestrictions.add('Gluten-Free');
              } else {
                _profile!.dietaryRestrictions.remove('Gluten-Free');
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildProfileCard(String label, String value, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue.shade700),
        title: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value.isEmpty ? 'Not Set' : value,
          style: TextStyle(
            fontWeight: FontWeight.bold,       // Emphasize user input
            fontSize: 16.0,                    // Larger font size
            color: Colors.blue.shade800,       // Blue color for emphasis
          ),
        ),
      ),
    );
  }

  String _formatNutrientGoals(Map<String, String> nutrientGoals) {
    return nutrientGoals.entries.map((entry) => '${entry.key}: ${entry.value}').join(', ');
  }
}
