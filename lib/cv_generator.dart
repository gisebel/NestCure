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

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Currículum Vitae',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Nombre: ${user.nomCognoms}', style: pw.TextStyle(fontSize: 18)),
            pw.Text('Fecha de Nacimiento: ${user.dataNaixement.day}-${user.dataNaixement.month}-${user.dataNaixement.year}', style: pw.TextStyle(fontSize: 18)),
            pw.Text('Correo Electrónico: ${user.correu}', style: pw.TextStyle(fontSize: 18)),
            pw.Text('Rol: ${user.esCuidadorPersonal ? 'Cuidador Personal' : 'Cuidador Profesional'}', style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 10),
            pw.Text('Descripción:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.Text(user.descripcio, style: pw.TextStyle(fontSize: 16)),
            pw.SizedBox(height: 20),
            pw.Text('Personas a cargo:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            ...user.personesDependents.map((persona) => pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('- ${persona.nombre}', style: pw.TextStyle(fontSize: 16)),
                    pw.Text('  Descripción: ${persona.descripcion}', style: pw.TextStyle(fontSize: 14)),
                    pw.Text('  Edad: ${persona.edad} años', style: pw.TextStyle(fontSize: 14)),
                    pw.Text('  Dirección: ${persona.direccion}', style: pw.TextStyle(fontSize: 14)),
                    pw.SizedBox(height: 10),
                  ],
                )),
          ],
        ),
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