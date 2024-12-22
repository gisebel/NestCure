import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nestcure/certificate_provider.dart';
import 'package:nestcure/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

class ListCertificates extends StatefulWidget {
  const ListCertificates({super.key});

  @override
  _ListCertificatesState createState() => _ListCertificatesState();
}

class _ListCertificatesState extends State<ListCertificates> {
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context, ValueChanged<DateTime> onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        onDateSelected(picked);
        _dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Future<void> _addCertificate(BuildContext context) async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    DateTime? selectedDate;
    String? selectedFileName;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.95),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Añadir Certificado', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromRGBO(45, 88, 133, 1))),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Título', border: OutlineInputBorder(), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(45, 88, 133, 1)))),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción', border: OutlineInputBorder(), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(45, 88, 133, 1)))),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(45, 88, 133, 1))),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context, (pickedDate) {
                    selectedDate = pickedDate;
                  }),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );
                    if (result != null) {
                      setState(() {
                        selectedFileName = result.files.single.name;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
                    backgroundColor: Color.fromRGBO(45, 88, 133, 1),  // Use backgroundColor instead of primary
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Seleccionar PDF', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
                if (selectedFileName != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text('Archivo seleccionado: $selectedFileName', style: TextStyle(fontSize: 14, color: Colors.green)),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(fontSize: 16, color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    selectedDate != null &&
                    selectedFileName != null) {
                  try {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Usuario no autenticado')),
                      );
                      return;
                    }

                    final certificateData = Certificate(
                      title: titleController.text,
                      description: descriptionController.text,
                      fileName: selectedFileName!,
                      date: selectedDate!,
                    );

                    final userRef = FirebaseFirestore.instance.collection('usuarios').doc(user.uid);
                    await userRef.update({
                      'certificats': FieldValue.arrayUnion([certificateData.toJson()])
                    });

                    Provider.of<CertificateProvider>(context, listen: false)
                        .addCertificate(certificateData);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Certificado añadido con éxito')),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al guardar el certificado: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Todos los campos son obligatorios')),
                  );
                }
              },
              child: const Text('Guardar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCertificate(Certificate certificate) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario no autenticado')),
        );
        return;
      }

      final userRef = FirebaseFirestore.instance.collection('usuarios').doc(user.uid);
      await userRef.update({
        'certificats': FieldValue.arrayRemove([certificate.toJson()]) // Eliminar el certificado completo
      });

      // Eliminar el certificado localmente
      Provider.of<CertificateProvider>(context, listen: false).removeCertificate(certificate);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Certificado eliminado con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el certificado: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: customAppBar(context, false),
        body: const Center(child: Text('Por favor, inicia sesión para ver los certificados.')),
      );
    }

    return Scaffold(
      appBar: customAppBar(context, false),
      body: Consumer<CertificateProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Mis certificados',
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline_rounded, color: Color.fromRGBO(45, 88, 133, 1)),
                      onPressed: () => _addCertificate(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('usuarios')
                      .doc(user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(child: Text('Error al cargar los certificados.'));
                    }

                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(child: Text('No hay certificados disponibles.'));
                    }

                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    final certificatsData = data['certificats'];

                    if (certificatsData == null || certificatsData.isEmpty) {
                      return const Center(child: Text('No tienes certificados guardados.'));
                    }

                    List<Certificate> certificates = [];
                    for (var item in certificatsData) {
                      if (item is Map<String, dynamic>) {
                        certificates.add(Certificate.fromMap(item));
                      }
                    }
                    return Expanded(
  child: ListView.builder(
    padding: EdgeInsets.zero, // Remueve el margen extra de la lista
    itemCount: certificates.length,
    itemBuilder: (context, index) {
      final certificate = certificates[index];
      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18), // Bordes redondeados más pronunciados
        ),
        elevation: 6, // Sombra más suave para darle profundidad
        color: Colors.white, // Color de fondo de la tarjeta
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18), // Asegura que la tarjeta tenga bordes redondeados
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Relleno más espacioso
            title: Text(
              certificate.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color.fromRGBO(45, 88, 133, 1), // Título con el color azul que mencionaste
              ),
            ),
            childrenPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Padding interno
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  const Text(
                    'Título:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(certificate.title, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10.0),

                  // Descripción
                  const Text(
                    'Descripción:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(certificate.description, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10.0),

                  // Fecha
                  const Text(
                    'Fecha:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    DateFormat('d MMMM yyyy, h:mm:ss a').format(certificate.date),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10.0),

                  // Nombre del documento
                  const Text(
                    'Nombre del documento:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(certificate.fileName, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10.0),

                  // Botón de eliminar con icono estilizado
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete_forever, // Icono de eliminar más estilizado
                        color: Colors.red,
                        size: 30, // Hacerlo un poco más grande para llamar la atención
                      ),
                      onPressed: () => _deleteCertificate(certificate),
                      splashRadius: 25, // Radio de animación al presionar
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  ),
);

                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}