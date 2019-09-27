import 'package:flutter/material.dart';
import 'package:uber_clone/src/uis/driver/panel_driver.dart';
import 'package:uber_clone/src/uis/errors/route_error.dart';
import 'package:uber_clone/src/uis/passenger/panel_passenger.dart';
import 'package:uber_clone/src/uis/sessions/login.dart';
import 'package:uber_clone/src/uis/sessions/register.dart';

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
      case '/panelDriver':
        return MaterialPageRoute(
          builder: (_) => PanelDriver()
        );
      case '/panelPassenger':
        return MaterialPageRoute(
          builder: (_) => PanelPassenger()
        );
      default:
        return MaterialPageRoute(
          builder: (_) => RouteError(settings.name)
        );
    }
  }
}