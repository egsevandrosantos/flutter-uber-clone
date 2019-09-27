import 'package:flutter/material.dart';
import 'package:uber_clone/src/blocs/sessions/register_bloc.dart';
import 'package:uber_clone/src/models/enums/type_user_enum.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  RegisterBloc bloc = RegisterBloc();

  TextEditingController _controllerName = TextEditingController();
  FocusNode _focusNodeName = FocusNode();
  TextEditingController _controllerEmail = TextEditingController();
  FocusNode _focusNodeEmail = FocusNode();
  TextEditingController _controllerPassword = TextEditingController();
  FocusNode _focusNodePassword = FocusNode();
  List<FocusNode> _orderFocus = List<FocusNode>();

  void _validarCampos() {
    String name = _controllerName.text;
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;
    if (bloc.validarCampos(name, email, password))
      _confirmType();
  }

  void _progressIndicator() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }

  void _confirmType() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String type = bloc.isDriver ? TypeUserEnum.DRIVER.toString() : TypeUserEnum.PASSENGER.toString();
        return AlertDialog(
          title: Text('$type?'),
          content: Text('Você está se cadastrando como $type, tem certeza?'),
          actions: [
            FlatButton(
              child: Text("Não"),
              onPressed:  () {
                Navigator.of(context).pop();
              },
            ),

            FlatButton(
              child: Text("Sim"),
              onPressed: () async {
                _progressIndicator();
                String path = await bloc.register();
                Navigator.of(context).pop(); // Progress Indicator
                Navigator.of(context).pop(); // Confirm Dialog
                Navigator.pushNamedAndRemoveUntil(context, path, (_) => false);
              },
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _orderFocus.addAll([_focusNodeName, _focusNodeEmail, _focusNodePassword]);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(10, 15, 10, 5),
                child: StreamBuilder(
                  stream: bloc.errorsNameFetcher,
                  builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (!snapshot.hasData || (snapshot.hasData && snapshot.data.length == 0)) {
                      return TextField(
                        decoration: InputDecoration(
                          hintText: 'Nome',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          )
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        autofocus: true,
                        controller: _controllerName,
                        focusNode: _focusNodeName,
                        onSubmitted: (String value) {
                          _nextFocusNode(_focusNodeName);
                        }
                      );
                    } else {
                      Map<String, dynamic> error = snapshot.data.first;
                      return Column(
                        children: <Widget>[
                          TextField(
                            decoration: new InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 0.0),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 2.0),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              hintText: 'Nome',
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            autofocus: true,
                            controller: _controllerName,
                            focusNode: _focusNodeName,
                            onSubmitted: (String value) {
                              _nextFocusNode(_focusNodeName);
                            }
                          ),

                          Container(
                            child: Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Column(
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                      text: error['errorMessage'],
                                      style: TextStyle(
                                        color: Colors.red
                                      )
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }
                  },
                )
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: StreamBuilder(
                  stream: bloc.errorsEmailFetcher,
                  builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (!snapshot.hasData || (snapshot.hasData && snapshot.data.length == 0)) {
                      return TextField(
                        decoration: InputDecoration(
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          )
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        controller: _controllerEmail,
                        focusNode: _focusNodeEmail,
                        onSubmitted: (String value) {
                          _nextFocusNode(_focusNodeEmail);
                        },
                      );
                    } else {
                      Map<String, dynamic> error = snapshot.data.first;
                      return Column(
                        children: <Widget>[
                          TextField(
                            decoration: new InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 0.0),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 2.0),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              hintText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            controller: _controllerEmail,
                            focusNode: _focusNodeEmail,
                            onSubmitted: (String value) {
                              _nextFocusNode(_focusNodeEmail);
                            },
                          ),

                          Container(
                            child: Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Column(
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                      text: error['errorMessage'],
                                      style: TextStyle(
                                        color: Colors.red
                                      )
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }
                  },
                )
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: StreamBuilder(
                  stream: bloc.errorsPasswordFetcher,
                  builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (!snapshot.hasData || (snapshot.hasData && snapshot.data.length == 0)) {
                      return TextField(
                        decoration: InputDecoration(
                          hintText: 'Senha',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          )
                        ),
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.go,
                        controller: _controllerPassword,
                        focusNode: _focusNodePassword,
                        onSubmitted: (String value) {
                          _validarCampos();
                        },
                      );
                    } else {
                      Map<String, dynamic> error = snapshot.data.first;
                      return Column(
                        children: <Widget>[
                          TextField(
                            decoration: new InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 0.0),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 2.0),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              hintText: 'Senha',
                            ),
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.go,
                            controller: _controllerPassword,
                            focusNode: _focusNodePassword,
                            onSubmitted: (String value) {
                              _validarCampos();
                            },
                          ),

                          Container(
                            child: Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Column(
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                      text: error['errorMessage'],
                                      style: TextStyle(
                                        color: Colors.red
                                      )
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }
                  },
                )
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'Passageiro'
                      )
                    ],
                  ),

                  Column(
                    children: <Widget>[
                      StreamBuilder(
                        stream: bloc.isDriverFetcher,
                        builder: (context, AsyncSnapshot<bool> snapshot) {
                          return Switch(
                            value: snapshot.data ?? bloc.isDriver,
                            onChanged: (bool newValue) {
                              bloc.isDriver = newValue;
                            },
                          );
                        },
                      )
                    ],
                  ),

                  Column(
                    children: <Widget>[
                      Text(
                        'Motorista'
                      )
                    ],
                  )
                ],
              ),

              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: RaisedButton(
                        onPressed: () {
                          _validarCampos();
                        },
                        child: Text(
                          'Cadastrar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18
                          ),
                        ),
                        color: Colors.lightBlueAccent,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                        ),
                      ),
                    ),
                  )
                ],
              ),

              SizedBox(
                height: 10,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Voltar',
                        style: TextStyle(
                          fontSize: 15
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _nextFocusNode(FocusNode currentFocus) {
    int nextIndex = _orderFocus.indexWhere((fn) => fn == currentFocus) + 1;
    if (nextIndex < _orderFocus.length)
      FocusScope.of(context).requestFocus(_orderFocus[nextIndex]);
  }
}