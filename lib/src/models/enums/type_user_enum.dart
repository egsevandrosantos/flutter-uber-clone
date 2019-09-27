class TypeUserEnum {
  final int _value;
  final String _display;
  const TypeUserEnum._internal(this._value, this._display);
  toString() => _display;
  int toValue() => _value;

  static const PASSENGER = const TypeUserEnum._internal(1, 'Passageiro');
  static const DRIVER = const TypeUserEnum._internal(2, 'Motorista');
}