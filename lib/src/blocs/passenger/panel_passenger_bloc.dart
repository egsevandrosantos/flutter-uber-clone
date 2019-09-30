import 'package:firebase_auth/firebase_auth.dart';

class PanelPassengerBloc {
  Future<void> logout() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
  }
}