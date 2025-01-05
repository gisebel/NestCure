import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nestcure/user.dart';
import 'package:nestcure/login.dart';

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
  String _genero = 'Mujer';  // Variable para almacenar el género seleccionado

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dataNaixementController.text = DateFormat('dd-MM-yyyy').format(picked);
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
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Divider(color: Colors.grey.shade400),
            SizedBox(height: 10.0),
            Text(
              'Datos personales',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10.0),
            _buildTextField(
              controller: _nomCognomsController,
              labelText: 'Nombre y Apellidos',
              icon: Icons.person,
            ),
            SizedBox(height: 10.0),
            _buildTextField(
              controller: _dataNaixementController,
              labelText: 'Fecha de Nacimiento',
              icon: Icons.calendar_today,
              isReadOnly: true,
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 10.0),
            _buildTextField(
              controller: _correuController,
              labelText: 'Correo electrónico',
              icon: Icons.email,
            ),
            SizedBox(height: 10.0),
            _buildTextField(
              controller: _contrasenaController,
              labelText: 'Contraseña',
              icon: Icons.lock,
              isObscure: true,
            ),
            SizedBox(height: 20.0),
            Text(
              'Rol del perfil',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
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
            _buildTextField(
              controller: _experienciaPreviaController,
              labelText: 'Experiencia previa',
              icon: Icons.description,
            ),
            SizedBox(height: 20.0),
            Text(
              'Género',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Row(
              children: [
                Row(
                  children: [
                    Radio<String>(
                      value: 'Mujer',
                      groupValue: _genero,
                      onChanged: (value) {
                        setState(() {
                          _genero = value!;
                        });
                      },
                    ),
                    Text('Mujer'),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Hombre',
                      groupValue: _genero,
                      onChanged: (value) {
                        setState(() {
                          _genero = value!;
                        });
                      },
                    ),
                    Text('Hombre'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(255, 102, 102, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0,
                    ),
                    child: Text('Cancelar', style: TextStyle(fontSize: 16.0)),
                  ),
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
                        UserCredential userCredential =
                            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: correu,
                          password: contrasena,
                        );

                        Usuari newUser = Usuari(
                          nomCognoms: nomCognoms,
                          dataNaixement: dataNaixement,
                          correu: correu,
                          esCuidadorPersonal: esCuidadorPersonal,
                          descripcio: experienciaPrevia,
                          fotoPerfil: '',
                          personesDependents: [],
                          activitats: [],
                          tests: {
                            'basicAttentionKnowledgeTest': false,
                            'intermediateHealthKnowledgeTest': false,
                            'advancedHealthKnowledgeTest': false,
                            'basicCommunicationSkillsTest': false,
                            'intermediateAttentionKnowledgeTest': false,
                            'advancedAttentionKnowledgeTest': false,
                            'basicPracticalSkillsTest': false,
                            'intermediateCommunicationSkillsTest': false,
                            'advancedCommunicationSkillsTest': false,
                            'intermediatePracticalSkillsTest': false,
                            'advancedPracticalSkillsTest': false,
                            'basicHealthKnowledgeTest': false,
                          },
                          certificats: [],
                          genero: _genero,  // Guardamos el género
                        );

                        await FirebaseFirestore.instance
                            .collection('usuarios')
                            .doc(userCredential.user!.uid)
                            .set({
                          'nomCognoms': newUser.nomCognoms,
                          'dataNaixement': newUser.dataNaixement.toIso8601String(),
                          'correu': newUser.correu,
                          'esCuidadorPersonal': newUser.esCuidadorPersonal,
                          'descripcio': newUser.descripcio,
                          'fotoPerfil': newUser.fotoPerfil,
                          'personesDependents': [],
                          'activitats': [],
                          'tests': newUser.tests,
                          'certificats': [],
                          'genero': newUser.genero,  // Guardamos el género en Firestore
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0,
                    ),
                    child: Text('Crear', style: TextStyle(fontSize: 16.0)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool isObscure = false,
    bool isReadOnly = false,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      readOnly: isReadOnly,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.black54),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        filled: true,
        fillColor: Colors.grey.shade100,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.blue.shade300),
        ),
      ),
      onTap: onTap,
    );
  }
}