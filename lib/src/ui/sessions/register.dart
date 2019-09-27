import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _controllerName = TextEditingController();
  FocusNode _focusNodeName = FocusNode();
  TextEditingController _controllerEmail = TextEditingController();
  FocusNode _focusNodeEmail = FocusNode();
  TextEditingController _controllerPassword = TextEditingController();
  FocusNode _focusNodePassword = FocusNode();
  List<FocusNode> _orderFocus = List<FocusNode>();
  bool _isDriver = false;

  @override
  void initState() {
    super.initState();
    _orderFocus.addAll([_focusNodeName, _focusNodeEmail, _focusNodePassword]);
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
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: TextField(
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
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: TextField(
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
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: TextField(
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
                ),
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
                      Switch(
                        value: _isDriver,
                        onChanged: (bool newValue) {
                          _isDriver = newValue;
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
                          print('TODO: Cadastrar');
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