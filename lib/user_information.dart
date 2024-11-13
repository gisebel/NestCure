import 'package:flutter/material.dart';
import 'package:nestcure/logged_user.dart';
import 'package:nestcure/persona_dependent.dart';
import 'package:nestcure/user_provider.dart';
import 'package:nestcure/edit_profile.dart';
import 'package:provider/provider.dart';

class UserInformationWidget extends StatefulWidget {
  const UserInformationWidget({super.key});

  @override
  State<UserInformationWidget> createState() => _UserInformationWidgetState();
}

class _UserInformationWidgetState extends State<UserInformationWidget> {
  @override
  Widget build(BuildContext context) {
    var loggedUser = LoggedUsuari();
    var user = loggedUser.usuari;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Información personal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return EditProfileScreen(user: user);
                }),
              );
            },
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
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
                ListTile(
                  title: const Text('Foto de perfil'),
                  trailing: Image.asset(
                    user.fotoPerfil,
                    fit: BoxFit.cover,
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Nombre y apellidos'),
                  subtitle: Text(user.nomCognoms),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Fecha de nacimiento'),
                  subtitle: Text(
                      '${user.dataNaixement.day.toString()}-${user.dataNaixement.month.toString()}-${user.dataNaixement.year.toString()}'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Correo'),
                  subtitle: Text(user.correu),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Descripción'),
                  subtitle: Text(user.descripcio),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Tipo de cuidadora'),
                  subtitle: user.esCuidadorPersonal
                      ? const Text('Cuidadora Personal')
                      : const Text('Cuidadora Professional'),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Personas a cargo'),
                  subtitle:
                      Text('${user.personesDependents.length} personas a cargo'),
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
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return EditProfileScreen(user: user);
                        }),
                      );
                    },
                    child: const Text('Editar'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}