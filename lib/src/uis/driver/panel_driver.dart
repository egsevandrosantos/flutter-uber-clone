import 'package:flutter/material.dart';
import 'package:uber_clone/src/blocs/driver/panel_driver_bloc.dart';

class PanelDriver extends StatefulWidget {
  @override
  _PanelDriverState createState() => _PanelDriverState();
}

class _PanelDriverState extends State<PanelDriver> {
  PanelDriverBloc _bloc = PanelDriverBloc();
  static const _menuItemConfigurations = "Configurações";
  static const _menuItemLogout = "Sair";
  List<String> _menuItems = [_menuItemConfigurations, _menuItemLogout];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Painel Motorista'
        ),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _chooseMenuItem,
            itemBuilder: (context) {
              return _menuItems.map((i) {
                return PopupMenuItem<String>(
                  value: i,
                  child: Text(
                    i
                  ),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Container(
        color: Colors.amber,
      ),
    );
  }

  void _chooseMenuItem(String option) async {
    switch (option) {
      case _menuItemConfigurations:
        print('Option 1');
        break;
      case _menuItemLogout:
        await _bloc.logout();
        Navigator.pushReplacementNamed(context, '/');
        break;
      default:
        break;
    }
  }
}