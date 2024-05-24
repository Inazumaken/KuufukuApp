import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/screens/recipe_detail_screen.dart';
import 'package:recipe_app/services/recipe_service.dart';
import 'package:recipe_app/models/recipe.dart';
import 'dart:ui';


class RecipeListScreen extends StatefulWidget {
  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String searchQuery = '';

  Stream<List<Recipe>> getRecipes() {
    return _db.collection('recipe').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Recipe.fromFirestore(doc.data(), doc.id)).toList());
  }

  @override
  Widget build(BuildContext context) {
    final recipeService = Provider.of<RecipeService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('KUUFUKU', style: TextStyle(fontFamily: 'NotoSerifJP', color: Colors.white)),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: RecipeSearchDelegate());
            },
          ),
        ],
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
              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('recipe').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('An error occurred, please try again later.'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No recipes found'));
              }

              var recipes = snapshot.data!.docs.where((doc) {
                String name = doc['name'].toString().toLowerCase();
                String description = doc['description'].toString().toLowerCase();
                String ingredients = doc['ingredients'].toString().toLowerCase();
                String direction = doc['direction'].toString().toLowerCase();
                return name.contains(searchQuery.toLowerCase()) ||
                       description.contains(searchQuery.toLowerCase()) ||
                       ingredients.contains(searchQuery.toLowerCase());
              }).toList();

              return ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return Card(
                    color: Colors.white.withOpacity(0.8),
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(8.0),
                      leading: Hero(
                        tag: 'recipeImage-${recipe.id}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            recipe['imageURL'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        recipe['name'],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'NotoSerifJP', color: Colors.redAccent),
                      ),
                      subtitle: Text(
                        recipe['description'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[600], fontFamily: 'NotoSerifJP'),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailScreen(recipe: recipe),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class RecipeSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return RecipeListScreen();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('recipe').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

        final results = snapshot.data!.docs.where((doc) {
          String name = doc['name'].toString().toLowerCase();
          String description = doc['description'].toString().toLowerCase();
          String ingredients = doc['ingredients'].toString().toLowerCase();
          return name.contains(query.toLowerCase()) ||
                 description.contains(query.toLowerCase()) ||
                 ingredients.contains(query.toLowerCase());
        }).toList();

        return ListView(
          children: results.map<Widget>((doc) {
            return ListTile(
              leading: Hero(
                tag: 'recipeImage-${doc.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    doc['imageURL'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                doc['name'],
                style: TextStyle(fontFamily: 'NotoSerifJP', color: Colors.redAccent),
              ),
              subtitle: Text(
                doc['description'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontFamily: 'NotoSerifJP'),
              ),
              onTap: () {
                close(context, null);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailScreen(recipe: doc),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
