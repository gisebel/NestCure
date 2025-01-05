import 'package:flutter/material.dart';
import 'package:nestcure/app_bar.dart';
import 'package:nestcure/list_certificates.dart';
import 'package:nestcure/llistat_activitats.dart';
import 'package:nestcure/logged_user.dart';
import 'package:nestcure/persona_dependent.dart';
import 'package:nestcure/user_information.dart';
import 'package:nestcure/login.dart';
import 'package:nestcure/cv_generator.dart';
import 'package:nestcure/knowledge_tests.dart';
import 'package:nestcure/conectar_suara.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileItem {
  final String name;
  final Icon icon;
  final Widget page;

  ProfileItem({
    required this.name,
    required this.icon,
    required this.page,
  });
}

class ProfileWidget extends StatelessWidget {
  ProfileWidget({super.key});

  final List<ProfileItem> profileItems = [
    ProfileItem(
      name: "Información personal",
      icon: const Icon(
        Icons.person,
        color: Color.fromRGBO(45, 87, 133, 1),
        size: 28,
      ),
      page: const UserInformationWidget(),
    ),
    ProfileItem(
      name: "Personas a cargo",
      icon: const Icon(
        Icons.people,
        color: Color.fromRGBO(45, 88, 133, 1),
        size: 28,
      ),
      page: PersonesDependentsWidget(),
    ),
    ProfileItem(
      name: "Registro de actividades",
      icon: const Icon(
        Icons.content_paste_search,
        color: Color.fromRGBO(45, 88, 133, 1),
        size: 28,
      ),
      page: const LlistaActivitats(),
    ),
    ProfileItem(
      name: "Tests de conocimientos",
      icon: const Icon(
        Icons.assessment,
        color: Color.fromRGBO(45, 88, 133, 1),
        size: 28,
      ),
      page: const KnowledgeTestsScreen(),
    ),
    ProfileItem(
      name: "Certificados",
      icon: const Icon(
        Icons.book,
        color: Color.fromRGBO(45, 87, 133, 1),
        size: 28,
      ),
      page: const ListCertificates(),
    ),
    ProfileItem(
      name: "Generar currículum vitae",
      icon: const Icon(
        Icons.create,
        color: Color.fromRGBO(45, 88, 133, 1),
        size: 28,
      ),
      page: const CvGenerator(),
    ),
    ProfileItem(
      name: "Conectar con Suara",
      icon: const Icon(
        Icons.link,
        color: Color.fromRGBO(45, 88, 133, 1),
        size: 28,
      ),
      page: const ConnectWithSuaraPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var loggedUser = LoggedUsuari();
    var user = loggedUser.usuari;

    String avatarImage = user.genero == "Mujer" 
        ? 'images/avatar_chica.png' 
        : 'images/avatar_chico.png';

    return Scaffold(
      appBar: customAppBar(context, false),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              ClipOval(
                child: Container(
                  width: 150,
                  height: 150,
                  color: Colors.white,
                  child: Image.asset(avatarImage, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                user.nomCognoms,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromRGBO(45, 87, 133, 1),
                ),
              ),
              const SizedBox(height: 8.0),
              const Divider(thickness: 1),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: profileItems.length + 2,
                itemBuilder: (BuildContext context, int index) {
                  if (index == profileItems.length) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                      title: const Text(
                        "Eliminar cuenta",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      leading: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onTap: () => _confirmDeleteAccount(context),
                    );
                  }
                  if (index == profileItems.length + 1) {
                    return const Divider(thickness: 1);
                  }
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                    title: Text(
                      profileItems[index].name,
                      style: const TextStyle(fontSize: 16),
                    ),
                    leading: profileItems[index].icon,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return profileItems[index].page;
                        }),
                      );
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar eliminación"),
          content: const Text(
              "¿Estás seguro de que quieres eliminar tu cuenta? Esta acción no se puede deshacer."),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
              onPressed: () {
                _deleteAccount(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount(BuildContext context) async {
    var loggedUser = LoggedUsuari();
    var user = loggedUser.usuari;

    // Muestra un indicador de progreso mientras se procesa la eliminación.
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // 1. Eliminar los datos del usuario de Firestore
      await FirebaseFirestore.instance
          .collection('usuarios')
          .where('correu', isEqualTo: user.correu) // Buscamos por correo
          .get()
          .then((querySnapshot) async {
        // Verificamos si hay algún documento que coincida con el correo
        if (querySnapshot.docs.isNotEmpty) {
          // Aquí tomamos el primer documento que coincida (normalmente solo debe haber uno)
          await querySnapshot.docs.first.reference.delete();
        }
      });

      // 2. Eliminar la cuenta del usuario de Firebase Authentication
      await FirebaseAuth.instance.currentUser?.delete();

      // Si la eliminación es exitosa, redirige al usuario a la pantalla de login.
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cuenta eliminada exitosamente"),
          ),
        );
      }
    } catch (e) {
      print("Error al eliminar la cuenta: $e");

      // En caso de error, muestra un mensaje al usuario.
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error al eliminar la cuenta"),
          ),
        );
      }
    } finally {
      // Cierra el diálogo de carga.
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    }
  }
}
