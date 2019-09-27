import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uber_clone/src/exceptions/validators/custom_exception.dart';
import 'package:uber_clone/src/models/user.dart';

class LoginBloc {
  User _user = User.empty();
  List<Map<String, dynamic>> _errorsEmail = List<Map<String, dynamic>>();
  PublishSubject<List<Map<String, dynamic>>> _errorsEmailFetcher = PublishSubject<List<Map<String, dynamic>>>();
  List<Map<String, dynamic>> _errorsPassword = List<Map<String, dynamic>>();
  PublishSubject<List<Map<String, dynamic>>> _errorsPasswordFetcher = PublishSubject<List<Map<String, dynamic>>>();

  Observable<List<Map<String, dynamic>>> get errorsEmailFetcher => _errorsEmailFetcher.stream;
  Observable<List<Map<String, dynamic>>> get errorsPasswordFetcher => _errorsPasswordFetcher.stream;

  bool validarCampos(String email, String password) {
    _errorsEmail = List<Map<String, dynamic>>();
    _errorsPassword = List<Map<String, dynamic>>();
    List<Map<String, dynamic>> errors = List<Map<String, dynamic>>(); 

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
      _user = User.login(email, password);
      return true;
    }
    return false;
  }

  Future<Map<String, String>> logar() async {
    Map<String, String> result = {};
    result['path'] = '';
    result['error'] = '';

    FirebaseAuth auth = FirebaseAuth.instance;
    AuthResult firebaseUser = await auth.signInWithEmailAndPassword(
      email: _user.email,
      password: _user.password
    );
    if (firebaseUser == null)
      result['error'] = 'Erro ao autenticar, verifique os dados e tente novamente.';
    else 
      result['path'] = '/panelPassenger';
    return result;
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

  void dispose() {
    _errorsEmailFetcher.close();
    _errorsPasswordFetcher.close();
  }
}