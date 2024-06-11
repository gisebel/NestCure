import 'package:flutter/material.dart';
import 'package:nestcure/addPersonaDependent.dart';
import 'package:nestcure/app_bar.dart';
import 'package:nestcure/logged_user.dart';
import 'package:nestcure/user_provider.dart';
import 'package:provider/provider.dart';

class PersonaDependent {
  final String nom;
  final String descripcio;
  final String depenDe;

  PersonaDependent({
    required this.nom,
    required this.descripcio,
    required this.depenDe,
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
                        return ListTile(
                          title: Text(user.personesDependents[index].nom),
                          subtitle:
                              Text(user.personesDependents[index].descripcio),
                          trailing: const Icon(Icons.arrow_forward_ios),
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
