import 'package:flutter/material.dart';
import 'package:nestcure/activitat.dart';
import 'package:nestcure/app_bar.dart';
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
  List<Activitat> _activitats = [];

  @override
  void initState() {
    super.initState();
    _loadActivitats();
  }

  void _loadActivitats() async {
    try {
      final activitiesSnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('activitats', isNotEqualTo: null)
          .get();

      final List<Activitat> loadedActivitats = [];

      for (var doc in activitiesSnapshot.docs) {
        final activitatsData = doc.data()['activitats'] ?? [];

        for (var activitatData in activitatsData) {
          if (activitatData['dependantName'] == widget.nom) {
            loadedActivitats.add(Activitat.fromMap(activitatData));
          }
        }
      }
      loadedActivitats.sort((a, b) => a.date.compareTo(b.date));
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

  Future<void> _deleteActivity(Activitat activitat) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('activitats', isNotEqualTo: null)
          .get();

      for (var userDoc in userSnapshot.docs) {
        var activitatsData = List<Map<String, dynamic>>.from(userDoc['activitats'] ?? []);
        activitatsData.removeWhere((element) => element['id'] == activitat.id);
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(userDoc.id)
            .update({'activitats': activitatsData});
        break;
      }
      setState(() {
        _activitats.removeWhere((a) => a.id == activitat.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Actividad eliminada exitosamente.')),
      );
    } catch (e) {
      print("Error al eliminar la actividad: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar la actividad.')),
      );
    }
  }

  void _confirmDelete(Activitat activitat) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirmar eliminación"),
        content: const Text("¿Estás seguro de que quieres eliminar esta actividad?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteActivity(activitat);
            },
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );
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
                          onDelete: () => _confirmDelete(activitat),
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
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  activityIcons[activitat.type],
                  color: const Color.fromRGBO(167, 207, 57, 1), // Color verde
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    activitat.title,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${activitat.hours} h',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(45, 88, 133, 1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${activitat.date.day}-${activitat.date.month}-${activitat.date.year}',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const Text(
                  'Tipo: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(activitat.type),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Descripción: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    activitat.description,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}