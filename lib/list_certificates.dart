import 'package:flutter/material.dart';
import 'package:nestcure/app_bar.dart';

class ListCertificates extends StatelessWidget {
  const ListCertificates({super.key});

  final List<Map<String, String>> certificates = const [
    {"name": "Certificat 1", "description": "Descripció del Certificat", "file": "Fitxer"},
    {"name": "Certificat 2", "description": "Descripció del Certificat", "file": "Fitxer"},
    {"name": "Certificat 3", "description": "Descripció del Certificat", "file": "Fitxer"},
    {"name": "Certificat 4", "description": "Descripció del Certificat", "file": "Fitxer"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      drawer: const NavigationDrawerWidget(),
      body: ListView.builder(
        itemCount: certificates.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            leading: const Icon(Icons.book),
            title: Text(certificates[index]["name"]!),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nom: ${certificates[index]["name"]}"),
                    Text("Descripció: ${certificates[index]["description"]}"),
                    Text("Fitxer: ${certificates[index]["file"]}"),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Enrere'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade200,
          ),
        ),
      ),
    );
  }
}
