import 'package:flutter/material.dart';
import 'package:uber_clone/src/routes.dart';

final ThemeData defaultTheme = ThemeData(
  primaryColor: Color(0xff37474F),
  accentColor: Color(0xff546E7A)
);

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uber Clone',
      theme: defaultTheme,
      initialRoute: "/",
      onGenerateRoute: Routes.generatedRoutes,
      debugShowCheckedModeBanner: false
    );
  }
}