import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class PanelPassengerBloc {
  PublishSubject<bool> _havePermissionLocationFetcher = PublishSubject<bool>();
  PublishSubject<Position> _positionFetcher = PublishSubject<Position>();

  Observable<bool> get havePermissionLocationFetcher => _havePermissionLocationFetcher.stream;
  Observable<Position> get positionFetcher => _positionFetcher.stream;

  Future<bool> checkPermissionLocation() async {
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.locationWhenInUse);
    if (permission != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.locationWhenInUse]);
      permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.locationWhenInUse);
    }
    _havePermissionLocationFetcher.sink.add(permission == PermissionStatus.granted);
    return permission == PermissionStatus.granted;
  }

  Future<void> logout() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
  }

  void dispose() {
    _havePermissionLocationFetcher.close();
    _positionFetcher.close();
  }

  void addListenerPosition() {
    Geolocator geolocator = Geolocator();
    LocationOptions locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    geolocator.getPositionStream(locationOptions).listen((Position position) {
      _positionFetcher.sink.add(position);      
    });
  }

  Future<void> getLastPosition() async {
    Position position;
    if (await checkPermissionLocation()) {
      position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
      addListenerPosition();
    } else 
      position = Position(latitude: 37.42796133580664, longitude: -122.085749655962);
    _positionFetcher.sink.add(position);
  }
}