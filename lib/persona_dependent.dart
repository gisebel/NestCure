import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nestcure/add_persona_dependent.dart';
import 'package:nestcure/app_bar.dart';
import 'package:nestcure/logged_user.dart';
import 'package:nestcure/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PersonaDependent {
  final String id;
  final String nombre;
  final String genero;
  final DateTime fechaNacimiento;
  final int edad;
  final String telefono;
  final String direccion;
  final double peso;
  final double altura;
  final String descripcion;

  PersonaDependent({
    required this.id,
    required this.nombre,
    required this.genero,
    required this.fechaNacimiento,
    required this.edad,
    required this.telefono,
    required this.direccion,
    required this.peso,
    required this.altura,
    required this.descripcion,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'genero': genero,
      'fechaNacimiento': fechaNacimiento.toIso8601String(),
      'edad': edad,
      'telefono': telefono,
      'direccion': direccion,
      'peso': peso,
      'altura': altura,
      'descripcion': descripcion,
    };
  }

  factory PersonaDependent.fromMap(Map<String, dynamic> data) {
    return PersonaDependent(
      id: data['id'] ?? '',
      nombre: data['nombre'] ?? '',
      direccion: data['direccion'] ?? '',
      genero: data['genero'] ?? '',
      descripcion: data['descripcion'] ?? '',
      edad: data['edad'] ?? 0,
      peso: (data['peso'] ?? 0).toDouble(),
      altura: (data['altura'] ?? 0).toDouble(),
      telefono: data['telefono']?.toString() ?? '',
      fechaNacimiento: data['fechaNacimiento'] is Timestamp
          ? (data['fechaNacimiento'] as Timestamp).toDate()
          : DateTime.parse(data['fechaNacimiento']),
    );
  }
}

class PersonesDependentsWidget extends StatefulWidget {
  const PersonesDependentsWidget({super.key});

  @override
  State<PersonesDependentsWidget> createState() =>
      _PersonesDependentsWidgetState();
}

class _PersonesDependentsWidgetState extends State<PersonesDependentsWidget> {
  List<PersonaDependent> _personesDependents = [];

  @override
  void initState() {
    super.initState();
    _loadPersonasDependientes();
  }

  void _loadPersonasDependientes() async {
    final userDoc = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(FirebaseAuth.instance.currentUser?.uid);

    try {
      final docSnapshot = await userDoc.get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data['personesDependents'] != null) {
          final personesDependentsData = data['personesDependents'];

          // Check if 'personesDependents' is an array (list)
          if (personesDependentsData is List) {
            // Convert the List to a List of PersonaDependent objects
            List<PersonaDependent> loadedPersones = [];
            
            // Loop through each entry in the list
            for (var item in personesDependentsData) {
              if (item is Map<String, dynamic>) {
                // Convert each map entry into a PersonaDependent object
                loadedPersones.add(PersonaDependent.fromMap(item));
              }
            }
            setState(() {
              _personesDependents = loadedPersones;
            });
          } else {
            print("El campo 'personesDependents' no es una lista válida.");
          }
        } else {
          print("El campo 'personesDependents' no está definido en Firestore.");
        }
      } else {
        print("No se encontró el documento del usuario.");
      }
    } catch (e) {
      print("Error al cargar personas dependientes desde Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = LoggedUsuari().usuari;

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
                        'Personas a cargo',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.person_add),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return const AddPersonaDependentWidget();
                            }),
                          );
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _personesDependents.length,
                      itemBuilder: (context, index) {
                        var persona = _personesDependents[index];
                        var date = DateFormat('dd-MM-yyyy').format(persona.fechaNacimiento);

                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Icon(
                              persona.genero == 'Mujer'
                                  ? Icons.woman
                                  : persona.genero == 'Hombre'
                                      ? Icons.man
                                      : Icons.person,
                              color: const Color.fromRGBO(45, 88, 133, 1),
                            ),
                            title: Text(persona.nombre,
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Fecha de nacimiento: $date'),
                                const SizedBox(height: 4.0),
                                Text('Edad: ${persona.edad} años'),
                                const SizedBox(height: 4.0),
                                Text('Teléfono: ${persona.telefono}'),
                                const SizedBox(height: 4.0),
                                Text('Dirección: ${persona.direccion}'),
                                const SizedBox(height: 4.0),
                                Text('Peso: ${persona.peso.toStringAsFixed(1)} kg'),
                                const SizedBox(height: 4.0),
                                Text('Altura: ${persona.altura.toStringAsFixed(2)} m'),
                                const SizedBox(height: 4.0),
                                Text('Descripción: ${persona.descripcion}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final personaToRemove = _personesDependents[index];

                                print('Eliminando persona: ${personaToRemove.toJson()}');

                                setState(() {
                                  _personesDependents.removeAt(index);
                                });

                                try {
                                  final userDoc = FirebaseFirestore.instance
                                      .collection('usuarios')
                                      .doc(FirebaseAuth.instance.currentUser?.uid);

                                  await userDoc.update({
                                    'personesDependents': FieldValue.arrayRemove([personaToRemove.toJson()])
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Persona eliminada correctamente.')),
                                  );
                                } catch (e) {
                                  setState(() {
                                    _personesDependents.insert(index, personaToRemove);
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Error al eliminar persona.')),
                                  );
                                  print('Error al eliminar persona de Firestore: $e');
                                }
                              },
                            ),
                          ),
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
}