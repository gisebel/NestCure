import 'package:flutter/material.dart';
import 'sign_in.dart';

class Usuari {
  final String nomCognoms;
  final DateTime dataNaixement;
  final String correu;
  final String contrasena;
  final bool esCuidadorPersonal;
  final String descripcio;

  Usuari({
    required this.nomCognoms,
    required this.dataNaixement,
    required this.correu,
    required this.contrasena,
    required this.esCuidadorPersonal,
    required this.descripcio,
  });
}

class LoginPage extends StatelessWidget {
  final Usuari usuariHardcodeado = Usuari(
    nomCognoms: 'Gisela Beltran',
    dataNaixement: DateTime(2002, 5, 31),
    correu: 'gisela@suara.com',
    contrasena: '12345',
    esCuidadorPersonal: false,
    descripcio: 'Usuari hardcodeado',
  );

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    String usuariIngresado = '';
    String contrasenaIngresada = '';

    return Scaffold(
      key: scaffoldKey,
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
              'Inicia sessió',
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
                    onChanged: (value) {
                      usuariIngresado = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Usuari',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    onChanged: (value) {
                      contrasenaIngresada = value;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contrasenya',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      // Verifica si las credenciales ingresadas coinciden con el usuari hardcodeado
                      if (usuariIngresado == usuariHardcodeado.correu &&
                          contrasenaIngresada == usuariHardcodeado.contrasena) {
                        print('Inici de sessió exitós');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Usuari o contrasenya incorrecta'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(217, 232, 176, 1),
                    ),
                    child: Text('Iniciar Sessió'),
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No tens compte?'),
                      SizedBox(width: 10.0),
                      ElevatedButton(
                        onPressed: () {
                          // Redirecciona a la página de registro
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterPage()),
                          );
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

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}