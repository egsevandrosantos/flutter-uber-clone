import 'package:flutter/material.dart';

class RouteError extends StatelessWidget {
  final String _route;

  RouteError(this._route);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                'Página de erro.',
                style: TextStyle(
                  fontSize: 16
                ),
              ),

              SizedBox(
                height: 5,
              ),

              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Código do erro: ',
                    style: TextStyle(
                      fontSize: 18
                    ),
                  ),

                  Text(
                    '404 - Not Found.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 5,
              ),

              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Houve um erro ao acessar a rota ',
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),

                  Text(
                    _route,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ),

              SizedBox(
                height: 5,
              ),

              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).textTheme.body1.color
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Caso o erro persista envie um email para '
                            ),

                            TextSpan(
                              text: '<egs.evandro.santos@gmail.com>',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            )
                          ]
                        )
                      )
                    ],
                  ),
                )
              ),

              SizedBox(
                height: 5,
              ),

              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/');
                },
                child: Text(
                  'Voltar para o login',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 16
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}