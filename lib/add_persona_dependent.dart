import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:nestcure/app_bar.dart';
import 'package:nestcure/logged_user.dart';
import 'package:nestcure/persona_dependent.dart';
import 'package:nestcure/user_provider.dart';
import 'package:provider/provider.dart';

class AddPersonaDependentWidget extends StatefulWidget {
  const AddPersonaDependentWidget({super.key});

  @override
  State<AddPersonaDependentWidget> createState() =>
      _AddPersonaDependentWidgetState();
}

class _AddPersonaDependentWidgetState extends State<AddPersonaDependentWidget> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _descripcioController = TextEditingController();
  final TextEditingController _dataNaixementController =
      TextEditingController();

  DateTime? _dataNaixement;
  String? _gender = 'Dona';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dataNaixement) {
      setState(() {
        _dataNaixement = picked;
        _dataNaixementController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = LoggedUsuari().usuari;

    return Scaffold(
      appBar: customAppBar(context, true),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40.0),
                  const Text(
                    'Persona amb dependència',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30.0),
                  TextField(
                    controller: _nomController,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                      border: OutlineInputBorder(),
                      hintText: 'Marta Lopez',
                      hintStyle: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: _dataNaixementController,
                    decoration: const InputDecoration(
                      labelText: 'Data Naixement',
                      border: OutlineInputBorder(),
                      hintText: '23-11-1947',
                      hintStyle: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.normal),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Gènere: ',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Radio<String>(
                              value: 'Dona',
                              groupValue: _gender,
                              onChanged: (String? value) {
                                setState(() {
                                  _gender = value!;
                                });
                              },
                            ),
                            const Text('Dona'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Radio<String>(
                              value: 'Home',
                              groupValue: _gender,
                              onChanged: (String? value) {
                                setState(() {
                                  _gender = value!;
                                });
                              },
                            ),
                            const Text('Home'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: _descripcioController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: 'Descripció',
                      hintText: 'Té dificultats per desplaçar-se.',
                      hintStyle: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.normal),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      onPressed: () {
                        if (_nomController.text.isEmpty ||
                            _descripcioController.text.isEmpty ||
                            _dataNaixement == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Omple tots els camps.'),
                            ),
                          );
                          return;
                        }
                        user.personesDependents.add(
                          PersonaDependent(
                            nom: _nomController.text,
                            descripcio: _descripcioController.text,
                            depenDe: user.nomCognoms,
                            dataNaixement: _dataNaixement!,
                            gender: _gender!,
                          ),
                        );
                        user.activitats[_nomController.text] = [];
                        provider.setUsuari(user);
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white, width: 2.0),
                        backgroundColor: const Color.fromRGBO(180, 205, 96, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 5,
                      ),
                      child: const Text('Afegir',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
