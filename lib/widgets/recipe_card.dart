import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(recipe.title[0]),
        ),
        title:
            Text(recipe.title, style: TextStyle(fontWeight: FontWeight.bold)),
        // subtitle: Text('${recipe.category} - Tags: ${recipe.tags.join(", ")}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(recipe.category),
            Text('Tags: ${recipe.tags.join(", ")}'),
          ],
        ),
        onTap: onTap,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
