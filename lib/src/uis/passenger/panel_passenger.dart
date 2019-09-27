import 'package:flutter/material.dart';

class PanelPassenger extends StatefulWidget {
  @override
  _PanelPassengerState createState() => _PanelPassengerState();
}

class _PanelPassengerState extends State<PanelPassenger> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,     
      child: Center(
        child: Text('Painel Passageiro'),
      ),
    );
  }
}