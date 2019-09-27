import 'package:flutter/material.dart';

class PanelDriver extends StatefulWidget {
  @override
  _PanelDriverState createState() => _PanelDriverState();
}

class _PanelDriverState extends State<PanelDriver> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text('Painel Motorista')
      ),
    );
  }
}