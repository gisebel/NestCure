import 'dart:typed_data'; // Para manejar los bytes del archivo
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nestcure/certificate_provider.dart';
import 'package:nestcure/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart'; // Para dar formato a la fecha
import 'package:url_launcher/url_launcher.dart';

class ListCertificates extends StatefulWidget {
  const ListCertificates({super.key});

  @override
  _ListCertificatesState createState() => _ListCertificatesState();
}

class _ListCertificatesState extends State<ListCertificates> {
  int? _selectedIndex;
  final TextEditingController _dateController = TextEditingController();

  // Controlador para mostrar el estado de carga
  bool _isUploading = false; // Bandera para indicar si el archivo está siendo cargado

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

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
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    DateTime? selectedDate;
    Uint8List? selectedFileBytes; // Para almacenar los bytes del archivo seleccionado

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Añadir Certificado'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context, (pickedDate) {
                    selectedDate = pickedDate;
                  }),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );
                    if (result != null) {
                      print("Archivo seleccionado: ${result.files.single.name}");
                      setState(() {
                        selectedFileBytes = result.files.single.bytes;  // Obtener los bytes del archivo
                      });
                    } else {
                      print("No se seleccionó ningún archivo");
                    }
                  },
                  child: const Text('Seleccionar PDF'),
                ),
                if (selectedFileBytes != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text('Archivo seleccionado'),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    selectedDate != null &&
                    selectedFileBytes != null) {
                  print("Iniciando proceso de carga...");
                  try {
                    setState(() {
                      _isUploading = true; // Indicamos que la carga ha comenzado
                    });

                    // Subir archivo a Firebase Storage usando los bytes
                    final storageRef = FirebaseStorage.instance
                        .ref()
                        .child('certificates/${nameController.text}_${DateTime.now().millisecondsSinceEpoch}.pdf');
                    print("Subiendo archivo a Firebase Storage...");
                    final uploadTask = storageRef.putData(selectedFileBytes!);  // Usar putData para subir los bytes

                    // Escuchar el progreso de la carga
                    uploadTask.snapshotEvents.listen((taskSnapshot) {
                      print("Progreso de carga: ${taskSnapshot.bytesTransferred}/${taskSnapshot.totalBytes}");
                    });

                    // Esperar la finalización de la carga
                    final snapshot = await uploadTask.whenComplete(() => {});
                    final fileUrl = await snapshot.ref.getDownloadURL();
                    print("Archivo subido exitosamente. URL: $fileUrl");

                    // Guardar en Firestore
                    final newCertificate = Certificate(
                      name: nameController.text,
                      description: descriptionController.text,
                      fileUrl: fileUrl,
                      date: selectedDate!,
                    );
                    print("Guardando certificado en Firestore...");
                    await FirebaseFirestore.instance.collection('certificates').add(newCertificate.toJson());

                    // Actualizar el provider
                    Provider.of<CertificateProvider>(context, listen: false).addCertificate(newCertificate);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Certificado añadido con éxito')),
                    );

                    Navigator.pop(context);
                  } catch (e) {
                    print("Error durante la carga o guardado: $e");
                    // Mostrar un mensaje de error si algo sale mal
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al subir el archivo: $e')),
                    );
                  } finally {
                    setState(() {
                      _isUploading = false; // Terminó la carga
                    });
                  }
                } else {
                  print("Faltan datos: nombre, descripción, fecha o archivo");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Todos los campos son obligatorios')),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final certificateProvider = Provider.of<CertificateProvider>(context);
    final certificates = certificateProvider.certificates;

    return Scaffold(
      appBar: customAppBar(context, false),
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
                    Text(
                      'Fecha: ${DateFormat('dd-MM-yyyy').format(certificate.date)}',
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
                          onPressed: () async {
                            // Eliminar de Firestore y Provider
                            await FirebaseFirestore.instance
                                .collection('certificates')
                                .where('fileUrl', isEqualTo: certificate.fileUrl)
                                .get()
                                .then((snapshot) {
                              for (var doc in snapshot.docs) {
                                doc.reference.delete();
                              }
                            });

                            certificateProvider.removeCertificate(certificate);

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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addCertificate(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}