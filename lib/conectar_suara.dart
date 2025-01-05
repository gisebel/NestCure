import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nestcure/app_bar.dart';

class ConnectWithSuaraPage extends StatelessWidget {
  const ConnectWithSuaraPage({super.key});

  void _launchURL() async {
    const url = 'https://talent.suara.coop/#jobs';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir la URL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Título con estilo
            Text(
              'Conéctate con Suara',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.indigo, // Añadir un color atractivo
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20), // Espaciado
            // Subtítulo
            Text(
              'Accede a las oportunidades laborales en Suara y descubre una comunidad profesional dedicada al cuidado.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40), // Más espaciado
            // Botón estilizado
            ElevatedButton.icon(
              onPressed: _launchURL,
              icon: const Icon(Icons.link), // Añade un icono
              label: const Text(
                'Ir a Suara',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Bordes redondeados
                ),
                backgroundColor: Colors.indigo, // Color atractivo para el botón
              ),
            ),
          ],
        ),
      ),
    );
  }
}