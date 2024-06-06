import 'package:flutter/material.dart'; // Importa el paquete de material design
import 'package:image_picker/image_picker.dart';  // Para seleccionar archivos
//import 'package:file_picker/file_picker.dart';  // Para seleccionar archivos
import 'dart:io'; // Para trabajar con archivos
import 'package:http/http.dart' as http;
import 'dart:convert';  // Para decodificar la respuesta JSON
import 'package:provider/provider.dart';  // Para usar Provider
import 'package:nestcure/certificate_provider.dart';  // Importa el modelo Certificate
import 'package:nestcure/app_bar.dart'; // Importa la barra de navegación personalizada
//import 'package:permission_handler/permission_handler.dart';

class ValidateCertificate extends StatefulWidget {
  const ValidateCertificate({super.key});

  @override
  _ValidateCertificateState createState() => _ValidateCertificateState();
}

class _ValidateCertificateState extends State<ValidateCertificate> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _filenameController = TextEditingController();
  File? _certificateFile;

  //Para seleccionar un archivo de la galería, necesitamos el paquete image_picker.
  Future<void> _pickFile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _certificateFile = File(pickedFile.path);
      });
    }
  }

/*
  Future<void> _pickFile() async {
    // Solicitar permiso de almacenamiento
    if (await Permission.storage.request().isGranted) {
      // Abre el selector de archivos
      final result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.single.path != null) {
        setState(() {
          _certificateFile = File(result.files.single.path!);
        });
      }
    } else {
      // Mostrar un mensaje al usuario indicando que necesita permisos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Necesitas otorgar permisos de almacenamiento para seleccionar un archivo')),
      );
    }
  }
  */

/*
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      setState(() {
        _certificateFile = File(result.files.single.path!);
      });
    }
  }
*/
  Future<void> _submitCertificate() async {
    if (_certificateFile == null) return;

    const String url = 'https://ipfsapi-v2.vottun.tech/ipfs/v2/file/upload';
    const String bearerToken = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIyZlNBRTBVTGFXTU8yQ2NCOXB4SlB1REY5cWQiLCJ0eXBlIjoiZXJwIiwiaWQiOiIiLCJ1c2VybmFtZSI6Im1hcmNkdXJhbmxvcGV6QGdtYWlsLmNvbSIsImNpZCI6IjUwNTIzZGMzLTk1MGItNGIyOC04ZDc2LTVhNmU3OGY1Yjk4NyIsInNrdSI6W3siciI6MTEsInMiOjgsImUiOjB9LHsiciI6MTEsInMiOjgwMDIsImUiOjB9LHsiciI6MTEsInMiOjgwMTAsImUiOjB9LHsiciI6MTEsInMiOjgwMDEsImUiOjB9XSwicHVjIjoiMDAwMDAwMDAtMDAwMC0wMDAwLTAwMDAtMDAwMDAwMDAwMDAwIn0.mVZadU2E5Jm1eSGhdHnQoSCeXQUux_OpEq-kwUQEQLIu9vWWoisB1PIshlWEigDyekH7r9O93SPZD7D98KNcx7Zlxokgn1AJQ8LkaLwYay2NnTwCQ0SvRYE0idmICLX5Ab4WUBiJP4iNkLAV7KIUuIzdYR45VWfEguYJNtktiM3kWWnjmM9jJqo-hRgKQ2g9OL2SukTauREaDeENWN6dlUIFPl2iQnwAaFfFrQIwkVyWJX0Lmjocz1phntWJ-Qnw0p0Q4ePUNAJYBHujoqRB7H8FAPIE3UMY40mjKlnykAKSgdGGfGAcGrlbYvSnvqxF6eYXr83q6HIoMO34ijkY8EltAlCVXRtxxPN9hGv_WqgSgHZ-tWFbsNCbIF-mKtsf8rP0SFDgNAj-HgbKDPjED0KHYBS0zV4z_uRDYHam10AV18udpxFAmsDRLDHVu5R9vM8J46Nc0LrjZOCEoESLJz5DN9dDBkhQOudw0w-cYb0vNHn7mHkNo4LLhnSHZlPhie62Ny1y2cscrxUiWJ19-FoUG4CZt9-f00TLVNJ12xRxicY987lm7ZDgysNGnQsAzrpDw0ZgBI-w3aT7hq-tsgwqD2wQxvA0i-G89Tmp7kdToS5oRSziCq4UnPMozO9j0q1O_7AyNr0Snlw7hTwG6UC2TMLi1krjV75MYvfmL28';
    const String applicationKey = '6gUrYMx9LDbczlzAViGKGy1-pBLUGgcqWI_deQQ-uUMA3RElclJjOI5bbNuzIWHw';

    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..headers['Authorization'] = 'Bearer $bearerToken'
      ..headers['x-application-vkn'] = applicationKey
      ..files.add(await http.MultipartFile.fromPath('file', _certificateFile!.path))
      ..fields['filename'] = _filenameController.text;

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var decodedResponse = jsonDecode(responseBody); // Decodifica la respuesta JSON
      String ipfsUrl = decodedResponse['hash']; // Extrae la URL del archivo IPFS

      Provider.of<CertificateProvider>(context, listen: false).addCertificate(
        Certificate(
          name: _filenameController.text,
          description: _commentController.text,
          fileUrl: ipfsUrl,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Certificado enviado para validación')),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al enviar el certificado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      drawer: const NavigationDrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _filenameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nom del fitxer',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.attach_file),
              label: const Text('Adjunta fitxer'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.green, // Cambia el color del botón a verde
              ),
            ),
            const SizedBox(height: 16.0), // Añade un espacio entre el botón y el recuadro de comentarios
            if (_certificateFile != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Fitxer seleccionat: ${_certificateFile!.path}'),
              ),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Comentaris i observacions...',
              ),
              maxLines: 5,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Enrere'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade200,
                  ),
                ),
                ElevatedButton(
                  onPressed: _submitCertificate,
                  child: const Text('Validar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}