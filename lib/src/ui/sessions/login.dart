import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail = TextEditingController();
  FocusNode _focusNodeEmail = FocusNode();
  TextEditingController _controllerPassword = TextEditingController();
  FocusNode _focusNodePassword = FocusNode();
  List<FocusNode> _orderFocus = List<FocusNode>();

  @override
  void initState() {
    super.initState();
    _orderFocus.addAll([_focusNodeEmail, _focusNodePassword]);
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
          child: SingleChildScrollView(
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
                        child: TextField(
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
                        ),
                      )
                    ),
                  ],
                ),

                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: TextField(
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
                        ),
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
                            print('TODO: Entrar');
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
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        print('TODO: Cadastre-se');
                      },
                      child: Text(
                        'Não tem conta? Cadastre-se.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
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