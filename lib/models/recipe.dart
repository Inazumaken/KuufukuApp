// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String id;
  final String name;
  final String description;
  final String imageURL;
  final List<String> ingredients;
  final List<String> direction;

  Recipe({required this.id, required this.name, required this.description, required this.imageURL, required this.ingredients, required this.direction});

  factory Recipe.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Recipe(
      id: documentId,
      name: data['name'],
      description: data['description'],
      imageURL: data['imageURL'],
      ingredients: List<String>.from(data['ingredients']),
      direction: List<String>.from(data['direction'])
    );
  }
}
