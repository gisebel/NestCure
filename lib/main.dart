import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:nestcure/knowledge_tests.dart';
import 'package:nestcure/persona_dependent.dart';
import 'package:provider/provider.dart';
import 'package:nestcure/login.dart';
import 'package:nestcure/user_provider.dart';
import 'package:nestcure/certificate_provider.dart';
import 'package:nestcure/validate_certificate.dart';
import 'package:nestcure/list_certificates.dart';
import 'package:nestcure/llistat_activitats.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CertificateProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'NestCure',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(45, 88, 133, 1),
            background: const Color.fromARGB(255, 255, 251, 245),
            surface: const Color.fromARGB(255, 255, 251, 245),
          ),
          textTheme: const TextTheme(
              bodyLarge: TextStyle(fontSize: 17),
              titleMedium:
                  TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginPage(),
        routes: {
          '/validate': (context) => const ValidateCertificate(),
          '/list_certificates': (context) => const ListCertificates(),
          '/knowledge_tests': (context) => const KnowledgeTestsScreen(),
          '/persones_cuidades': (context) => const PersonesDependentsWidget(),
          '/llista_activitats' : (context) => const LlistaActivitats(),
        },
      ),
    );
  }
}