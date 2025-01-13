class Recipe {
  final int? id;
  final String title;
  final String description;
  final String category;
  final List<String> tags;

  Recipe({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.tags,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'tags': tags.join(','),
    };
  }

  static Recipe fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      tags: (map['tags'] as String).split(','),
    );
  }
}
