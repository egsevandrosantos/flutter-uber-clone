import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class PanelPassengerBloc {
  PublishSubject<bool> _havePermissionLocationFetcher = PublishSubject<bool>();

  Observable<bool> get havePermissionLocationFetcher => _havePermissionLocationFetcher.stream;

  Future<void> checkPermissionLocation() async {
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.locationWhenInUse);
    if (permission != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.locationWhenInUse]);
      permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.locationWhenInUse);
    }
    _havePermissionLocationFetcher.sink.add(permission == PermissionStatus.granted);
  }

  Future<void> logout() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
  }

  void dispose() {
    _havePermissionLocationFetcher.close();
  }
}