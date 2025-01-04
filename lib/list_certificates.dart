import 'package:flutter/material.dart';
import 'package:nestcure/certificate_provider.dart';
import 'package:nestcure/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class ListCertificates extends StatefulWidget {
  const ListCertificates({Key? key}) : super(key: key);

  @override
  State<ListCertificates> createState() => _ListCertificatesState();
}

class _ListCertificatesState extends State<ListCertificates> {
  final TextEditingController _dateController = TextEditingController();
  List<Certificate> _certificates = [];

  @override
  void initState() {
    super.initState();
    _loadCertificates();
  }

  Future<void> _loadCertificates() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario no autenticado')),
        );
        return;
      }

      final userRef = FirebaseFirestore.instance.collection('usuarios').doc(user.uid);
      final userSnapshot = await userRef.get();

      final certificatesData = userSnapshot.data()?['certificats'] ?? [];

      final List<Certificate> loadedCertificates = [];
      for (var certData in certificatesData) {
        loadedCertificates.add(Certificate.fromMap(certData));
      }

      loadedCertificates.sort((a, b) => a.date.compareTo(b.date));

      setState(() {
        _certificates = loadedCertificates;
      });
    } catch (e) {
      print("Error al cargar certificados desde Firestore: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al cargar certificados.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
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
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    DateTime? selectedDate;
    Uint8List? fileBytes;
    String? selectedFileName;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Añadir Certificado',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(45, 88, 133, 1),
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Título',
                    labelStyle: const TextStyle(color: Color.fromRGBO(45, 88, 133, 1)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(45, 88, 133, 1)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(45, 88, 133, 1)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    labelStyle: const TextStyle(color: Color.fromRGBO(45, 88, 133, 1)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(45, 88, 133, 1)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(45, 88, 133, 1)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Fecha',
                    labelStyle: const TextStyle(color: Color.fromRGBO(45, 88, 133, 1)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(45, 88, 133, 1)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(45, 88, 133, 1)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context, (pickedDate) {
                    selectedDate = pickedDate;
                    _dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                  }),
                ),
                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );
                    if (result != null) {
                      fileBytes = result.files.single.bytes;
                      selectedFileName = result.files.single.name;
                    }
                  },
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Seleccionar documento'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(45, 88, 133, 1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (titleController.text.isNotEmpty &&
                            descriptionController.text.isNotEmpty &&
                            selectedDate != null &&
                            fileBytes != null &&
                            selectedFileName != null) {
                          try {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Usuario no autenticado')),
                              );
                              return;
                            }

                            final storageRef = FirebaseStorage.instance
                                .ref()
                                .child('certificates/${selectedFileName!}');
                            final uploadTask = storageRef.putData(fileBytes!);

                            final taskSnapshot = await uploadTask;
                            final downloadUrl = await taskSnapshot.ref.getDownloadURL();

                            final certificateData = Certificate(
                              title: titleController.text,
                              description: descriptionController.text,
                              fileName: selectedFileName!,
                              fileUrl: downloadUrl,
                              date: selectedDate!,
                            );

                            final userRef = FirebaseFirestore.instance
                                .collection('usuarios')
                                .doc(user.uid);
                            await userRef.update({
                              'certificats': FieldValue.arrayUnion([certificateData.toJson()])
                            });

                            setState(() {
                              _certificates.add(certificateData);
                            });

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
                      child: const Text('Guardar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(45, 88, 133, 1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
        'certificats': FieldValue.arrayRemove([certificate.toJson()])
      });

      setState(() {
        _certificates.remove(certificate);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Certificado eliminado con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el certificado: $e')),
      );
    }
  }

  void _confirmDelete(Certificate certificate) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Confirmar eliminación",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text("¿Estás seguro de que quieres eliminar este certificado?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              "Cancelar",
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteCertificate(certificate);
            },
            child: Text(
              "Eliminar",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: customAppBar(context, false),
        body: const Center(
          child: Text(
            'Por favor, inicia sesión para ver los certificados.',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: customAppBar(context, false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Certificados',
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 30.0, color: Colors.black),
                  onPressed: () => _addCertificate(context),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: _certificates.length,
                itemBuilder: (context, index) {
                  final certificate = _certificates[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    margin: const EdgeInsets.only(bottom: 12.0),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(15.0),
                      title: Text(
                        certificate.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Descripción:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[800],
                            ),
                          ),
                          Text(
                            certificate.description,
                            style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
                          ),
                          const SizedBox(height: 10),
                          
                          Text(
                            'Fecha:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[800],
                            ),
                          ),
                          Text(
                            DateFormat('dd-MM-yyyy').format(certificate.date),
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(certificate),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}