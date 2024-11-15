import 'package:flutter/material.dart';
import 'package:nestcure/logged_user.dart';
import 'package:nestcure/persona_dependent.dart';
import 'package:nestcure/edit_profile.dart';
import 'package:nestcure/app_bar.dart';

class UserInformationWidget extends StatefulWidget {
  const UserInformationWidget({super.key});

  @override
  State<UserInformationWidget> createState() => _UserInformationWidgetState();
}

class _UserInformationWidgetState extends State<UserInformationWidget> {
  @override
  Widget build(BuildContext context) {
    var loggedUser = LoggedUsuari(); // Obtener instancia del usuario logueado
    var user = loggedUser.usuari; // Obtener datos del usuario

    return Scaffold(
      appBar: customAppBar(context, false),
      body: Padding(
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
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            const Divider(),
            ListTile(
              title: const Text('Correo electrónico'),
              subtitle: Text(user.correu),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            const Divider(),
            ListTile(
              title: const Text('Descripción'),
              subtitle: Text(user.descripcio.isNotEmpty ? user.descripcio : 'Sin descripción'),
              trailing: const Icon(Icons.arrow_forward_ios),
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
      ),
    );
  }
}
