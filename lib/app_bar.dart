import 'package:flutter/material.dart';
import 'package:nestcure/login.dart';
import 'package:nestcure/profile.dart';

AppBar customAppBar(BuildContext context, bool canReturnBack) {
  return AppBar(
    backgroundColor: const Color.fromARGB(255, 255, 251, 245),
    leading: canReturnBack
        ? IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ProfileWidget()),
            );
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
          icon: const Icon(Icons.logout, color: Color.fromRGBO(20, 39, 53, 1)),
          onPressed: () => _logout(context),
        ),
      ),
    ],
    centerTitle: true,
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