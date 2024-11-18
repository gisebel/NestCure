import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nestcure/app_bar.dart';
import 'package:nestcure/logged_user.dart';
import 'package:nestcure/persona_dependent.dart';
import 'package:nestcure/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

    // Crear la nueva persona dependiente
    final nuevaPersona = PersonaDependent(
      nombre: _nomController.text,
      dependeDe: user.usuari.nomCognoms,
      genero: _gender!,
      fechaNacimiento: _dataNaixement!,
      edad: int.parse(_edadController.text),
      telefono: int.parse(_telefonoController.text),
      direccion: _direccionController.text,
      peso: double.parse(_pesoController.text),
      altura: double.parse(_alturaController.text),
      descripcion: _descripcioController.text,
    );

    // Obtener el documento del usuario logueado
    final userDoc = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(FirebaseAuth.instance.currentUser?.uid);

    try {
      // Obtener el documento para ver si ya existe
      final docSnapshot = await userDoc.get();
      if (!docSnapshot.exists) {
        // Si no existe, lo creamos
        await userDoc.set({
          'nombre': FirebaseAuth.instance.currentUser?.displayName ?? 'Usuario',
          'email': FirebaseAuth.instance.currentUser?.email ?? 'No disponible',
          'personesDependents': [nuevaPersona.toJson()],
          // Puedes añadir más campos si es necesario
        });
      } else {
        // Si existe, actualizamos la lista de personesDependents
        await userDoc.update({
          'personesDependents': FieldValue.arrayUnion([nuevaPersona.toJson()]),
        });
      }

      // Actualizar el estado del provider para reflejar los cambios
      user.usuari.personesDependents.add(nuevaPersona);  // Actualizar el objeto local
      provider.setUsuari(user.usuari);

      // Navegar al listado de personas dependientes
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

  @override
  Widget build(BuildContext context) {
    var user = LoggedUsuari();

    return Scaffold(
      appBar: customAppBar(context, true),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40.0),
                const Text(
                  'Persona con dependencia',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30.0),
                TextField(
                  controller: _nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _dataNaixementController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha Nacimiento',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 10.0),
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
                const SizedBox(height: 10.0),
                TextField(
                  controller: _telefonoController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _direccionController,
                  decoration: const InputDecoration(
                    labelText: 'Dirección',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _pesoController,
                  decoration: const InputDecoration(
                    labelText: 'Peso (kg)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _alturaController,
                  decoration: const InputDecoration(
                    labelText: 'Altura (m)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _edadController,
                  decoration: const InputDecoration(
                    labelText: 'Edad (años)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _descripcioController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    onPressed: () => _addPersonaDependent(provider, user),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white, width: 2.0),
                      backgroundColor: const Color.fromRGBO(180, 205, 96, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 5,
                    ),
                    child: const Text('Crear',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
