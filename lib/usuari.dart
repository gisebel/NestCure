class Usuari {
  final String nomCognoms;
  final DateTime dataNaixement;
  final String correu;
  final String contrasena;
  final bool esCuidadorPersonal;
  final String descripcio;

  Usuari({
    required this.nomCognoms,
    required this.dataNaixement,
    required this.correu,
    required this.contrasena,
    required this.esCuidadorPersonal,
    required this.descripcio,
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
);
