import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nestcure/certificate_provider.dart';
import 'package:nestcure/app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class ListCertificates extends StatefulWidget {
  const ListCertificates({super.key});

  @override
  _ListCertificatesState createState() => _ListCertificatesState();
}

class _ListCertificatesState extends State<ListCertificates> {
  int? _selectedIndex;

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
    final certificateProvider = Provider.of<CertificateProvider>(context);
    final certificates = certificateProvider.certificates;

    return Scaffold(
      appBar: customAppBar(context),
      drawer: const NavigationDrawerWidget(),
      body: ListView.builder(
        itemCount: certificates.length,
        itemBuilder: (context, index) {
          final certificate = certificates[index];
          return ExpansionTile(
            leading: Icon(
              Icons.book,
              color: _selectedIndex == index ? Colors.green : Colors.grey,
            ),
            title: Text(
              certificate.name,
              textAlign: TextAlign.left,
            ),
            onExpansionChanged: (expanded) {
              setState(() {
                _selectedIndex = expanded ? index : null;
              });
            },
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      certificate.description, // Agrega la descripción del certificado aquí
                      textAlign: TextAlign.left, // Alinea el texto a la izquierda
                    ),
                    TextButton(
                      onPressed: () {
                        _launchURL(certificate.fileUrl);
                      },
                      child: const Text(
                        "Obrir Fitxer",
                        style: TextStyle(color: Colors.blue),
                      ),
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
