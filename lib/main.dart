import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/recipe_provider.dart';
import './services/sqlite_service.dart';
import './services/sqlite_service_mock.dart';
import './screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dynamic databaseService;

  try {
    if (kIsWeb) {
      databaseService = MockSQLiteService();
    } else {
      databaseService = SQLiteService.instance;
    }
  } catch (e) {
    print('Error durante la inicialización del servicio de base de datos: $e');
    databaseService = MockSQLiteService();
  }

  runApp(MyApp(databaseService: databaseService));
}

class MyApp extends StatelessWidget {
  final dynamic databaseService;

  const MyApp({super.key, required this.databaseService});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = RecipeProvider(databaseService: databaseService);
        provider.loadRecipes();
        return provider;
      },
      // create: (_) => {RecipeProvider(databaseService: databaseService)},
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
