import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/models/recipe.dart';

class RecipeService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Recipe>> getRecipes() {
    return _db.collection('recipe').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Recipe.fromFirestore(doc.data(), doc.id)).toList());
  }
}
