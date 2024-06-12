import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    var user = LoggedUsuari().usuari;

    String nom = '';
    String descripcio = '';

    return Scaffold(
      appBar: customAppBar(context, true),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: SingleChildScrollView(
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Persona amb dependència',
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Nom Cognoms',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      onChanged: (value) {
                        nom = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Marta Lopez',
                        hintStyle:
                            TextStyle(fontSize: 14.0, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Descripció',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    SingleChildScrollView(
                      child: TextField(
                        maxLines: null,
                        onChanged: (value) {
                          descripcio = value;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Té dificultats per desplaçar-se.',
                          hintStyle:
                              TextStyle(fontSize: 14.0, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton(
                        onPressed: () {
                          user.personesDependents.add(
                            PersonaDependent(
                              nom: nom,
                              descripcio: descripcio,
                              depenDe: user.correu,
                            ),
                          );
                          user.activitats[nom] = [];
                          provider.setUsuari(user);
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          side:
                              const BorderSide(color: Colors.white, width: 2.0),
                          backgroundColor:
                              const Color.fromRGBO(180, 205, 96, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 5,
                        ),
                        child: const Text('Afegir'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
