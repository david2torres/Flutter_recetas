import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import '../utils/constants.dart';

class AddEditRecipeScreen extends StatefulWidget {
  final Recipe? recipe;

  const AddEditRecipeScreen({super.key, this.recipe});

  @override
  _AddEditRecipeScreenState createState() => _AddEditRecipeScreenState();
}

class _AddEditRecipeScreenState extends State<AddEditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late String _category;
  late String _tags;

  @override
  void initState() {
    super.initState();
    _title = widget.recipe?.title ?? '';
    _description = widget.recipe?.description ?? '';
    _category = widget.recipe?.category ??
        categories.first; // Default: primera categoría
    _tags = widget.recipe?.tags.join(', ') ?? '';
  }

  void _saveRecipe() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final recipeProvider =
          Provider.of<RecipeProvider>(context, listen: false);

      final newRecipe = Recipe(
        id: widget.recipe?.id,
        title: _title,
        description: _description,
        category: _category,
        tags: _tags.split(',').map((tag) => tag.trim()).toList(),
      );

      if (widget.recipe == null) {
        recipeProvider.addRecipe(newRecipe);
      } else {
        recipeProvider.updateRecipe(newRecipe);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe == null ? 'Agregar Receta' : 'Editar Receta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo requerido' : null,
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo requerido' : null,
                onSaved: (value) => _description = value!,
              ),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(labelText: 'Categoría'),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                  });
                },
                onSaved: (value) {
                  _category = value!;
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Selecciona una categoría'
                    : null,
              ),
              TextFormField(
                initialValue: _tags,
                decoration: InputDecoration(
                    labelText: 'Etiquetas (separadas por comas)'),
                onSaved: (value) => _tags = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveRecipe,
                child: Text(widget.recipe == null ? 'Guardar' : 'Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
