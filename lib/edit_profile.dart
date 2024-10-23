import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nestcure/user.dart';

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
      appBar: AppBar(
        title: const Text('Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Añadimos scroll si el contenido es largo
          child: Column(
            children: [
              // Campo para editar el nombre
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nom i cognoms'),
              ),
              const SizedBox(height: 16.0),
              
              // Campo para editar el correo
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Correu'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16.0),
              
              // Campo para editar la descripción
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripció'),
                maxLines: 3,
              ),
              const SizedBox(height: 16.0),

              // Campo para editar la fecha de nacimiento
              ListTile(
                title: const Text('Data de Naixement'),
                subtitle: Text(DateFormat('dd-MM-yyyy').format(_selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16.0),

              // Campo para editar esCuidadorPersonal
              ListTile(
                title: const Text('Tipus de cuidadora'),
                subtitle: Text(_esCuidadorPersonal ? 'Cuidadora Personal' : 'Cuidadora Professional'),
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

              // Campo para editar la contraseña
              TextField(
                controller: _passwordController,
                obscureText: !_passwordVisible, // Control de visibilidad de la contraseña
                decoration: InputDecoration(
                  labelText: 'Contrasenya',
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
              
              // Botones de guardar o cancelar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _saveProfile();  // Lógica para guardar los cambios
                    },
                    child: const Text('Guardar'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();  // Cerrar pantalla sin guardar
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

  void _saveProfile() {
    // Guardar los cambios en la instancia del usuario
    setState(() {
      widget.user.nomCognoms = _nameController.text;
      widget.user.correu = _emailController.text;
      widget.user.descripcio = _descriptionController.text;
      widget.user.dataNaixement = _selectedDate;
      widget.user.contrasena = _passwordController.text;  // Actualizamos la contraseña
      widget.user.esCuidadorPersonal = _esCuidadorPersonal;  // Actualizamos el tipo de cuidador
    });

    Navigator.of(context).pop();  // Volver a la pantalla anterior
  }
}