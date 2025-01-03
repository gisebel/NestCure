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

class CvGenerator extends StatelessWidget {
  const CvGenerator({Key? key}) : super(key: key);

  // Método para obtener los datos del usuario autenticado
  Stream<DocumentSnapshot> _getUserDataStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('usuarios').doc(user.uid);
      return userRef.snapshots();
    } else {
      return Stream.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generar CV'),
      ),
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
            dataNaixement: DateTime.parse(userData['dataNaixement']),
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
                ? Map<String, bool>.from(userData['tests'])
                : {},
          );

          return _buildContent(context, user);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, Usuari user) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              if (user.nomCognoms.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Por favor, completa tus datos para generar el CV'),
                  ),
                );
                return;
              }

              final pdf = await generatePdf(user);
              await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
            },
            child: const Text('Generar PDF'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _launchURL(),
            child: const Text('Conecta con Suara'),
          ),
        ],
      ),
    );
  }

  Future<pw.Document> generatePdf(Usuari user) async {
    final pdf = pw.Document();

    // Descarga la imagen del perfil desde la URL
    final profileImage = user.fotoPerfil.isNotEmpty
        ? await networkImage(user.fotoPerfil)
        : null;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (profileImage != null)
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
                  if (profileImage != null) pw.SizedBox(width: 20),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          user.nomCognoms.toUpperCase(),
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blueGrey900,
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          'Correo: ${user.correu}',
                          style: pw.TextStyle(fontSize: 14, color: PdfColors.blueGrey700),
                        ),
                        pw.Text(
                          'Rol: ${user.esCuidadorPersonal ? 'Cuidador Personal' : 'Cuidador Profesional'}',
                          style: pw.TextStyle(fontSize: 14, color: PdfColors.blueGrey700),
                        ),
                        pw.Text(
                          'Fecha de Nacimiento: ${user.dataNaixement.day}-${user.dataNaixement.month}-${user.dataNaixement.year}',
                          style: pw.TextStyle(fontSize: 14, color: PdfColors.blueGrey700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.Divider(),
              pw.Text(
                'Descripción',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo),
              ),
              pw.Text(user.descripcio, style: pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 20),
              pw.Text(
                'Personas a Cargo',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo),
              ),
              pw.SizedBox(height: 10),
              ...user.personesDependents.map((persona) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '- ${persona.nombre}',
                      style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text('  Edad: ${persona.edad} años'),
                    pw.Text('  Dirección: ${persona.direccion}'),
                    pw.Text('  Descripción: ${persona.descripcion}'),
                    pw.SizedBox(height: 8),
                  ],
                );
              }).toList(),
              pw.SizedBox(height: 20),
              if (user.activitats.isNotEmpty)
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Actividades',
                      style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo),
                    ),
                    pw.SizedBox(height: 10),
                    ...user.activitats.map((actividad) {
                      return pw.Text(
                        '- ${actividad.title}: ${actividad.description} (${actividad.hours} horas)',
                        style: pw.TextStyle(fontSize: 14),
                      );
                    }).toList(),
                  ],
                ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  // Función para abrir el URL de Suara
  void _launchURL() async {
    const url = 'https://talent.suara.coop/#jobs';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir la URL';
    }
  }
}