import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

class RecipeProvider extends ChangeNotifier {
  final dynamic databaseService;

  List<Recipe> _recipes = [];
  bool _isLoading = false;

  RecipeProvider({required this.databaseService});

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;

  Future<void> saveRecipesToLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recipesJson = _recipes.map((recipe) => recipe.toMap()).toList();
      await prefs.setString('recipes', jsonEncode(recipesJson));
      print('Recetas guardadas localmente');
    } catch (e) {
      print('Error al guardar recetas localmente: $e');
    }
  }

  Future<void> loadRecipesFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recipesString = prefs.getString('recipes');
      if (recipesString != null) {
        final recipesJson = jsonDecode(recipesString) as List<dynamic>;
        _recipes =
            recipesJson.map((recipeMap) => Recipe.fromMap(recipeMap)).toList();
        print('Recetas cargadas desde almacenamiento local');
      } else {
        print('No se encontraron recetas en almacenamiento local');
      }
    } catch (e) {
      print('Error al cargar recetas localmente: $e');
    }
  }

  Future<void> loadRecipes() async {
    _isLoading = true;
    notifyListeners();
    try {
      _recipes = await databaseService.fetchRecipes();
      await saveRecipesToLocalStorage();
      print('Recetas cargadas desde la base de datos remota');
    } catch (e) {
      print('Error al cargar recetas de la base de datos remota: $e');
      await loadRecipesFromLocalStorage();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    try {
      await databaseService.insertRecipe(recipe);
      await loadRecipes();
    } catch (e) {
      print('Error al agregar receta: $e');
    }
  }

  Future<void> updateRecipe(Recipe recipe) async {
    try {
      await databaseService.updateRecipe(recipe);
      await loadRecipes();
    } catch (e) {
      print('Error al actualizar receta: $e');
    }
  }

  Future<void> deleteRecipe(int id) async {
    try {
      await databaseService.deleteRecipe(id);
      _recipes.removeWhere((recipe) => recipe.id == id);
      await saveRecipesToLocalStorage();
      notifyListeners();
    } catch (e) {
      print('Error al eliminar receta: $e');
    }
  }

  List<Recipe> filterByCategory(String category) {
    return _recipes.where((recipe) => recipe.category == category).toList();
  }

  List<Recipe> searchRecipes(String query) {
    return _recipes.where((recipe) {
      final titleMatch =
          recipe.title.toLowerCase().contains(query.toLowerCase());
      final categoryMatch =
          recipe.category.toLowerCase().contains(query.toLowerCase());
      final tagMatch = recipe.tags
          .any((tag) => tag.toLowerCase().contains(query.toLowerCase()));

      return titleMatch || categoryMatch || tagMatch;
    }).toList();
  }
}
