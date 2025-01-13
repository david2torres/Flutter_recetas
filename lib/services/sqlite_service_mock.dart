import '../models/recipe.dart';

class MockSQLiteService {
  final List<Recipe> _mockData = [];

  Future<List<Recipe>> fetchRecipes() async {
    await Future.delayed(Duration(milliseconds: 200));
    return _mockData;
  }

  Future<void> insertRecipe(Recipe recipe) async {
    await Future.delayed(Duration(milliseconds: 100));
    _mockData.add(recipe);
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await Future.delayed(Duration(milliseconds: 100));
    final index = _mockData.indexWhere((r) => r.id == recipe.id);
    if (index != -1) {
      _mockData[index] = recipe;
    }
  }

  Future<void> deleteRecipe(int id) async {
    await Future.delayed(Duration(milliseconds: 100));
    _mockData.removeWhere((r) => r.id == id);
  }
}
