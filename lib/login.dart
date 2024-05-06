import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(255, 255, 251, 245), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'images/logo.jpg', 
                width: 200,
                height: 200,
              ),
            ),
            SizedBox(height: 20.0), 
            Text(
              'Inicia sesión',
              style: TextStyle(
                fontSize: 24.0, 
                fontWeight: FontWeight.bold, 
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Usuari',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contrasenya',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      // verificar cuenta
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(217, 232, 176, 1), 
                    ),
                    child: Text('Iniciar Sesión'),
                  ),
                  SizedBox(height: 15.0), 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No tens compte?'), 
                      SizedBox(width: 10.0), 
                      ElevatedButton(
                        onPressed: () {
                          // crear cuenta
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(255, 255, 251, 245), 
                        ),
                        child: Text('Crear'), 
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
