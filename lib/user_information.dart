import 'package:flutter/material.dart';
import 'package:nestcure/logged_user.dart';
import 'package:nestcure/persona_dependent.dart';
import 'package:nestcure/edit_profile.dart';
import 'package:nestcure/app_bar.dart';
import 'package:nestcure/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    loggedUser.loginWithFirebase().then((_) {
      setState(() {});
    });
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
          final birthDate = (user.dataNaixement is Timestamp)
              ? (user.dataNaixement as Timestamp).toDate()
              : user.dataNaixement;

          String formattedBirthDate = '${birthDate.day.toString().padLeft(2, '0')}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.year.toString()}';
          
          String avatarImage = user.genero == "Mujer"
              ? 'images/avatar_chica.png'
              : 'images/avatar_chico.png';

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información personal',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.asset(
                          avatarImage,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  _buildInfoTile(
                    context,
                    title: 'Nombre y Apellidos',
                    subtitle: user.nomCognoms,
                  ),
                  _buildInfoTile(
                    context,
                    title: 'Fecha de nacimiento',
                    subtitle: formattedBirthDate,
                  ),
                  _buildInfoTile(
                    context,
                    title: 'Correo electrónico',
                    subtitle: user.correu,
                  ),
                  _buildInfoTile(
                    context,
                    title: 'Descripción',
                    subtitle: user.descripcio.isNotEmpty ? user.descripcio : 'Sin descripción',
                  ),
                  _buildInfoTile(
                    context,
                    title: 'Tipo de cuidador',
                    subtitle: user.esCuidadorPersonal
                        ? 'Cuidador Personal'
                        : 'Cuidador Profesional',
                  ),
                  _buildInfoTile(
                    context,
                    title: 'Teléfono',
                    subtitle: user.telefono.isNotEmpty ? user.telefono : 'No disponible',
                  ),
                  _buildInfoTile(
                    context,
                    title: 'Dirección',
                    subtitle: user.direccion.isNotEmpty ? user.direccion : 'No disponible',
                  ),
                  _buildInfoTile(
                    context,
                    title: 'Género',
                    subtitle: user.genero.isNotEmpty ? user.genero : 'No especificado',
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                    title: const Text(
                      'Personas a cargo',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PersonesDependentsWidget(),
                        ),
                      );
                    },
                  ),
                  const Divider(thickness: 1, height: 24.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(user: user),
                          ),
                        );
                        if (result == true) {
                          setState(() {});
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 14.0),
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        elevation: 5,
                        shadowColor: Colors.grey.withOpacity(0.5),
                      ),
                      child: const Text(
                        'Editar perfil',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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

  Widget _buildInfoTile(BuildContext context,
      {required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4.0),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const Divider(thickness: 1, height: 24.0),
      ],
    );
  }
}