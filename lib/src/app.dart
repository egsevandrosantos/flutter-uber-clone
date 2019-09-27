import 'package:flutter/material.dart';
import 'package:uber_clone/src/ui/sessions/login.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uber Clone',
      debugShowCheckedModeBanner: false,
      home: Login()
    );
  }
}