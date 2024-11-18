import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nestcure/add_persona_dependent.dart';
import 'package:nestcure/app_bar.dart';
import 'package:nestcure/logged_user.dart';
import 'package:nestcure/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart'; // Importar Firebase Realtime Database

class PersonaDependent {
  final String nombre;
  final String dependeDe;
  final String genero;
  final DateTime fechaNacimiento;
  final int edad;
  final int telefono;
  final String direccion;
  final double peso;
  final double altura;
  final String descripcion;

  PersonaDependent({
    required this.nombre,
    required this.dependeDe,
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
      'nombre': nombre,
      'dependeDe': dependeDe,
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

  factory PersonaDependent.fromMap(Map<String, dynamic> map) {
    return PersonaDependent(
      nombre: map['nombre'] ?? '',
      dependeDe: map['dependeDe'] ?? '',
      genero: map['genero'] ?? '',
      fechaNacimiento: map['fechaNacimiento'] != null
          ? DateTime.parse(map['fechaNacimiento'])
          : DateTime.now(),
      edad: map['edad'] ?? 0,
      telefono: map['telefono'] ?? 0,
      direccion: map['direccion'] ?? '',
      peso: map['peso']?.toDouble() ?? 0.0,
      altura: map['altura']?.toDouble() ?? 0.0,
      descripcion: map['descripcion'] ?? '',
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

  // Método para cargar personas dependientes desde Firebase
  void _loadPersonasDependientes() {
    final DatabaseReference ref = FirebaseDatabase.instance.ref('personas_dependientes');

    // Escuchar cambios en tiempo real
    ref.onValue.listen((DatabaseEvent event) {
      final snapshot = event.snapshot;

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        List<PersonaDependent> loadedPersones = [];
        data.forEach((key, value) {
          loadedPersones.add(PersonaDependent.fromMap(Map<String, dynamic>.from(value)));
        });

        setState(() {
          _personesDependents = loadedPersones;
        });
      } else {
        print("No hay datos disponibles");
        setState(() {
          _personesDependents = []; // Si no hay datos, vaciar la lista
        });
      }
    });
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
                              onPressed: () {
                                setState(() {
                                  _personesDependents.removeAt(index);
                                  provider.setUsuari(user);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Persona eliminada correctamente.'),
                                  ),
                                );
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
