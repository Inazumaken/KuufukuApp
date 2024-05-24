import 'package:flutter/material.dart';
import 'dart:ui';

class RecipeDetailScreen extends StatelessWidget {
  final recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          recipe['name'],
          style: TextStyle(
            fontFamily: 'NotoSerifJP',
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    recipe['imageURL'],
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16.0),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  color: Colors.white.withOpacity(0.4),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      recipe['description'],
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[900],
                        fontFamily: 'NotoSerifJP',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Divider(
                  color: Colors.redAccent,
                  thickness: 1,
                ),
                Text(
                  'Ingredients:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                    fontFamily: 'NotoSerifJP',
                  ),
                ),
                SizedBox(height: 8.0),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  color: Colors.white.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (recipe['ingredients'] as List<dynamic>).map<Widget>((ingredient) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            ingredient,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                              fontFamily: 'NotoSerifJP',
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Divider(
                  color: Colors.redAccent,
                  thickness: 1,
                ),
                Text(
                  'Directions:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                    fontFamily: 'NotoSerifJP',
                  ),
                ),
                SizedBox(height: 8.0),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  color: Colors.white.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (recipe['direction'] as List<dynamic>).map<Widget>((direction) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            direction,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                              fontFamily: 'NotoSerifJP',
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
