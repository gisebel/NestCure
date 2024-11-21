import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nestcure/user.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: RegisterPage()));
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

  Future<bool> _isEmailRegistered(String email) async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('correu', isEqualTo: email)
          .get();

      return result.docs.isNotEmpty;
    } catch (e) {
      print('Error al verificar el correo: $e');
      return false;
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
                  'Regístrate',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Text(
              'Datos personales',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _nomCognomsController,
              decoration: InputDecoration(
                labelText: 'Nombre y Apellidos',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _dataNaixementController,
              decoration: InputDecoration(
                labelText: 'Fecha de Nacimiento',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _correuController,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _contrasenaController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
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
                Text('Cuidador profesional'),
              ],
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _experienciaPreviaController,
              decoration: InputDecoration(
                labelText: 'Experiencia previa',
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
                    child: Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      String nomCognoms = _nomCognomsController.text;
                      DateTime? dataNaixement = _selectedDate;
                      String correu = _correuController.text;
                      String contrasena = _contrasenaController.text;
                      String experienciaPrevia = _experienciaPreviaController.text;
                      bool esCuidadorPersonal = _esCuidadorPersonal;

                      if (nomCognoms.isNotEmpty &&
                          dataNaixement != null &&
                          correu.isNotEmpty &&
                          contrasena.isNotEmpty) {

                        try {
                          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: correu,
                            password: contrasena,
                          );

                          Usuari newUser = Usuari(
                            nomCognoms: nomCognoms,
                            dataNaixement: dataNaixement!,
                            correu: correu,
                            contrasena: contrasena,
                            esCuidadorPersonal: esCuidadorPersonal,
                            descripcio: experienciaPrevia,
                            fotoPerfil: '',
                            personesDependents: [],
                            activitats: [],
                          );

                          await FirebaseFirestore.instance.collection('usuarios').doc(userCredential.user!.uid).set({
                            'nomCognoms': newUser.nomCognoms,
                            'dataNaixement': newUser.dataNaixement.toIso8601String(),
                            'correu': newUser.correu,
                            'esCuidadorPersonal': newUser.esCuidadorPersonal,
                            'descripcio': newUser.descripcio,
                            'fotoPerfil': newUser.fotoPerfil,
                            'personesDependents': [],
                            'activitats': {},
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Usuario registrado correctamente')),
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al registrar el usuario: $e')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Debes completar todos los campos')),
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