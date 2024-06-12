import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nestcure/app_bar.dart';
import 'package:nestcure/login.dart';
import 'package:nestcure/user_provider.dart';
import 'package:nestcure/certificate_provider.dart';
import 'package:nestcure/validate_certificate.dart';
import 'package:nestcure/list_certificates.dart';

void main() {
  runApp(const MyApp());
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
          '/list': (context) => const ListCertificates(),
        },
      ),
    );
  }

  /* @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(), // Utiliza LoginPage como la página de inicio
        routes: {
          '/validate': (context) => const ValidateCertificate(),
          '/list': (context) => const ListCertificates(),
        },
      ),
    );
  }*/
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, false),
      drawer: const NavigationDrawerWidget(),
      body: Container(),
      /*
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/list');
          },
          child: const Text('Ir a la Lista de Certificados'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade200,
          ),
        ),
      ),
      */
    );
  }
}
