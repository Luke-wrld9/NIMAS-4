// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'option_selection.dart'; // Import the new option selection page

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'NIMAS',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Center(
            child: Text(
              'Welcome to the NIMAS App!',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 18,
              ),
            ),
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OptionSelectionPage()), // Navigate to OptionSelectionPage
                );
              },
              child: Icon(Icons.add), // Changed icon to add
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
