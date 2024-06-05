import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:nestcure/app_bar.dart';

class ValidateCertificate extends StatefulWidget {
  const ValidateCertificate({super.key});

  @override
  _ValidateCertificateState createState() => _ValidateCertificateState();
}

class _ValidateCertificateState extends State<ValidateCertificate> {
  final TextEditingController _commentController = TextEditingController();
  File? _certificateFile;

  Future<void> _pickFile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _certificateFile = File(pickedFile.path);
      });
    }
  }

  void _submitCertificate() {
    // Aquí realizarás la llamada a la API para subir el certificado y los comentarios.
    // Ejemplo:
    // ApiService.uploadCertificate(_certificateFile, _commentController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Certificado enviado para validación')),
    );
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
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.attach_file),
              label: const Text('Adjunta fitxer'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.green,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Comentaris i observacions...',
                ),
                maxLines: 5,
              ),
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
