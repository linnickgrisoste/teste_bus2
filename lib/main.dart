import 'package:flutter/material.dart';
import 'package:teste_bus2/data/services/setup/database_provider.dart';
import 'package:teste_bus2/di/service_locator.dart';
import 'package:teste_bus2/routing/app_router.dart';
import 'package:teste_bus2/ui/core/styles/app_themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDependencies();
  await DatabaseProvider.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.theme,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
