import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nestcure/certificate_provider.dart';
import 'package:nestcure/app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class ListCertificates extends StatelessWidget {
  const ListCertificates({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lista hard-coded de certificados
    final List<Certificate> hardCodedCertificates = [
      Certificate(
        name: 'Certificado primeros auxilios',
        description: 'Certificado de primeros auxilios por parte de Desarrolo ING',
        fileUrl: 'https://ipfsgw.vottun.tech/ipfs/bafkreicg4p6wh7tmc5t7vt36e6qlaouvrbzjsz63lznvguuupdoegfz7t4',
      ),
      Certificate(
        name: 'Certificado 2',
        description: 'Descripción del Certificado 2',
        fileUrl: 'https://ejemplo.com/archivo2.pdf',
      ),
      Certificate(
        name: 'Certificado 3',
        description: 'Descripción del Certificado 3',
        fileUrl: 'https://ejemplo.com/archivo3.pdf',
      ),
    ];

    return Scaffold(
      appBar: customAppBar(context),
      drawer: const NavigationDrawerWidget(),
      body: ListView.builder(
        itemCount: hardCodedCertificates.length,
        itemBuilder: (context, index) {
          final certificate = hardCodedCertificates[index];
          return ExpansionTile(
            leading: const Icon(Icons.book),
            title: Text(certificate.name),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nom: ${certificate.name}"),
                    Text("Descripció: ${certificate.description}"),
                    TextButton(
                      onPressed: () {
                        _launchURL(certificate.fileUrl);
                      },
                      child: const Text("Obrir Fitxer"),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Enrere'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade200,
          ),
        ),
      ),
    );
  }
}
