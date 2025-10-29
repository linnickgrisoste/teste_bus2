import 'package:flutter/material.dart';
import 'package:teste_bus2/data/models/user_model.dart';
import 'package:teste_bus2/routing/route_names.dart';
import 'package:teste_bus2/ui/home/widgets/home_screen.dart';
import 'package:teste_bus2/ui/user_detail/widgets/user_detail_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case RouteNames.userDetail:
        return MaterialPageRoute(builder: (_) => UserDetailScreen(user: settings.arguments as UserModel));
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}
