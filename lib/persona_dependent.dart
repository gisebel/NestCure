import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nestcure/add_persona_dependent.dart';
import 'package:nestcure/app_bar.dart';
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

          if (personesDependentsData is List) {
            List<PersonaDependent> loadedPersones = [];
            
            for (var item in personesDependentsData) {
              if (item is Map<String, dynamic>) {
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

  void _confirmDelete(PersonaDependent persona, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Confirmar eliminación",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text("¿Estás seguro de que quieres eliminar a esta persona dependiente?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              "Cancelar",
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await _deletePersona(persona, index);
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

  Future<void> _deletePersona(PersonaDependent persona, int index) async {
    try {
      setState(() {
        _personesDependents.removeAt(index);
      });

      final userDoc = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(FirebaseAuth.instance.currentUser?.uid);

      await userDoc.update({
        'personesDependents': FieldValue.arrayRemove([persona.toJson()])
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Persona eliminada correctamente.')),
      );
    } catch (e) {
      setState(() {
        _personesDependents.insert(index, persona);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar persona.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, false),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Personas a cargo',
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return const AddPersonaDependentWidget();
                            }),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.person_add, color: Colors.white),
                            SizedBox(width: 8.0),
                            Text(
                              'Agregar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ListView.builder(
                  shrinkWrap: true,
                      itemCount: _personesDependents.length,
                      itemBuilder: (context, index) {
                        var persona = _personesDependents[index];
                        var date = DateFormat('dd-MM-yyyy').format(persona.fechaNacimiento);

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ListTile(
                            leading: Icon(
                              persona.genero == 'Mujer'
                                  ? Icons.woman
                                  : persona.genero == 'Hombre'
                                      ? Icons.man
                                      : Icons.person,
                              color: Color(0xFF6C8E3E),
                              size: 40.0,
                            ),
                            title: Text(
                              persona.nombre,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Fecha de nacimiento: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: Text('$date'),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Edad: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: Text('${persona.edad} años'),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Teléfono: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: Text('${persona.telefono}'),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Dirección: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: Text('${persona.direccion}'),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Peso: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: Text('${persona.peso.toStringAsFixed(1)} kg'),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Altura: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: Text('${persona.altura.toStringAsFixed(2)} m'),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Descripción: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: Text('${persona.descripcion}'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDelete(persona, index),
                            ),
                          ),
                        );
                      },
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
