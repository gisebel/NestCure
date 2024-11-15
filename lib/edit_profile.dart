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
  late TextEditingController _emailController;
  late TextEditingController _descriptionController;
  late TextEditingController _passwordController;
  late DateTime _selectedDate;
  late bool _esCuidadorPersonal;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.nomCognoms);
    _emailController = TextEditingController(text: widget.user.correu);
    _descriptionController = TextEditingController(text: widget.user.descripcio);
    _passwordController = TextEditingController(text: widget.user.contrasena);
    _selectedDate = widget.user.dataNaixement;
    _esCuidadorPersonal = widget.user.esCuidadorPersonal;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    _passwordController.dispose();
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
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre y Apellidos'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Correo electrónico'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
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
                subtitle: Text(_esCuidadorPersonal ? 'Cuidador personal' : 'Cuidador professional'),
                trailing: Switch(
                  value: _esCuidadorPersonal,
                  onChanged: (bool newValue) {
                    setState(() {
                      _esCuidadorPersonal = newValue;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _saveProfile();
                    },
                    child: const Text('Guardar'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    try {
      // Obtener el ID del usuario autenticado
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;

        // Guardar los cambios en la instancia local del usuario
        setState(() {
          widget.user.nomCognoms = _nameController.text;
          widget.user.correu = _emailController.text;
          widget.user.descripcio = _descriptionController.text;
          widget.user.dataNaixement = _selectedDate;
          widget.user.contrasena = _passwordController.text;
          widget.user.esCuidadorPersonal = _esCuidadorPersonal;
        });

        // Actualizar la base de datos en Firestore
        await FirebaseFirestore.instance.collection('usuarios').doc(userId).update({
          'nomCognoms': widget.user.nomCognoms,
          'correu': widget.user.correu,
          'descripcio': widget.user.descripcio,
          'dataNaixement': widget.user.dataNaixement,
          'contrasena': widget.user.contrasena,
          'esCuidadorPersonal': widget.user.esCuidadorPersonal,
        });

        // Mostrar un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado correctamente')),
        );

        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Error al actualizar el perfil: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar el perfil')),
      );
    }
  }
}
