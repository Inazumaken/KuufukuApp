import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/screens/recipe_list_screen.dart';
import 'package:recipe_app/services/recipe_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<RecipeService>(
          create: (_) => RecipeService(),
        ),
      ],
      child: MaterialApp(
        title: 'Recipe Browser',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: RecipeListScreen(),
      ),
    );
  }
}
