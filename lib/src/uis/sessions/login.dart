import 'package:flutter/material.dart';
import 'package:uber_clone/src/blocs/sessions/login_bloc.dart';
import 'package:uber_clone/src/models/enums/type_user_enum.dart';
import 'package:uber_clone/src/models/user.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginBloc bloc = LoginBloc();

  TextEditingController _controllerEmail = TextEditingController();
  FocusNode _focusNodeEmail = FocusNode();
  TextEditingController _controllerPassword = TextEditingController();
  FocusNode _focusNodePassword = FocusNode();
  List<FocusNode> _orderFocus = List<FocusNode>();

  @override
  void initState() {
    super.initState();
    _orderFocus.addAll([_focusNodeEmail, _focusNodePassword]);
    bloc.verifyCurrentUser();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
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

  Future<void> _validarCampos() async {
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;
    if (bloc.validarCampos(email, password)) {
      _progressIndicator();
      Map<String, dynamic> result = await bloc.logar();
      Navigator.of(context).pop(); // Progress Indicator
      if (result['user'] != null)
        _gotoUrlByTypeOfUser(result['user']);
      else if (result['error'] != '')
        _showError(result['error']);
    }
  }

  void _showError(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro.'),
          content: Text(error),
          actions: [
            FlatButton(
              child: Text("Ok"),
              onPressed: () async {
                Navigator.of(context).pop(); // Confirm Dialog
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/fundo.png'),
            fit: BoxFit.fill
          )
        ),
        child: Center(
          child: StreamBuilder(
            stream: bloc.currentUserFetcher,
            builder: (context, AsyncSnapshot<User> snapshot) {
              if (snapshot.hasData && snapshot.data.equals(null)) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Image.asset(
                                'images/logo.png',
                                width: 150,
                                height: 150
                              ),
                            ),
                          )
                        ],
                      ),

                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: StreamBuilder(
                                stream: bloc.errorsEmailFetcher,
                                builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                                  if (!snapshot.hasData || (snapshot.hasData && snapshot.data.length == 0)) {
                                    return TextField(
                                      controller: _controllerEmail,
                                      focusNode: _focusNodeEmail,
                                      autofocus: true,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      onSubmitted: (String value) {
                                        _nextFocusNode(_focusNodeEmail);
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                        hintText: 'Email'
                                      ),
                                    );
                                  } else {
                                    Map<String, dynamic> error = snapshot.data.first;
                                    return Column(
                                      children: <Widget>[
                                        TextField(
                                          decoration: new InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.red, width: 1.0),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.red, width: 3.0),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            hintText: 'Email',
                                          ),
                                          controller: _controllerEmail,
                                          focusNode: _focusNodeEmail,
                                          autofocus: true,
                                          keyboardType: TextInputType.emailAddress,
                                          textInputAction: TextInputAction.next,
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
                            )
                          ),
                        ],
                      ),

                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: StreamBuilder(
                                stream: bloc.errorsPasswordFetcher,
                                builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                                  if (!snapshot.hasData || (snapshot.hasData && snapshot.data.length == 0)) {
                                    return TextField(
                                      controller: _controllerPassword,
                                      focusNode: _focusNodePassword,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.go,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                        hintText: 'Senha'
                                      ),
                                      obscureText: true,
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
                                            filled: true,
                                            fillColor: Colors.white,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.red, width: 1.0),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.red, width: 3.0),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            hintText: 'Senha',
                                          ),
                                          controller: _controllerPassword,
                                          focusNode: _focusNodePassword,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.go,
                                          obscureText: true,
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
                            )
                          )
                        ],
                      ),

                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                              child: RaisedButton(
                                onPressed: () {
                                  _validarCampos();
                                },
                                child: Text(
                                  'Entrar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20
                                  ),
                                ),
                                color: Colors.cyan,
                                padding: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)
                                ),
                              ),
                            ),
                          )
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, "/register");
                              },
                              child: Center(
                                child: Text(
                                  'Não tem conta? Cadastre-se.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              )
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              } else if (snapshot.hasData) {
                callbackStreamBuilder(() {
                  _gotoUrlByTypeOfUser(snapshot.data);
                });
              }
              return CircularProgressIndicator();
            },
          )
        ),
      ),
    );
  }

  void callbackStreamBuilder(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  void _gotoUrlByTypeOfUser(User user) {
    if (user == null) return;
    if (user.type == TypeUserEnum.DRIVER)
      Navigator.pushReplacementNamed(context, '/panelDriver');
    else
      Navigator.pushReplacementNamed(context, '/panelPassenger');
  }

  void _nextFocusNode(FocusNode currentFocus) {
    int nextIndex = _orderFocus.indexWhere((fn) => fn == currentFocus) + 1;
    if (nextIndex < _orderFocus.length)
      FocusScope.of(context).requestFocus(_orderFocus[nextIndex]);
  }
}