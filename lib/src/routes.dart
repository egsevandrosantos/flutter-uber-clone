import 'package:flutter/material.dart';
import 'package:uber_clone/src/ui/errors/route_error.dart';
import 'package:uber_clone/src/ui/sessions/login.dart';
import 'package:uber_clone/src/ui/sessions/register.dart';

class Routes {
  static Route<dynamic> generatedRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => Login()
        );
      case '/register':
        return MaterialPageRoute(
          builder: (_) => Register()
        );
      default:
        return MaterialPageRoute(
          builder: (_) => RouteError(settings.name)
        );
    }
  }
}