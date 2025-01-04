import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
      appBar: AppBar(
        title: const Text("Conectar con Suara"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _launchURL,
          child: const Text('Conectar con Suara'),
        ),
      ),
    );
  }
}
