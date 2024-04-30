import 'package:flutter/material.dart';
import 'package:nestcure/app_bar.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      drawer: const NavigationDrawerWidget(),
    );
  }
}
