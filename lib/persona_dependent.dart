import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nestcure/add_persona_dependent.dart';
import 'package:nestcure/app_bar.dart';
import 'package:nestcure/logged_user.dart';
import 'package:nestcure/user_provider.dart';
import 'package:provider/provider.dart';

class PersonaDependent {
  final String nom;
  final String descripcio;
  final String depenDe;
  final String gender;
  final DateTime dataNaixement;

  PersonaDependent({
    required this.nom,
    required this.descripcio,
    required this.depenDe,
    required this.gender,
    required this.dataNaixement,
  });
}

class PersonesDependentsWidget extends StatefulWidget {
  const PersonesDependentsWidget({super.key});

  @override
  State<PersonesDependentsWidget> createState() =>
      _PersonesDependentsWidgetState();
}

class _PersonesDependentsWidgetState extends State<PersonesDependentsWidget> {
  @override
  Widget build(BuildContext context) {
    var user = LoggedUsuari().usuari;

    return Scaffold(
      appBar: customAppBar(context, false),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          return Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Persones al càrrec',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                          icon: const Icon(Icons.person_add),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return const AddPersonaDependentWidget();
                              }),
                            );
                          })
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: user.personesDependents.length,
                      itemBuilder: (context, index) {
                        var date = DateFormat('dd-MM-yyyy').format(
                            user.personesDependents[index].dataNaixement);
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Icon(
                                user.personesDependents[index].gender == 'Dona'
                                    ? Icons.woman
                                    : Icons.man,
                                color: const Color.fromRGBO(45, 88, 133, 1)),
                            title: Text(user.personesDependents[index].nom,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Data de naixement: $date'),
                                const SizedBox(height: 4.0),
                                Text(
                                    'Descripció: ${user.personesDependents[index].descripcio}'),
                              ],
                            ),
                          ),
                        );
                      },
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
