import 'package:flutter/material.dart';
import 'package:teste_bus2/data/services/setup/database_provider.dart';
import 'package:teste_bus2/presentation/views/home/home_screen.dart';
import 'package:teste_bus2/support/service_locator/service_locator.dart';

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
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: HomeScreen(),
    );
  }
}
