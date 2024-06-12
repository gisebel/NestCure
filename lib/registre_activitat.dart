import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nestcure/activitat.dart';
import 'package:nestcure/app_bar.dart';
import 'package:nestcure/logged_user.dart';
import 'package:nestcure/user_provider.dart';
//import 'package:nestcure/usuari.dart';
import 'package:provider/provider.dart';

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
    'Higiene de la llar',
    'Suport emocional',
    'Rehabilitació',
    'Compra',
    'Gestió',
    'Activitat diària',
    'Altres',
  ];

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
    //var user = usuariHardcodeado;

    List<String> personesCuidades = [];

    for (var persona in user.personesDependents) {
      personesCuidades.add(persona.nom);
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
                  'Registra l\'activitat',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30.0),
                TextField(
                  controller: _titolController,
                  decoration: const InputDecoration(
                    labelText: 'Títol',
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
                          labelText: 'Data',
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
                          labelText: 'Hores',
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
                    labelText: 'Tipus d\'activitat',
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
                    labelText: 'Detalls de l\'activitat',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
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
                          side:
                              const BorderSide(color: Colors.white, width: 2.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 5,
                          backgroundColor:
                              const Color.fromRGBO(255, 102, 102, 1),
                        ),
                        child: const Text('Enrere',
                            style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (selectedPersonaCuidada == null ||
                              _selectedDate == null ||
                              selectedTipusActivitat == null ||
                              _titolController.text.isEmpty ||
                              _horesController.text.isEmpty ||
                              _descripcioController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Omple tots els camps'),
                              ),
                            );
                            return;
                          }
                          if (int.tryParse(_horesController.text) == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Les hores han de ser un número'),
                              ),
                            );
                            return;
                          }
                          user.activitats[selectedPersonaCuidada]!.add(
                            Activitat(
                              title: _titolController.text,
                              description: _descripcioController.text,
                              hours: int.parse(_horesController.text),
                              date: _selectedDate!,
                              type: selectedTipusActivitat!,
                            ),
                          );
                          provider.setUsuari(user);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          side:
                              const BorderSide(color: Colors.white, width: 2.0),
                          backgroundColor:
                              const Color.fromRGBO(180, 205, 96, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 5,
                        ),
                        child: const Text('Crear',
                            style: TextStyle(color: Colors.white)),
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

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => UserProvider(),
      ),
    ],
    child: MaterialApp(
      title: 'NestCure',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(45, 88, 133, 1),
          background: const Color.fromARGB(255, 255, 251, 245),
        ),
        textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 17),
            titleMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const RegistreActivitatPage(),
    ),
  ));
}
