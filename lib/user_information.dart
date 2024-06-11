import 'package:flutter/material.dart';
import 'package:nestcure/app_bar.dart';
import 'package:nestcure/logged_user.dart';
import 'package:nestcure/persona_dependent.dart';
import 'package:nestcure/user_provider.dart';
import 'package:provider/provider.dart';

class UserInformationWidget extends StatefulWidget {
  const UserInformationWidget({super.key});

  @override
  State<UserInformationWidget> createState() => _UserInformationWidgetState();
}

class _UserInformationWidgetState extends State<UserInformationWidget> {
  @override
  Widget build(BuildContext context) {
    var loggedUser = LoggedUsuari();
    var user = loggedUser.usuari;

    return Scaffold(
      appBar: customAppBar(context, true),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informació personal',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListTile(
                  title: const Text('Foto de perfil'),
                  trailing: Image.asset(
                    user.fotoPerfil,
                    fit: BoxFit.cover,
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Nom i cognoms'),
                  subtitle: Text(user.nomCognoms),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Data de naixement'),
                  subtitle: Text(user.dataNaixement.toString()),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Correu'),
                  subtitle: Text(user.correu),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Descripció'),
                  subtitle: Text(user.descripcio),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Tipus de cuidadora'),
                  subtitle: user.esCuidadorPersonal
                      ? const Text('Cuidadora Personal')
                      : const Text('Cuidadora Professional'),
                ),
                const Divider(),
                ListTile(
                    title: const Text('Persones al càrrec'),
                    subtitle: Text(
                        '${user.personesDependents.length} persones al càrrec'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return const PersonesDependentsWidget();
                        }),
                      );
                    }),
                const Divider()
              ],
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => UserProvider(),
      ),
    ],
    child: MaterialApp(
      title: 'NestCure',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 251, 245),
          background: const Color.fromARGB(255, 255, 251, 245),
        ),
        textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 17),
            titleMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: UserInformationWidget(),
    ),
  ));
}
