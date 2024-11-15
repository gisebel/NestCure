import 'package:flutter/material.dart';
import 'package:nestcure/logged_user.dart';
import 'package:nestcure/persona_dependent.dart';
import 'package:nestcure/edit_profile.dart';
import 'package:nestcure/app_bar.dart';
import 'package:nestcure/user.dart';

class UserInformationWidget extends StatefulWidget {
  const UserInformationWidget({super.key});

  @override
  State<UserInformationWidget> createState() => _UserInformationWidgetState();
}

class _UserInformationWidgetState extends State<UserInformationWidget> {
  final LoggedUsuari loggedUser = LoggedUsuari();

  @override
  void initState() {
    super.initState();
    loggedUser.loginWithFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, false),
      body: StreamBuilder<Usuari>(
        stream: loggedUser.userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los datos.'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No hay datos disponibles.'));
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Información personal',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ListTile(
                    title: const Text('Foto de perfil'),
                    trailing: user.fotoPerfil.isNotEmpty
                        ? Image.network(
                            user.fotoPerfil,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.person, size: 50);
                            },
                          )
                        : const Icon(Icons.person, size: 50),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Nombre y Apellidos'),
                    subtitle: Text(user.nomCognoms),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Fecha de nacimiento'),
                    subtitle: Text(
                        '${user.dataNaixement.day.toString().padLeft(2, '0')}-${user.dataNaixement.month.toString().padLeft(2, '0')}-${user.dataNaixement.year.toString()}'),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Correo electrónico'),
                    subtitle: Text(user.correu),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Descripción'),
                    subtitle: Text(user.descripcio.isNotEmpty ? user.descripcio : 'Sin descripción'),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Tipo de cuidador'),
                    subtitle: user.esCuidadorPersonal
                        ? const Text('Cuidador Personal')
                        : const Text('Cuidador Profesional'),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Personas a cargo'),
                    subtitle: Text('${user.personesDependents.length} personas a cargo'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return const PersonesDependentsWidget();
                        }),
                      );
                    },
                  ),
                  const Divider(),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return EditProfileScreen(user: user);
                          }),
                        );
                        if (result == true) {
                          setState(() {});
                        }
                      },
                      child: const Text('Editar'),
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