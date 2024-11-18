import 'package:flutter/material.dart';
import 'package:nestcure/app_bar.dart';
import 'package:nestcure/add_persona_dependent.dart';

class PersonesCuidadesPage extends StatelessWidget {
  final List<Map<String, dynamic>> users = [
    {
      'firstName': 'Joan',
      'lastName': 'López',
      'gender': 'male',
      'dob': '1990-01-01',
      'additionalInfo': 'Loves reading and hiking.'
    },
    {
      'firstName': 'Ariadna',
      'lastName': 'Morales',
      'gender': 'female',
      'dob': '1985-05-15',
      'additionalInfo': 'Enjoys painting and cooking.'
    },
    {
      'firstName': 'Berta',
      'lastName': 'Jimenez',
      'gender': 'female',
      'dob': '1992-11-23',
      'additionalInfo': 'Plays the piano and guitar.'
    },
    {
      'firstName': 'Sebastián',
      'lastName': 'García',
      'gender': 'male',
      'dob': '1988-07-30',
      'additionalInfo': 'Is a marathon runner and a chef.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40.0),
            const Text(
              'Personas cuidadas',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Icon(
                        user['gender'] == 'male' ? Icons.man : Icons.woman,
                        color: Colors.blue,
                      ),
                      title: Text('${user['firstName']} ${user['lastName']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Fecha de nacimiento: ${user['dob']}'),
                          const SizedBox(height: 4),
                          Text('Información adicional: ${user['additionalInfo']}'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddPersonaDependentWidget(),
            ),
          );
        },
        backgroundColor: const Color.fromRGBO(180, 205, 96, 1),
        child: const Icon(Icons.add),
      ),
    );
  }
}