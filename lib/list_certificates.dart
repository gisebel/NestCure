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
    // Lista hard-coded de certificados
    final List<Certificate> hardCodedCertificates = [
      Certificate(
        name: 'Certificado negativo de delitos penales',
        description: 'Certificado negativo de delitos penales por parte del Ministerio de Justicia',
        fileUrl: 'https://ipfsgw.vottun.tech/ipfs/bafkreigzswrxu4m2asy27xmqsarv3cmwfcesluq6bmldtbsjn5omrxgxnm',
      ),
      Certificate(
        name: 'Certificado de expedición de titulo oficial',
        description: 'Certificado de expedición de titulo oficial por parte de la Universidad de Castilla y la Mancha',
        fileUrl: 'https://ipfsgw.vottun.tech/ipfs/bafkreif5sxr5q6yazf27rw25hz4z524optyja3kquryq3knpb2phept2ma',
      ),
    ];

    final certificateProvider = Provider.of<CertificateProvider>(context);
    final certificates = hardCodedCertificates + certificateProvider.certificates;

    return Scaffold(
      appBar: customAppBar(context, false),
      //drawer: const NavigationDrawerWidget(),
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
                      certificate.description,
                      textAlign: TextAlign.left,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            _launchURL(certificate.fileUrl);
                          },
                          child: const Text(
                            "Abrir fichero",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              // Removemos el certificado tanto del provider como de la lista hardcoded.
                              if (index < hardCodedCertificates.length) {
                                hardCodedCertificates.removeAt(index);
                              } else {
                                certificateProvider.removeCertificate(certificate);
                              }
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Certificado eliminado')),
                            );
                          },
                        ),
                      ],
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
          child: const Text('Atrás'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade200,
          ),
        ),
      ),
    );
  }
}