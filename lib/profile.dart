import 'package:flutter/material.dart';
import 'package:nestcure/app_bar.dart';
import 'package:nestcure/llistat_activitats.dart';
import 'package:nestcure/logged_user.dart';
import 'package:nestcure/user_information.dart';

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
      name: "Informació Personal",
      icon: const Icon(
        Icons.person,
        color: Color.fromRGBO(45, 87, 133, 1),
        size: 28,
      ),
      page: const UserInformationWidget(),
    ),
    ProfileItem(
      name: "Notificacions",
      icon: const Icon(
        Icons.notifications,
        color: Color.fromRGBO(45, 87, 133, 1),
        size: 28,
      ),
      page: const Scaffold(),
    ),
    ProfileItem(
      name: "Certificats",
      icon: const Icon(
        Icons.book,
        color: Color.fromRGBO(45, 87, 133, 1),
        size: 28,
      ),
      page: const Scaffold(),
    ),
    ProfileItem(
      name: "Tasques i hores dedicades",
      icon: const Icon(
        Icons.volunteer_activism,
        color: Color.fromRGBO(45, 88, 133, 1),
        size: 28,
      ),
      page: const Scaffold(),
    ),
    ProfileItem(
      name: "Resgistre d'activitats",
      icon: const Icon(
        Icons.content_paste_search,
        color: Color.fromRGBO(45, 88, 133, 1),
        size: 28,
      ),
      page: const LlistaActivitats(),
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
                itemCount: profileItems.length,
                itemBuilder: (BuildContext context, int index) {
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
}
