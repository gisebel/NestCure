import 'package:flutter/material.dart';
import 'package:nestcure/app_bar.dart';
import 'package:nestcure/llista_activitats_detall.dart';
import 'package:nestcure/logged_user.dart';
import 'package:nestcure/registre_activitat.dart';
import 'package:nestcure/user_provider.dart';
import 'package:nestcure/usuari.dart';
import 'package:provider/provider.dart';

class LlistaActivitats extends StatefulWidget {
  const LlistaActivitats({super.key});

  @override
  State<LlistaActivitats> createState() => _LlistaActivitatsState();
}

class _LlistaActivitatsState extends State<LlistaActivitats> {
  @override
  Widget build(BuildContext context) {
    //var user = LoggedUsuari().usuari;
    var user = usuariHardcodeado;
    return Scaffold(
      appBar: customAppBar(context, false),
      drawer: const NavigationDrawerWidget(),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          return Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Activitats registrades',
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline_rounded),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return const RegistreActivitatPage();
                            }),
                          );
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: user.personesDependents.length,
                      itemBuilder: (context, index) {
                        var userDependents = user.personesDependents[index].nom;
                        var dependentsActivities =
                            user.activitats[userDependents]!.length;

                        return ListTile(
                          title: Text(user.personesDependents[index].nom),
                          subtitle: Text(
                              'Té ${dependentsActivities.toString()} activitats'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                if (user.activitats[userDependents] != null) {
                                  return LlistaActivitatsDetall(
                                      activitats:
                                          user.activitats[userDependents]!,
                                      nom: userDependents);
                                } else {
                                  return const LlistaActivitatsDetall(
                                      activitats: [], nom: '');
                                }
                              }),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
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
      home: const LlistaActivitats(),
    ),
  ));
}
