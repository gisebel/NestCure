import 'package:flutter/material.dart';
import 'package:nestcure/activitat.dart';
import 'package:nestcure/app_bar.dart';
import 'package:nestcure/user_provider.dart';
import 'package:provider/provider.dart';

class LlistaActivitatsDetall extends StatefulWidget {
  final List<Activitat> activitats;
  final String nom;
  const LlistaActivitatsDetall(
      {super.key, required this.activitats, required this.nom});

  @override
  State<LlistaActivitatsDetall> createState() => _LlistaActivitatsDetallState();
}

class _LlistaActivitatsDetallState extends State<LlistaActivitatsDetall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, true),
      body: Consumer<UserProvider>(builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Activitats registrades de ${widget.nom}',
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              widget.activitats.isEmpty
                  ? const Text(
                      'No hi ha activitats registrades.',
                      style: TextStyle(fontSize: 15.0),
                    )
                  : Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.activitats.length,
                        itemBuilder: (context, index) {
                          var activitat = widget.activitats[index];
                          return ActivityCard(
                            activitat: activitat,
                          );
                        },
                      ),
                    ),
            ],
          ),
        );
      }),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final Activitat activitat;
  ActivityCard({super.key, required this.activitat});

  final Map<String, IconData> activityIcons = {
    'Higiene personal': Icons.clean_hands,
    'Higiene de la llar': Icons.cleaning_services,
    'Suport emocional': Icons.emoji_emotions,
    'Rehabilitació': Icons.assist_walker,
    'Compra': Icons.shopping_cart,
    'Gestió': Icons.article,
    'Activitat diària': Icons.accessibility_new,
    'Altres': Icons.more_horiz,
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
                          '${activitat.date.day.toString()}-${activitat.date.month.toString()}-${activitat.date.year.toString()}'),
                    ],
                  ),
                ),
                Text(
                  '${activitat.hours.toString()} h',
                  style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(45, 88, 133, 1)),
                ),
                const SizedBox(width: 8.0)
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const Text('Tipus: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(activitat.type),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Descripció: ',
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
