import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone/src/blocs/passenger/panel_passenger_bloc.dart';

class PanelPassenger extends StatefulWidget {
  @override
  _PanelPassengerState createState() => _PanelPassengerState();
}

class _PanelPassengerState extends State<PanelPassenger> {
  PanelPassengerBloc _bloc = PanelPassengerBloc();
  static const _menuItemConfigurations = "Configurações";
  static const _menuItemLogout = "Sair";
  List<String> _menuItems = [_menuItemConfigurations, _menuItemLogout];
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    _bloc.checkPermissionLocation();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Painel Passageiro'
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
      body: StreamBuilder(
        stream: _bloc.havePermissionLocationFetcher,
        builder: (context, AsyncSnapshot<bool> havePermissionLocation) {
          if (havePermissionLocation.hasData) {
            return GoogleMap(
              myLocationEnabled: havePermissionLocation.data,
              myLocationButtonEnabled: havePermissionLocation.data,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            );
          }
          return Center( 
            child: CircularProgressIndicator()
          );
        },
      )
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