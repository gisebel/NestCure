import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:nestcure/logged_user.dart';
import 'package:url_launcher/url_launcher.dart';

class CvGenerator extends StatelessWidget {
  const CvGenerator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generar CV'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final pdf = await generatePdf();
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
      ),
    );
  }

  Future<pw.Document> generatePdf() async {
  final pdf = pw.Document();
  var loggedUser = LoggedUsuari();
  var user = loggedUser.usuari;

  // Cargar imagen de perfil
  final profileImage = await imageFromAssetBundle(user.fotoPerfil);

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(20),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Sección de encabezado con imagen de perfil y nombre
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
                pw.SizedBox(width: 20),
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
            
            // Descripción
            pw.Text(
              'Descripción',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo),
            ),
            pw.Text(user.descripcio, style: pw.TextStyle(fontSize: 14)),
            pw.SizedBox(height: 20),
            
            // Sección de Personas a cargo
            pw.Text(
              'Personas a Cargo',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo),
            ),
            pw.SizedBox(height: 10),
            pw.Column(
              children: user.personesDependents.map((persona) {
                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 10),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        '- ${persona.nombre}',
                        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text('  Edad: ${persona.edad} años'),
                      pw.Text('  Dirección: ${persona.direccion}'),
                      pw.Text('  Descripción: ${persona.descripcion}'),
                    ],
                  ),
                );
              }).toList(),
            ),
            pw.SizedBox(height: 20),

            //Sección de Actividades
            if (user.activitats.isNotEmpty)
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Actividades',
                    style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo),
                  ),
                  pw.SizedBox(height: 10),
                  ...user.activitats.map((entry) {
                    return pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      /*children: [
                        pw.Text('- ${entry.key}', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                        ...entry.map((actividad) => pw.Text('   • ${actividad.title}: ${actividad.description} (${actividad.hours} horas)')),
                      ],*/
                    );
                  }).toList(),
                ],
              ),
            
            /*Sección de Conocimientos
            pw.SizedBox(height: 20),
            pw.Text(
              'Conocimientos',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo),
            ),
            ...user.activitats['Conocimientos'].map((conocimiento) {
              return pw.Text('• ${conocimiento.title}', style: pw.TextStyle(fontSize: 14));
            }) ?? [],

            pw.SizedBox(height: 20),*/

            /* Sección de Certificados
            if (user.activitats['Certificados'] != null)
              pw.Text(
                'Certificados',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo),
              ),
              */
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