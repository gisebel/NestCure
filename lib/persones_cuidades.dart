import 'package:flutter/material.dart';
import 'package:nestcure/app_bar.dart';

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
      appBar: AppBar(
        title: Text('Persones Cuidades'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(
                user['gender'] == 'male' ? Icons.man : Icons.woman,
                color: Colors.blue,
              ),
              title: Text('${user['firstName']} ${user['lastName']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Data de naixement: ${user['dob']}'),
                  SizedBox(height: 4),
                  Text('Informació adiccional: ${user['additionalInfo']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}