import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nestcure/user.dart';
import 'package:nestcure/persona_dependent.dart';
import 'package:nestcure/activitat.dart';
import 'package:nestcure/certificate_provider.dart';
import 'package:nestcure/app_bar.dart';
import 'package:http/http.dart' as http;

class CvGenerator extends StatelessWidget {
  CvGenerator({Key? key}) : super(key: key);

  Stream<DocumentSnapshot> _getUserDataStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('usuarios').doc(user.uid);
      return userRef.snapshots();
    } else {
      return Stream.empty();
    }
  }

  final Map<String, String> testTranslations = {
    'HealthKnowledge': 'Conocimientos de salud',
    'AttentionKnowledge': 'Conocimientos de atención',
    'CommunicationSkills': 'Habilidades de comunicación',
    'PracticalSkills': 'Habilidades prácticas',
  };

  final Map<String, String> testLevelTranslations = {
    'basic': 'Básico: ',
    'intermediate': 'Intermedio: ',
    'advanced': 'Avanzado: ',
  };

  String getTestName(String testKey) {
    final levelKeys = ['basic', 'intermediate', 'advanced'];
    String? levelKey = levelKeys.firstWhere((key) => testKey.toLowerCase().startsWith(key));
    String typeKey = testKey.substring(levelKey.length, testKey.length - 4);
    typeKey = typeKey[0].toUpperCase() + typeKey.substring(1);

    final translatedLevel = testLevelTranslations[levelKey] ?? levelKey;
    final translatedType = testTranslations[typeKey] ?? typeKey;

    return '$translatedLevel $translatedType';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, false),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _getUserDataStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los datos del usuario'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Por favor, inicia sesión para generar tu CV'));
          }

          final userData = snapshot.data!;
          final user = Usuari(
            nomCognoms: userData['nomCognoms'] ?? '',
            correu: userData['correu'] ?? '',
            esCuidadorPersonal: userData['esCuidadorPersonal'] ?? false,
            dataNaixement: (userData['dataNaixement'] as Timestamp).toDate(),
            descripcio: userData['descripcio'] ?? '',
            fotoPerfil: userData['fotoPerfil'] ?? '',
            personesDependents: (userData['personesDependents'] as List<dynamic>)
                .map((e) => PersonaDependent.fromMap(e))
                .toList(),
            activitats: (userData['activitats'] as List<dynamic>)
                .map((e) => Activitat.fromMap(e))
                .toList(),
            certificats: (userData['certificats'] as List<dynamic>)
                .map((e) => Certificate.fromMap(Map<String, dynamic>.from(e)))
                .toList(),
            tests: userData['tests'] != null
                ? Map<String, int>.from(userData['tests'])
                : {},
            genero: userData['genero'] ?? '',
            telefono: userData['telefono'] ?? '',
            direccion: userData['direccion'] ?? '',
          );
          return _buildContent(context, user);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, Usuari user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCvSection(user),
          const SizedBox(height: 40),
          _buildConnectWithSuaraSection(),
        ],
      ),
    );
  }

  Widget _buildCvSection(Usuari user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Generar currículum vitae',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 20),
        Text(
          'Crea tu currículum vitae profesional de forma automática.',
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () async {
            final pdf = await generatePdf(user);
            await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
          },
          icon: const Icon(Icons.picture_as_pdf, size: 24.0, color: Colors.white,),
          label: const Text(
            'Generar documento',
            style: TextStyle(fontSize: 18.0),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 3,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: Color.fromRGBO(45, 87, 133, 1),
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildConnectWithSuaraSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Conecta con Suara',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 20),
        Text(
          'Accede a oportunidades laborales y únete a una comunidad profesional dedicada al cuidado y la atención.',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: _launchURL,
          icon: const Icon(Icons.link, size: 24.0, color: Colors.white,),
          label: const Text(
            'Ir a Suara',
            style: TextStyle(fontSize: 18.0),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 3,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor:  Color.fromRGBO(45, 87, 133, 1),
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  void _launchURL() async {
    const url = 'https://talent.suara.coop/#jobs';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir la URL';
    }
  }
  
  Future<pw.Document> generatePdf(Usuari user) async {
    final pdf = pw.Document();

    final defaultImage = user.genero == 'Mujer'
        ? 'images/avatar_chica.png'
        : 'images/avatar_chico.png';
    final profileImage = await downloadImage(user.fotoPerfil.isNotEmpty ? user.fotoPerfil : defaultImage);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.only(
          left: 28, 
          top: 28, 
          right: 28, 
          bottom: 50,
        ), 
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 100,
                      height: 100,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        image: pw.DecorationImage(
                          image: profileImage,
                          fit: pw.BoxFit.cover,
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 15),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            user.nomCognoms,
                            style: pw.TextStyle(
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.black,
                            ),
                          ),
                          pw.Text(
                            user.correu,
                            style: pw.TextStyle(
                              fontSize: 14,
                              color: PdfColors.grey,
                            ),
                          ),
                          pw.Text(
                            'Rol: ${user.esCuidadorPersonal ? 'Cuidador Personal' : 'Cuidador Profesional'}',
                            style: pw.TextStyle(fontSize: 14, color: PdfColors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.Divider(),

                pw.SizedBox(height: 10),
                pw.Text(
                  'Detalles Personales',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(0x2D5885),
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text('Teléfono: ${user.telefono}', style: pw.TextStyle(fontSize: 12)),
                pw.Text('Dirección: ${user.direccion}', style: pw.TextStyle(fontSize: 12)),
                pw.Text(
                  'Fecha de Nacimiento: ${user.dataNaixement.day}-${user.dataNaixement.month}-${user.dataNaixement.year}',
                  style: pw.TextStyle(fontSize: 12),
                ),

                pw.SizedBox(height: 10),
                pw.Divider(),

                pw.Text(
                  'Descripción Personal',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(0x2D5885),
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(user.descripcio, style: pw.TextStyle(fontSize: 12)),

                pw.SizedBox(height: 10),
                pw.Divider(),

                if (user.tests.isNotEmpty) ...[
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Tests Realizados',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromInt(0x2D5885),
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  ...user.tests.entries
                      .where((entry) => entry.value >= 5)
                      .map((entry) {
                        final testName = getTestName(entry.key);
                        return pw.Text(
                          '$testName: ${entry.value}',
                          style: pw.TextStyle(fontSize: 12, color: PdfColors.black),
                        );
                      }).toList(),
                ],

                pw.SizedBox(height: 10),
                pw.Divider(),

                if (user.certificats.isNotEmpty) ...[
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Certificados',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromInt(0x2D5885),
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  ...user.certificats.map((certificat) {
                    return pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Título: ${certificat.title}', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Fecha: ${certificat.date.toLocal().toString().split(' ')[0]}', style: pw.TextStyle(fontSize: 12)),
                        pw.Text('Descripción: ${certificat.description}', style: pw.TextStyle(fontSize: 12)),
                        pw.Text('Nombre del fichero: ${certificat.fileName}', style: pw.TextStyle(fontSize: 12)),
                        pw.SizedBox(height: 10),
                      ],
                    );
                  }).toList(),
                ],

                pw.SizedBox(height: 10),
                pw.Divider(),

                if (user.activitats.isNotEmpty) ...[
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Actividades Realizadas',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromInt(0x2D5885),
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  ...user.activitats.map((activitat) {
                    return pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Título: ${activitat.title}', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Fecha: ${activitat.date.toLocal().toString().split(' ')[0]}', style: pw.TextStyle(fontSize: 12)),
                        pw.Text('Horas: ${activitat.hours}', style: pw.TextStyle(fontSize: 12)),
                        pw.Text('Descripción: ${activitat.description}', style: pw.TextStyle(fontSize: 12)),
                        pw.SizedBox(height: 10),
                      ],
                    );
                  }).toList(),
                ],
              ],
            ),
          ];
        },
      ),
    );
    return pdf;
  }

  Future<pw.ImageProvider> downloadImage(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return pw.MemoryImage(response.bodyBytes);
    } else {
      throw Exception('Failed to load image');
    }
  }
}