import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

import '../models/recipe.dart';

class SQLiteService {
  static final SQLiteService _instance = SQLiteService._internal();
  SQLiteService._internal();
  static SQLiteService get instance => _instance;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      // Desktop
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'recipes.db');

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE recipes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        category TEXT NOT NULL,
        tags TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertRecipe(Recipe recipe) async {
    final db = await database;
    return await db.insert('recipes', recipe.toMap());
  }

  Future<List<Recipe>> fetchRecipes() async {
    final db = await database;
    final maps = await db.query('recipes');
    return maps.map((map) => Recipe.fromMap(map)).toList();
  }

  Future<int> updateRecipe(Recipe recipe) async {
    final db = await database;
    return await db.update('recipes', recipe.toMap(),
        where: 'id = ?', whereArgs: [recipe.id]);
  }

  Future<int> deleteRecipe(int id) async {
    final db = await database;
    return await db.delete('recipes', where: 'id = ?', whereArgs: [id]);
  }
}
