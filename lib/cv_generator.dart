import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nestcure/user.dart';

class CvGenerator extends StatelessWidget {
  const CvGenerator({Key? key}) : super(key: key);

  Stream<DocumentSnapshot> _getUserDataStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('usuarios').doc(user.uid);
      return userRef.snapshots();
    } else {
      return Stream.empty();
    }
  }

  // Función para guardar el PDF en el dispositivo
  Future<String> savePdf(pw.Document pdf) async {
    final outputDir = await getTemporaryDirectory(); // Obtén el directorio temporal
    final filePath = '${outputDir.path}/cv_documento.pdf';

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save()); // Guarda el PDF

    return filePath; // Devuelve la ruta del archivo
  }

  // Función para abrir el PDF dentro de la app
  void openPdf(BuildContext context, String filePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFView(
          filePath: filePath,
        ),
      ),
    );
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

          final user = Usuari.fromFirestore(snapshot.data!.data() as Map<String, dynamic>);
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
              final filePath = await savePdf(pdf); // Guarda el PDF

              openPdf(context, filePath); // Abre el PDF directamente en la app
            },
            child: const Text('Generar PDF'),
          ),
        ],
      ),
    );
  }

  Future<pw.Document> generatePdf(Usuari user) async {
    final pdf = pw.Document();
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
              
              // Sección de actividades
              pw.SizedBox(height: 20),
              pw.Text(
                'Actividades',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo),
              ),
              ...user.activitats.map(
                (actividad) => pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      actividad.title ?? 'Sin título',
                      style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text('Fecha: ${actividad.date}'),
                    pw.Text('Descripción: ${actividad.description}'),
                    pw.Text('Horas: ${actividad.hours}'),
                    pw.Divider(),
                  ],
                ),
              ),

              // Sección de certificados
              pw.SizedBox(height: 20),
              pw.Text(
                'Certificados',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo),
              ),
              ...user.certificats.map(
                (certificado) => pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      certificado.title ?? 'Sin título',
                      style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text('Fecha: ${certificado.date}'),
                    pw.Text('Descripción: ${certificado.description}'),
                    pw.Divider(),
                  ],
                ),
              ),

              // Sección de tests
              pw.SizedBox(height: 20),
              pw.Text(
                'Tests de Conocimientos',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo),
              ),
              pw.Text('Atención Básica: ${user.tests['basicAttentionKnowledgeTest'] ?? false ? 'Aprobado' : 'No aprobado'}'),
              pw.Text('Comunicación Básica: ${user.tests['basicCommunicationSkillsTest'] ?? false ? 'Aprobado' : 'No aprobado'}'),
              pw.Text('Salud Básica: ${user.tests['basicHealthKnowledgeTest'] ?? false ? 'Aprobado' : 'No aprobado'}'),
              pw.Text('Prácticas Básicas: ${user.tests['basicPracticalSkillsTest'] ?? false ? 'Aprobado' : 'No aprobado'}'),
              pw.Text('Atención Intermedia: ${user.tests['intermediateAttentionKnowledgeTest'] ?? false ? 'Aprobado' : 'No aprobado'}'),
              pw.Text('Comunicación Intermedia: ${user.tests['intermediateCommunicationSkillsTest'] ?? false ? 'Aprobado' : 'No aprobado'}'),
              pw.Text('Salud Intermedia: ${user.tests['intermediateHealthKnowledgeTest'] ?? false ? 'Aprobado' : 'No aprobado'}'),
              pw.Text('Prácticas Intermedias: ${user.tests['intermediatePracticalSkillsTest'] ?? false ? 'Aprobado' : 'No aprobado'}'),
              pw.Text('Atención Avanzada: ${user.tests['advancedAttentionKnowledgeTest'] ?? false ? 'Aprobado' : 'No aprobado'}'),
              pw.Text('Comunicación Avanzada: ${user.tests['advancedCommunicationSkillsTest'] ?? false ? 'Aprobado' : 'No aprobado'}'),
              pw.Text('Salud Avanzada: ${user.tests['advancedHealthKnowledgeTest'] ?? false ? 'Aprobado' : 'No aprobado'}'),
              pw.Text('Prácticas Avanzadas: ${user.tests['advancedPracticalSkillsTest'] ?? false ? 'Aprobado' : 'No aprobado'}'),
            ],
          );
        },
      ),
    );
    return pdf;
  }
}