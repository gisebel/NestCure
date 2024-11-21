import 'package:flutter/material.dart';
import 'package:nestcure/app_bar.dart';
import 'package:nestcure/llista_activitats_detall.dart';
import 'package:nestcure/logged_user.dart';
import 'package:nestcure/registre_activitat.dart';
import 'package:nestcure/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nestcure/activitat.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LlistaActivitats extends StatefulWidget {
  const LlistaActivitats({super.key});

  @override
  State<LlistaActivitats> createState() => _LlistaActivitatsState();
}

class _LlistaActivitatsState extends State<LlistaActivitats> {
  late LoggedUsuari user;

  @override
  void initState() {
    super.initState();
    user = LoggedUsuari();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, false),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Actividades registradas',
                        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline_rounded),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return const RegistreActivitatPage();
                            }),
                          );
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: FutureBuilder(
                      // Realizamos una consulta para obtener las actividades de Firestore
                      future: _getActivities(user),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No hay actividades registradas.'));
                        }

                        var dependentsActivities = snapshot.data as Map<String, List<Activitat>>;
                        return ListView.builder(
                          itemCount: user.usuari.personesDependents.length,
                          itemBuilder: (context, index) {
                            var dependent = user.usuari.personesDependents[index];
                            var activities = dependentsActivities[dependent.nombre] ?? [];

                            return ListTile(
                              title: Text(dependent.nombre),
                              subtitle: Text('Tiene ${activities.length} actividades'),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return LlistaActivitatsDetall(
                                      activitats: activities,
                                      nom: dependent.nombre,
                                    );
                                  }),
                                );
                              },
                            );
                          },
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

  // Función para obtener las actividades de Firestore
  Future<Map<String, List<Activitat>>> _getActivities(LoggedUsuari user) async {
    final Map<String, List<Activitat>> activitiesMap = {};

    // Obtenemos las actividades de Firestore
    try {
      for (var dependent in user.usuari.personesDependents) {
        final activitiesSnapshot = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('activitats')
            .doc(dependent.nombre) // Usamos el nombre del dependiente como clave
            .get();

        if (activitiesSnapshot.exists) {
          List<Activitat> activities = [];
          var activitiesData = activitiesSnapshot.data()?['activitats'] ?? {};
          activitiesData.forEach((key, value) {
            activities.add(Activitat.fromMap(value));
          });

          activitiesMap[dependent.nombre] = activities;
        } else {
          activitiesMap[dependent.nombre] = [];
        }
      }
    } catch (e) {
      print("Error fetching activities: $e");
    }
    return activitiesMap;
  }
}