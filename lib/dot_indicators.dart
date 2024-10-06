import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'indicator_pages/recommendation.dart'; // Import RecommendationIndicatorPage
import 'indicator_pages/danger_ratings.dart'; // Import DangersRatingsPage

class DotIndicatorsPage extends StatelessWidget {
  final List<Map<String, String>> finalNutrients; // Add this

  DotIndicatorsPage({required this.finalNutrients}); // Add this

  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 229, 227, 233),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // page view
          SizedBox(
            height: 500,
            child: PageView(
              controller: _controller,
              children: [
                NutrientDisplayPage(finalNutrients: finalNutrients), // Pass finalNutrients here
                RecommendationsPage(),
                DangersRatingsPage(),
              ],
            ),
          ),
          // dot indicators
          SmoothPageIndicator(controller: _controller, count: 3),
        ],
      ),
    );
  }
}

class NutrientDisplayPage extends StatelessWidget {
  final List<Map<String, String>> finalNutrients;

  NutrientDisplayPage({required this.finalNutrients});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue[50],
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Final Nutritional Facts',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: finalNutrients.length,
              itemBuilder: (context, index) {
                final nutrient = finalNutrients[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(nutrient['Nutritional Fact'] ?? 'Unknown'),
                    subtitle: Text('Value: ${nutrient['Calories'] ?? 'N/A'}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}