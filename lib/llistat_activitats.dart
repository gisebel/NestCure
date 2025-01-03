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
  const LlistaActivitats({Key? key}) : super(key: key);

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
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 16.0),
                Expanded(
                  child: StreamBuilder<Map<String, List<Activitat>>>(
                    stream: _getActivitiesStream(user),
                    builder: (context, snapshot) {
                      // Estado de carga
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // Error
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      // No datos
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No hay actividades registradas.'));
                      }

                      return _buildActivityList(snapshot.data!);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Actividades registradas',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.add_circle_outline_rounded, size: 30.0),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RegistreActivitatPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActivityList(Map<String, List<Activitat>> activitiesMap) {
    return ListView.builder(
      itemCount: user.usuari.personesDependents.length,
      itemBuilder: (context, index) {
        final dependent = user.usuari.personesDependents[index];
        final activities = activitiesMap[dependent.nombre] ?? [];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: const Icon(Icons.person, color: Colors.black54),
            ),
            title: Text(
              dependent.nombre,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Tiene ${activities.length} actividades',
              style: TextStyle(color: Colors.grey[700]),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 20.0),
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
          ),
        );
      },
    );
  }

  Stream<Map<String, List<Activitat>>> _getActivitiesStream(LoggedUsuari user) {
    return FirebaseFirestore.instance
        .collection('usuarios')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .map((snapshot) {
      final Map<String, List<Activitat>> activitiesMap = {};

      if (snapshot.exists) {
        final activitatsData = snapshot.data()?['activitats'] ?? [];
        for (var activitatData in activitatsData) {
          final dependantName = activitatData['dependantName'] ?? '';
          if (dependantName.isNotEmpty) {
            final activity = Activitat.fromMap(activitatData);
            activitiesMap.putIfAbsent(dependantName, () => []).add(activity);
          }
        }
      }

      return activitiesMap;
    });
  }
}