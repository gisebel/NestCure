import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nestcure/add_persona_dependent.dart';
import 'package:nestcure/app_bar.dart';
import 'package:nestcure/logged_user.dart';
import 'package:nestcure/user_provider.dart';
import 'package:provider/provider.dart';

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
}

class PersonesDependentsWidget extends StatefulWidget {
  const PersonesDependentsWidget({super.key});

  @override
  State<PersonesDependentsWidget> createState() =>
      _PersonesDependentsWidgetState();
}

class _PersonesDependentsWidgetState extends State<PersonesDependentsWidget> {
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
                      itemCount: user.personesDependents.length,
                      itemBuilder: (context, index) {
                        var persona = user.personesDependents[index];
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
                                  user.personesDependents.removeAt(index);
                                  user.activitats.remove(persona.nombre);
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
