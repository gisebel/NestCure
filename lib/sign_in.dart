import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nomCognomsController = TextEditingController();
  final TextEditingController _dataNaixementController = TextEditingController();
  final TextEditingController _correuController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _experienciaPreviaController = TextEditingController();

  DateTime? _selectedDate;
  bool _esCuidadorPersonal = false;
  // Lista de correos electrónicos registrados
  List<String> _registeredEmails = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dataNaixementController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.0),
            Row(
              children: [
                Image.asset(
                  'images/logo.jpg',
                  width: 50,
                  height: 50,
                ),
                SizedBox(width: 10.0),
                Text(
                  'Registra\'t',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Text(
              'Dades personals',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _nomCognomsController,
              decoration: InputDecoration(
                labelText: 'Nom i Cognoms',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _dataNaixementController,
              decoration: InputDecoration(
                labelText: 'Data de Naixement',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _correuController,
              decoration: InputDecoration(
                labelText: 'Correu Electrònic',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _contrasenaController,
              decoration: InputDecoration(
                labelText: 'Contrasenya',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            Text(
              'Rol del perfil',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: _esCuidadorPersonal,
                  onChanged: (bool? value) {
                    setState(() {
                      _esCuidadorPersonal = value ?? false;
                    });
                  },
                ),
                Text('Cuidador professional'),
              ],
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _experienciaPreviaController,
              decoration: InputDecoration(
                labelText: 'Experiència prèvia',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(255, 102, 102, 1),
                    ),
                    child: Text('Cancel·lar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String nomCognoms = _nomCognomsController.text;
                      DateTime? dataNaixement = _selectedDate;
                      String correu = _correuController.text;
                      String contrasena = _contrasenaController.text;
                      String experienciaPrevia = _experienciaPreviaController.text;
                      bool esCuidadorPersonal = _esCuidadorPersonal;

                      if (_registeredEmails.contains(correu)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Aquest correu electrònic ja està registrat')),
                        );
                      } else if (nomCognoms.isNotEmpty &&
                          dataNaixement != null &&
                          correu.isNotEmpty &&
                          contrasena.isNotEmpty) {
                        _registeredEmails.add(correu);

                        print(
                            'Registre correcte: $nomCognoms, $dataNaixement, $correu, $esCuidadorPersonal, $experienciaPrevia');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Usuari registrat correctament')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Has de completar tots els camps')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(217, 232, 176, 1),
                    ),
                    child: Text('Crear'),
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
    home: RegisterPage(),
  ));
}
