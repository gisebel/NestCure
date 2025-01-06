import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nestcure/user.dart';
import 'package:nestcure/app_bar.dart';

class EditProfileScreen extends StatefulWidget {
  final Usuari user;

  const EditProfileScreen({super.key, required this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late DateTime _selectedDate;
  late bool _esCuidadorPersonal;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.nomCognoms);
    _descriptionController = TextEditingController(text: widget.user.descripcio);
    _phoneController = TextEditingController(text: widget.user.telefono);
    _addressController = TextEditingController(text: widget.user.direccion);
    _selectedDate = widget.user.dataNaixement;
    _esCuidadorPersonal = widget.user.esCuidadorPersonal;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Editar perfil',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: widget.user.fotoPerfil.isNotEmpty
                      ? NetworkImage(widget.user.fotoPerfil) as ImageProvider
                      : (widget.user.genero == 'Mujer'
                          ? const AssetImage('images/avatar_chica.png')
                          : const AssetImage('images/avatar_chico.png')),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre y Apellidos',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Dirección',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                ),
              ),
              const SizedBox(height: 16.0),
              ListTile(
                title: const Text('Fecha de nacimiento'),
                subtitle: Text(DateFormat('dd-MM-yyyy').format(_selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16.0),
              ListTile(
                title: const Text('Rol del perfil'),
                subtitle: Text(_esCuidadorPersonal ? 'Cuidador personal' : 'Cuidador profesional'),
                trailing: Switch(
                  value: _esCuidadorPersonal,
                  onChanged: (bool newValue) {
                    setState(() {
                      _esCuidadorPersonal = newValue;
                    });
                  },
                ),
              ),
              const SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      _showCancelDialog();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _saveProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      'Guardar',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Estás seguro de que quieres cancelar?'),
          content: const Text('Se perderán los cambios realizados.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Sí',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;

        setState(() {
          widget.user.nomCognoms = _nameController.text;
          widget.user.descripcio = _descriptionController.text;
          widget.user.telefono = _phoneController.text;
          widget.user.direccion = _addressController.text;
          widget.user.dataNaixement = _selectedDate;
          widget.user.esCuidadorPersonal = _esCuidadorPersonal;
        });

        await FirebaseFirestore.instance.collection('usuarios').doc(userId).update({
          'nomCognoms': widget.user.nomCognoms,
          'descripcio': widget.user.descripcio,
          'telefono': widget.user.telefono,
          'direccion': widget.user.direccion,
          'dataNaixement': widget.user.dataNaixement,
          'esCuidadorPersonal': widget.user.esCuidadorPersonal,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado correctamente')),
        );

        Navigator.of(context).pop(true);
      }
    } catch (e) {
      print('Error al actualizar el perfil: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar el perfil')),
      );
    }
  }
}