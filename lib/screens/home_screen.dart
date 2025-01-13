import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';
import '../screens/add_edit_recipe_screen.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'Todas';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final recipes = _selectedCategory == 'Todas'
        ? recipeProvider.recipes
        : recipeProvider.filterByCategory(_selectedCategory);

    final filteredRecipes = _searchQuery.isEmpty
        ? recipes
        : recipes.where((recipe) {
            return recipe.title
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                recipe.category
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                recipe.tags.any((tag) =>
                    tag.toLowerCase().contains(_searchQuery.toLowerCase()));
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Recetas'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar por título, categoría o etiquetas...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Selector de Categorías
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Todas', ...categories].map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: filteredRecipes.isEmpty
                ? Center(child: Text('No se encontraron recetas.'))
                : ListView.builder(
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = filteredRecipes[index];
                      return RecipeCard(
                        recipe: recipe,
                        onTap: () {
                          print('Tab Action');
                        },
                        onEdit: () {
                          // Navegar a la pantalla de edición
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddEditRecipeScreen(recipe: recipe),
                            ),
                          );
                        },
                        onDelete: () {
                          // Mostrar diálogo de confirmación para eliminar
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Eliminar Receta'),
                              content: Text(
                                  '¿Estás seguro de que deseas eliminar esta receta?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(
                                      context), // Cerrar el diálogo
                                  child: Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Provider.of<RecipeProvider>(context,
                                            listen: false)
                                        .deleteRecipe(recipe.id!);
                                    Navigator.pop(context); // Cerrar el diálogo
                                  },
                                  child: Text('Eliminar'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditRecipeScreen(),
            ),
          );
        },
        tooltip: 'Agregar receta',
        child: Icon(Icons.add),
      ),
    );
  }
}
