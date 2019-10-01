import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  Set<Marker> _markers = Set<Marker>();

  @override
  void initState() {
    super.initState();
    _bloc.getLastPosition();
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
            return StreamBuilder(
              stream: _bloc.positionFetcher,
              builder: (context, AsyncSnapshot<Position> position) {
                if (position.hasData) {
                  _addMarkerPassenger(position.data);
                  return Stack(
                    children: <Widget>[
                      GoogleMap(
                        myLocationEnabled: havePermissionLocation.data,
                        myLocationButtonEnabled: false,
                        markers: _markers,
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(position.data.latitude, position.data.longitude),
                          zoom: 16
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),

                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ),
                            hintText: "Meu Local",
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)
                            )
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 75, 10, 10),
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.local_taxi,
                              color: Colors.yellow[600],
                            ),
                            hintText: "Destino",
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)
                            )
                          ),
                        ),
                      ),

                      Positioned.fill(
                        bottom: 10,
                        left: 10,
                        right: 10,
                        top: MediaQuery.of(context).size.height * 0.80,
                        child: RaisedButton(
                          onPressed: (){
                            print('Chamar');
                          },
                          color: Color(0xff1EBBD8),
                          child: Text(
                            'Chamar Uber',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                } 
                return Center(
                  child: CircularProgressIndicator()
                );
              },
            );
          }
          return Center( 
            child: CircularProgressIndicator()
          );
        },
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

  void _addMarkerPassenger(Position position) {
    Set<Marker> markers = Set<Marker>();

    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: pixelRatio), 
      'images/passageiro.png'
    ).then((icon) {
      Marker passengerMarker = Marker(
        markerId: MarkerId('passengerMarker'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(
          title: 'Meu local'
        ),
        icon: icon
      );

      markers.add(passengerMarker);
    });

    _markers = markers;
  }
}