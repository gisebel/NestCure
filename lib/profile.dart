import 'package:flutter/material.dart';
import 'package:nestcure/app_bar.dart';
import 'package:nestcure/list_certificates.dart';
import 'package:nestcure/llistat_activitats.dart';
import 'package:nestcure/logged_user.dart';
import 'package:nestcure/user_information.dart';
import 'package:nestcure/login.dart';
import 'package:nestcure/cv_generator.dart';

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
      name: "Notificaciones",
      icon: const Icon(
        Icons.notifications,
        color: Color.fromRGBO(45, 87, 133, 1),
        size: 28,
      ),
      page: const Scaffold(),
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
      name: "Tareas y horas dedicadas",
      icon: const Icon(
        Icons.volunteer_activism,
        color: Color.fromRGBO(45, 88, 133, 1),
        size: 28,
      ),
      page: const Scaffold(),
    ),
    ProfileItem(
      name: "Resgistro de actividades",
      icon: const Icon(
        Icons.content_paste_search,
        color: Color.fromRGBO(45, 88, 133, 1),
        size: 28,
      ),
      page: const LlistaActivitats(),
    ),
    ProfileItem(
      name: "Genera CV",
      icon: const Icon(
        Icons.create,
        color: Color.fromRGBO(45, 88, 133, 1),
        size: 28,
      ),
      page: const CvGenerator(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var loggedUser = LoggedUsuari();
    var user = loggedUser.usuari;

    return Scaffold(
      appBar: customAppBar(context, false),
      drawer: const NavigationDrawerWidget(),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            ClipOval(
              child: Container(
                width: 150,
                height: 150,
                color: Colors.transparent,
                child: Image.asset('images/avatar.png'),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              user.nomCognoms,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 8.0,
            ),
            const Divider(),
            Expanded(
              child: ListView.separated(
                itemCount: profileItems.length + 2,
                itemBuilder: (BuildContext context, int index) {
                  if (index == profileItems.length) {
                    return ListTile(
                      contentPadding: const EdgeInsets.only(left: 30),
                      title: const Text("Cerrar sesión"),
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.blueGrey,
                      ),
                      onTap: () => _logout(context),
                    );
                  } else if (index == profileItems.length + 1) {
                    return ListTile(
                      contentPadding: const EdgeInsets.only(left: 30),
                      title: const Text(
                        "Eliminar cuenta",
                        style: TextStyle(color: Colors.red),
                      ),
                      leading: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onTap: () => _confirmDeleteAccount(context),
                    );
                  }

                  return ListTile(
                    contentPadding: const EdgeInsets.only(left: 30),
                    title: Text(profileItems[index].name),
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
            ),
          ],
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

  void _logout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Cierre de sesión exitoso"),
      ),
    );
  }

  void _deleteAccount(BuildContext context) {
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
}
