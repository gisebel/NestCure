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
import 'dart:async';

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
                    child: StreamBuilder(
                      // Escucha las actividades de cada dependiente
                      stream: _getActivitiesStream(user),
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

  // Función para obtener las actividades desde Firestore
  Stream<Map<String, List<Activitat>>> _getActivitiesStream(LoggedUsuari user) {
    final StreamController<Map<String, List<Activitat>>> controller = StreamController();
    
    // Inicializamos un mapa para almacenar las actividades por dependiente
    final Map<String, List<Activitat>> activitiesMap = {};

    // Verificamos que el usuario esté autenticado
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (currentUserId.isEmpty) {
      print('No user is authenticated');
      controller.close();
      return controller.stream;
    }

    // Escuchamos cambios en las actividades de los dependientes
    FirebaseFirestore.instance
      .collection('usuarios')
      .doc(currentUserId)
      .collection('activitats')
      .snapshots()
      .listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          print("Datos recibidos de Firestore: ${snapshot.docs.length} documentos");

          // Iteramos sobre los documentos de actividades y las asignamos a los dependientes
          for (var doc in snapshot.docs) {
            var activitiesData = doc.data()['activitats'] ?? [];
            for (var activityData in activitiesData) {
              String dependantName = activityData['dependantName'];
              if (dependantName.isNotEmpty) {
                // Creamos el objeto de actividad
                Activitat activity = Activitat.fromMap(activityData);

                // Agregamos la actividad al mapa correspondiente
                if (!activitiesMap.containsKey(dependantName)) {
                  activitiesMap[dependantName] = [];
                }
                activitiesMap[dependantName]?.add(activity);
              }
            }
          }
        } else {
          print("No hay actividades registradas.");
        }
        // Actualizamos el stream con el mapa de actividades
        controller.add(Map.from(activitiesMap));
      });

    return controller.stream;
  }
}