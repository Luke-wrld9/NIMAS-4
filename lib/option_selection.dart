import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'manual_input.dart';

class OptionSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Option'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final ImagePicker _picker = ImagePicker();
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

                if (image != null) {
                  // Handle the picked image (e.g., navigate to another page or process the image)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManualInputPage()),
                  );
                }
              },
              child: Text('Pick Image from Gallery'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final ImagePicker _picker = ImagePicker();
                final XFile? image = await _picker.pickImage(source: ImageSource.camera);

                if (image != null) {
                  // Handle the taken photo (e.g., navigate to another page or process the image)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManualInputPage()),
                  );
                }
              },
              child: Text('Take Photo with Camera'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManualInputPage()), // Navigate to NutrientInputPage
                );
              },
              child: Text('Add Nutrients Manually'),
            ),
          ],
        ),
      ),
    );
  }
}