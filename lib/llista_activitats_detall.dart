import 'package:flutter/material.dart';
import 'package:nestcure/activitat.dart';
import 'package:nestcure/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LlistaActivitatsDetall extends StatefulWidget {
  final List<Activitat> activitats;
  final String nom;

  const LlistaActivitatsDetall({
    Key? key,
    required this.activitats,
    required this.nom,
  }) : super(key: key);

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

  Future<void> _loadActivitats() async {
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
        SnackBar(
          content: Text(
            'Error al cargar actividades.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
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
        var activitatsData =
            List<Map<String, dynamic>>.from(userDoc['activitats'] ?? []);
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
        SnackBar(
          content: Text(
            'Actividad eliminada exitosamente.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("Error al eliminar la actividad: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al eliminar la actividad.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _confirmDelete(Activitat activitat) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Confirmar eliminación",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text("¿Estás seguro de que quieres eliminar esta actividad?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              "Cancelar",
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteActivity(activitat);
            },
            child: Text(
              "Eliminar",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  int getTotalHours() {
    return _activitats.fold(0, (sum, activitat) => sum + activitat.hours);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actividades de ${widget.nom}',
              style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ),
            ),
            SizedBox(height: 10.0),
            _activitats.isEmpty
                ? Expanded(
                    child: Center(
                      child: Text(
                        'No hay actividades registradas.',
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                      ),
                    ),
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
            Card(
              color: Colors.teal[50],
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total de horas dedicadas:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.teal[800],
                      ),
                    ),
                    Text(
                      '${getTotalHours()} h',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[900],
                      ),
                    ),
                  ],
                ),
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

  ActivityCard({Key? key, required this.activitat, required this.onDelete})
      : super(key: key);

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
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal[100],
          child: Icon(
            activityIcons[activitat.type],
            color: Colors.teal[800],
          ),
        ),
        title: Text(
          activitat.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Horas: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${activitat.hours}',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Fecha: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${activitat.date.day}-${activitat.date.month}-${activitat.date.year}',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Descripción: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    '${activitat.description}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}