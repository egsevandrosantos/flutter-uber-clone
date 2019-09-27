import 'package:uber_clone/src/models/enums/type_user_enum.dart';

class User {
  int _id;
  String _name;
  String _email;
  String _password;
  TypeUserEnum _type;

  User.empty();
  User(this._name, this._email, this._password, this._type);
  User.withId(this._id, this._name, this._email, this._password, this._type);
  User.login(this._email, this._password);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': _name,
      'email': _email,
      'type': _type.toValue()
    };
    return map;
  }

  int get id => _id;
  String get name => _name;
  String get email => _email;
  String get password => _password;
  TypeUserEnum get type => _type;
}