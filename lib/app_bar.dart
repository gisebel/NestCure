import 'package:flutter/material.dart';
import 'package:nestcure/main.dart';
import 'package:nestcure/profile.dart';
import 'package:nestcure/validate_certificate.dart';
import 'package:nestcure/list_certificates.dart';

AppBar customAppBar(BuildContext context, bool canReturnBack) {
  return AppBar(
    backgroundColor: const Color.fromARGB(255, 255, 251, 245),
    leading: canReturnBack
        ? IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        : null,
    title: SizedBox(
      height: AppBar().preferredSize.height,
      child: Image.asset(
        'images/logo.jpg',
        fit: BoxFit.cover,
      ),
    ),
    actions: [
      Container(
        margin: const EdgeInsets.only(right: 16.0),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromRGBO(194, 198, 203, 1),
        ),
        child: IconButton(
          icon: const Icon(Icons.person, color: Color.fromRGBO(20, 39, 53, 1)),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) {
                  return ProfileWidget();
                },
              ),
            );
          },
        ),
      ),
    ],
    centerTitle: true,
  );
}

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItems(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 68, 24, 24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) {
                    return const MyHomePage();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.pop(context);

              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return ProfileWidget();
                }),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Valida Certificat'),
            onTap: () {
              Navigator.pop(context);

              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return const ValidateCertificate();
                }),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Els Meus Certificats'),
            onTap: () {
              Navigator.pop(context);

              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return const ListCertificates();
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}