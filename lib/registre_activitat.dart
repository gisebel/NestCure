import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nestcure/activitat.dart';
import 'package:nestcure/app_bar.dart';
import 'package:nestcure/logged_user.dart';
import 'package:nestcure/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nestcure/llistat_activitats.dart';
import 'package:uuid/uuid.dart';

class RegistreActivitatPage extends StatefulWidget {
  const RegistreActivitatPage({super.key});

  @override
  State<RegistreActivitatPage> createState() => _RegistreActivitatState();
}

class _RegistreActivitatState extends State<RegistreActivitatPage> {
  final TextEditingController _titolController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _horesController = TextEditingController();
  final TextEditingController _descripcioController = TextEditingController();

  DateTime? _selectedDate;
  String? selectedPersonaCuidada;
  String? selectedTipusActivitat;

  List<String> tipusActivitats = [
    'Higiene personal',
    'Higiene del hogar',
    'Soporte emocional',
    'Rehabilitación',
    'Compra',
    'Gestión',
    'Actividad diaria',
    'Otros',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await LoggedUsuari().loginWithFirebase();
    setState(() {});
  }

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
        _dataController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = LoggedUsuari().usuari;

    List<String> personesCuidades = [];

    if (user.personesDependents.isEmpty) {
      print("No hay personas dependientes. Lista vacía.");
    } else {
      for (var persona in user.personesDependents) {
        if (persona.nombre.isEmpty) {
          print("Persona sin nombre detectada.");
        } else {
          print("Persona cuidada detectada: ${persona.nombre}");
          personesCuidades.add(persona.nombre);
        }
      }
    }

    return Scaffold(
      appBar: customAppBar(context, true),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40.0),
                const Text(
                  'Registra la actividad',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30.0),
                TextField(
                  controller: _titolController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _dataController,
                        decoration: InputDecoration(
                          labelText: 'Fecha',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(29.0),
                          ),
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: TextField(
                        controller: _horesController,
                        decoration: InputDecoration(
                          labelText: 'Horas',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(29.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                DropdownButtonFormField<String>(
                  value: selectedTipusActivitat,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTipusActivitat = newValue;
                    });
                  },
                  items: tipusActivitats
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.normal),
                            ),
                          ))
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: 'Tipo de actividad',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10.0),
                DropdownButtonFormField<String>(
                  value: selectedPersonaCuidada,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPersonaCuidada = newValue;
                    });
                  },
                  items: personesCuidades
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.normal),
                            ),
                          ))
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: 'Persona cuidada',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _descripcioController,
                  decoration: const InputDecoration(
                    labelText: 'Detalles de la actividad',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            color: Color.fromRGBO(45, 87, 133, 1),
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (selectedPersonaCuidada == null ||
                              _selectedDate == null ||
                              selectedTipusActivitat == null ||
                              _titolController.text.isEmpty ||
                              _horesController.text.isEmpty ||
                              _descripcioController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Rellena todos los campos'),
                              ),
                            );
                            return;
                          }
                          if (int.tryParse(_horesController.text) == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Las horas tienen que ser un número'),
                              ),
                            );
                            return;
                          }
                          final String uniqueId = const Uuid().v4();
                          final actividad = Activitat(
                            id: uniqueId,
                            title: _titolController.text,
                            description: _descripcioController.text,
                            hours: int.parse(_horesController.text),
                            date: _selectedDate!,
                            type: selectedTipusActivitat!,
                            dependantName: selectedPersonaCuidada!,
                          );
                          try {
                            final userRef = FirebaseFirestore.instance
                                .collection('usuarios')
                                .doc(FirebaseAuth.instance.currentUser?.uid);
                            await userRef.update({
                              'activitats':
                                  FieldValue.arrayUnion([actividad.toJson()]),
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Actividad registrada correctamente'),
                              ),
                            );
                            _titolController.clear();
                            _descripcioController.clear();
                            _horesController.clear();
                            _dataController.clear();
                            setState(() {
                              selectedPersonaCuidada = null;
                              selectedTipusActivitat = null;
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LlistaActivitats(),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Error al registrar la actividad'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32.0, vertical: 12.0),
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}