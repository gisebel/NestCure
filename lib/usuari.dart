import 'package:nestcure/persona_dependent.dart';

class Usuari {
  final String nomCognoms;
  final DateTime dataNaixement;
  final String correu;
  final String contrasena;
  final bool esCuidadorPersonal;
  final String descripcio;
  final String fotoPerfil = 'images/avatar.png';
  final List<PersonaDependent> personesDependents;

  Usuari({
    required this.nomCognoms,
    required this.dataNaixement,
    required this.correu,
    required this.contrasena,
    required this.esCuidadorPersonal,
    required this.descripcio,
    required this.personesDependents,
  });
  // Verificar si un correo electrónico ya está registrado
  static bool isEmailRegistered(String email, List<Usuari> usuarios) {
    return usuarios.any((usuari) => usuari.correu == email);
  }
}

// Usuario hardcodeado
final Usuari usuariHardcodeado = Usuari(
  nomCognoms: 'Gisela Beltran',
  dataNaixement: DateTime(2002, 5, 31),
  correu: 'gisela@suara.com',
  contrasena: '12345',
  esCuidadorPersonal: false,
  descripcio: 'Usuari hardcodeado',
  personesDependents: [
    PersonaDependent(
      nom: 'Paco Martinez',
      descripcio: 'Persona amb discapacitat física',
      depenDe: 'Gisela Beltran',
    ),
    PersonaDependent(
      nom: 'Carme Diaz',
      descripcio: 'Necessita més atenció per les matinades',
      depenDe: 'Gisela Beltran',
    ),
  ],
);
