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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nestcure/user.dart';

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

class ProfileWidget extends StatefulWidget {
  ProfileWidget({super.key});

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late final LoggedUsuari loggedUser;

  @override
  void initState() {
    super.initState();
    loggedUser = LoggedUsuari();
    loggedUser.loginWithFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Usuari>(
      stream: loggedUser.userStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: customAppBar(context, false),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data!;
        print("User: ${user.correu}");
        print("Genero: ${user.genero}");

        String avatarImage = '';
        if (user.genero == "Mujer") {
          avatarImage = 'images/avatar_chica.png';
        } else if (user.genero == "Hombre") {
          avatarImage = 'images/avatar_chico.png';
        }

        List<ProfileItem> profileItems = [
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
            page: CvGenerator(),
          ),
        ];

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
      },
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

    print ("User: ${user.correu}");
    print("Genero: ${user.genero}");

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
      await FirebaseFirestore.instance
          .collection('usuarios')
          .where('correu', isEqualTo: user.correu)
          .get()
          .then((querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          await querySnapshot.docs.first.reference.delete();
        }
      });

      await FirebaseAuth.instance.currentUser?.delete();

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
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error al eliminar la cuenta"),
          ),
        );
      }
    } finally {
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    }
  }
}