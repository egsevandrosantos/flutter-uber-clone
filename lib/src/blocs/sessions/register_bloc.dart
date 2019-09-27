import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uber_clone/src/exceptions/validators/custom_exception.dart';
import 'package:uber_clone/src/models/enums/type_user_enum.dart';
import 'package:uber_clone/src/models/user.dart';

class RegisterBloc {
  bool _isDriver = false;
  final PublishSubject<bool> _isDriverFetcher = PublishSubject<bool>();
  User user = User.empty();
  List<Map<String, dynamic>> _errorsName = List<Map<String, dynamic>>();
  final PublishSubject<List<Map<String, dynamic>>> _errorsNameFetcher = PublishSubject<List<Map<String, dynamic>>>();
  List<Map<String, dynamic>> _errorsEmail = List<Map<String, dynamic>>();
  final PublishSubject<List<Map<String, dynamic>>> _errorsEmailFetcher = PublishSubject<List<Map<String, dynamic>>>();
  List<Map<String, dynamic>> _errorsPassword = List<Map<String, dynamic>>();
  final PublishSubject<List<Map<String, dynamic>>> _errorsPasswordFetcher = PublishSubject<List<Map<String, dynamic>>>();

  bool get isDriver => _isDriver;
  Observable<bool> get isDriverFetcher => _isDriverFetcher.stream;
  Observable<List<Map<String, dynamic>>> get errorsNameFetcher => _errorsNameFetcher.stream;
  Observable<List<Map<String, dynamic>>> get errorsEmailFetcher => _errorsEmailFetcher.stream;
  Observable<List<Map<String, dynamic>>> get errorsPasswordFetcher => _errorsPasswordFetcher.stream;

  set isDriver(bool value) {
    _isDriver = value;
    _isDriverFetcher.sink.add(_isDriver);
  }

  bool validarCampos(String name, String email, String password) {
    _errorsName = List<Map<String, dynamic>>();
    _errorsEmail = List<Map<String, dynamic>>();
    _errorsPassword = List<Map<String, dynamic>>();
    List<Map<String, dynamic>> errors = List<Map<String, dynamic>>();

    try {
      name = _notBlankValidator(name, 'Nome');
      _lengthValidator(name, 'Nome', max: 30);
    } on CustomException catch (e) {
      errors.add(e.error);
      _errorsName.add(e.error);
    }
    _errorsNameFetcher.sink.add(_errorsName);

    try {
      email = _notBlankValidator(email, 'Email');
      _lengthValidator(email, 'Email', max: 50);
    } on CustomException catch (e) {
      errors.add(e.error);
      _errorsEmail.add(e.error);
    }
    _errorsEmailFetcher.sink.add(_errorsEmail);

    try {
      password = _notBlankValidator(password, 'Senha');
      _lengthValidator(password, 'Senha', min: 6, max: 20);
    } on CustomException catch (e) {
      errors.add(e.error);
      _errorsPassword.add(e.error);
    }
    _errorsPasswordFetcher.sink.add(_errorsPassword);

    if (errors.length == 0) {
      TypeUserEnum typeUser = _isDriver ? TypeUserEnum.DRIVER : TypeUserEnum.PASSENGER;
      user = User(name, email, password, typeUser);
      return true;
    }
    return false;
  }

  String _notBlankValidator(String value, String nomeCampo) {
    if (value == null || value.trim().isEmpty) {
      Map<String, dynamic> error = Map<String, dynamic>();
      error['campo'] = nomeCampo;
      error['errorMessage'] = 'O campo $nomeCampo não pode ser vazio ou conter apenas espaços.';
      throw new CustomException(error);
    } else
      value = value.trim();
    return value;
  }

  void _lengthValidator(String value, String nomeCampo, {int min, int max}) {
    if (min != null || max != null) {
      if (min != null && value.length < min) {
        Map<String, dynamic> error = Map<String, dynamic>();
        error['campo'] = nomeCampo;
        error['errorMessage'] = 'O campo $nomeCampo deve ter no mínimo $min caracteres.';
        throw new CustomException(error);
      }

      if (max != null && value.length > max) {
        Map<String, dynamic> error = Map<String, dynamic>();
        error['campo'] = nomeCampo;
        error['errorMessage'] = 'O campo $nomeCampo deve ter no máximo $max caracteres.';
        throw new CustomException(error);
      }
    }
  }

  Future<String> register() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    Firestore db = Firestore.instance;

    AuthResult firebaseUser = await auth.createUserWithEmailAndPassword(
      email: user.email,
      password: user.password
    );
    db.collection('users').document(firebaseUser.user.uid).setData(user.toMap());
    if (user.type == TypeUserEnum.DRIVER)
      return '/panelDriver';
    else
      return '/panelPassenger';
  }

  void dispose() {
    _isDriverFetcher.close();
    _errorsNameFetcher.close();
    _errorsEmailFetcher.close();
    _errorsPasswordFetcher.close();
  }
}