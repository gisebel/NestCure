import 'package:flutter/material.dart';
import 'package:nestcure/nav_drawer.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
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
              icon: const Icon(Icons.person,
                  color: Color.fromRGBO(20, 39, 53, 1)),
              onPressed: () {},
            ),
          ),
        ],
        centerTitle: true,
      ),
      drawer: const NavigationDrawerWidget(),
    );
  }
}
