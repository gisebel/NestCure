import 'package:flutter/material.dart';
import 'package:nestcure/activitat.dart';
import 'package:nestcure/app_bar.dart';
import 'package:nestcure/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LlistaActivitatsDetall extends StatefulWidget {
  final List<Activitat> activitats;
  final String nom;
  const LlistaActivitatsDetall(
      {super.key, required this.activitats, required this.nom});

  @override
  State<LlistaActivitatsDetall> createState() => _LlistaActivitatsDetallState();
}

class _LlistaActivitatsDetallState extends State<LlistaActivitatsDetall> {
  // Lista de actividades cargadas desde Firestore
  List<Activitat> _activitats = [];

  @override
  void initState() {
    super.initState();
    _loadActivitats(); // Cargar actividades al iniciar
  }

  // Método para cargar actividades desde Firestore
  void _loadActivitats() async {
    try {
      // Recuperamos las actividades desde la colección Firestore
      final activitiesSnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('activitats', isNotEqualTo: null)
          .get();

      final List<Activitat> loadedActivitats = [];

      // Filtrar las actividades por el nombre del dependiente
      for (var doc in activitiesSnapshot.docs) {
        final activitatsData = doc.data()['activitats'] ?? [];

        for (var activitatData in activitatsData) {
          if (activitatData['dependantName'] == widget.nom) {
            loadedActivitats.add(Activitat.fromMap(activitatData));
          }
        }
      }

      setState(() {
        _activitats = loadedActivitats;
      });
    } catch (e) {
      print("Error al cargar actividades desde Firestore: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar actividades.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actividades registradas de ${widget.nom}',
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            _activitats.isEmpty
                ? const Text(
                    'No hay actividades registradas.',
                    style: TextStyle(fontSize: 15.0),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: _activitats.length,
                      itemBuilder: (context, index) {
                        var activitat = _activitats[index];
                        return ActivityCard(
                          activitat: activitat,
                          onDelete: () {
                            setState(() {
                              _activitats.removeAt(index);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Actividad eliminada')),
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
  }
}

class ActivityCard extends StatelessWidget {
  final Activitat activitat;
  final VoidCallback onDelete;
  ActivityCard({super.key, required this.activitat, required this.onDelete});

  final Map<String, IconData> activityIcons = {
    'Higiene personal': Icons.clean_hands,
    'Higiene del hogar': Icons.cleaning_services,
    'Soporte emocional': Icons.emoji_emotions,
    'Rehabilitación': Icons.assist_walker,
    'Compra': Icons.shopping_cart,
    'Gestión': Icons.article,
    'Actividad diaria': Icons.accessibility_new,
    'Otros': Icons.miscellaneous_services,
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(activityIcons[activitat.type]),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              activitat.title,
                              style: const TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                          '${activitat.date.day}-${activitat.date.month}-${activitat.date.year}'),
                    ],
                  ),
                ),
                Text(
                  '${activitat.hours} h',
                  style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(45, 88, 133, 1)),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const Text('Tipo: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(activitat.type),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Descripción: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                    child: Text(
                  activitat.description,
                  overflow: TextOverflow.visible,
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}