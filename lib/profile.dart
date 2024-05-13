import 'package:flutter/material.dart';
import 'package:nestcure/app_bar.dart';

class ProfileItem {
  final String name;
  final Icon icon;

  ProfileItem({
    required this.name,
    required this.icon,
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
    ),
    ProfileItem(
      name: "Notificacions",
      icon: const Icon(
        Icons.notifications,
        color: Color.fromRGBO(45, 87, 133, 1),
        size: 28,
      ),
    ),
    ProfileItem(
      name: "Certificats",
      icon: const Icon(
        Icons.book,
        color: Color.fromRGBO(45, 87, 133, 1),
        size: 28,
      ),
    ),
    ProfileItem(
      name: "Tasques i hores dedicades",
      icon: const Icon(
        Icons.volunteer_activism,
        color: Color.fromRGBO(45, 88, 133, 1),
        size: 28,
      ),
    ),
    ProfileItem(
      name: "Resgistre d'activitats",
      icon: const Icon(
        Icons.content_paste_search,
        color: Color.fromRGBO(45, 88, 133, 1),
        size: 28,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
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
                child: Image.asset('images/logo.jpg'),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              'NOM COGNOM',
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
                    onTap: () {},
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
