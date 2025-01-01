import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nestcure/app_bar.dart';
import 'package:nestcure/logged_user.dart';
import 'package:nestcure/persona_dependent.dart';
import 'package:nestcure/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class AddPersonaDependentWidget extends StatefulWidget {
  const AddPersonaDependentWidget({super.key});

  @override
  State<AddPersonaDependentWidget> createState() =>
      _AddPersonaDependentWidgetState();
}

class _AddPersonaDependentWidgetState extends State<AddPersonaDependentWidget> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _descripcioController = TextEditingController();
  final TextEditingController _dataNaixementController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();

  DateTime? _dataNaixement;
  String? _gender = 'Mujer';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dataNaixement = picked;
        _dataNaixementController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void _addPersonaDependent(UserProvider provider, LoggedUsuari user) async {
    if (_nomController.text.isEmpty ||
        _descripcioController.text.isEmpty ||
        _dataNaixement == null ||
        _telefonoController.text.isEmpty ||
        _direccionController.text.isEmpty ||
        _pesoController.text.isEmpty ||
        _alturaController.text.isEmpty ||
        _edadController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos obligatorios.')),
      );
      return;
    }

    final String uniqueId = const Uuid().v4();

    final nuevaPersona = PersonaDependent(
      id: uniqueId,
      nombre: _nomController.text,
      genero: _gender!,
      fechaNacimiento: _dataNaixement!,
      edad: int.parse(_edadController.text),
      telefono: _telefonoController.text,
      direccion: _direccionController.text,
      peso: double.parse(_pesoController.text),
      altura: double.parse(_alturaController.text),
      descripcion: _descripcioController.text,
    );

    final userDoc = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(FirebaseAuth.instance.currentUser?.uid);

    try {
      final docSnapshot = await userDoc.get();
      if (!docSnapshot.exists) {
        await userDoc.set({
          'nombre': FirebaseAuth.instance.currentUser?.displayName ?? 'Usuario',
          'email': FirebaseAuth.instance.currentUser?.email ?? 'No disponible',
          'personesDependents': [nuevaPersona.toJson()],
        });
      } else {
        await userDoc.update({
          'personesDependents': FieldValue.arrayUnion([nuevaPersona.toJson()]),
        });
      }

      user.usuari.personesDependents.add(nuevaPersona);
      provider.setUsuari(user.usuari);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const PersonesDependentsWidget()),
      );
    } catch (e) {
      print("Error al guardar persona dependiente en Firebase: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hubo un error al guardar la persona dependiente.')),
      );
    }
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Estás seguro de que quieres cancelar?'),
          content: const Text('Se perderán los cambios realizados.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Sí',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = LoggedUsuari();

    return Scaffold(
      appBar: customAppBar(context, true),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40.0),
                const Text(
                  'Persona con dependencia',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30.0),
                _buildTextField(_nomController, 'Nombre'),
                const SizedBox(height: 10.0),
                _buildDatePickerField(_dataNaixementController, 'Fecha Nacimiento'),
                const SizedBox(height: 10.0),
                _buildGenderSelection(),
                const SizedBox(height: 10.0),
                _buildTextField(_telefonoController, 'Teléfono', keyboardType: TextInputType.phone),
                const SizedBox(height: 10.0),
                _buildTextField(_direccionController, 'Dirección'),
                const SizedBox(height: 10.0),
                _buildTextField(_pesoController, 'Peso (kg)', keyboardType: TextInputType.number),
                const SizedBox(height: 10.0),
                _buildTextField(_alturaController, 'Altura (m)', keyboardType: TextInputType.number),
                const SizedBox(height: 10.0),
                _buildTextField(_edadController, 'Edad (años)', keyboardType: TextInputType.number),
                const SizedBox(height: 10.0),
                _buildTextField(_descripcioController, 'Descripción', maxLines: null),
                const SizedBox(height: 16.0),

                // Botones Cancelar y Guardar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: _showCancelDialog,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _addPersonaDependent(provider, user);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Guardar',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType? keyboardType, int? maxLines}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
    );
  }

  Widget _buildDatePickerField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      readOnly: true,
      onTap: () => _selectDate(context),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Género: ',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Radio<String>(
                    value: 'Mujer',
                    groupValue: _gender,
                    onChanged: (String? value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                  const Text('Mujer'),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Radio<String>(
                    value: 'Hombre',
                    groupValue: _gender,
                    onChanged: (String? value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                  const Text('Hombre'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}