import 'package:nestcure/activitat.dart';
import 'package:nestcure/persona_dependent.dart';

class Usuari {
  String nomCognoms;
  DateTime dataNaixement;
  String correu;
  String contrasena;
  bool esCuidadorPersonal;
  String descripcio;
  String fotoPerfil;
  List<PersonaDependent> personesDependents;
  List<Activitat> activitats;

  Usuari({
    required this.nomCognoms,
    required this.dataNaixement,
    required this.correu,
    required this.contrasena,
    required this.esCuidadorPersonal,
    required this.descripcio,
    required this.fotoPerfil,
    required this.personesDependents,
    required this.activitats,
  });

  @override
  String toString() {
    return 'Usuari(nomCognoms: $nomCognoms, dataNaixement: $dataNaixement, correu: $correu, descripcio: $descripcio)';
  }

  factory Usuari.fromFirestore(Map<String, dynamic> firestoreData) {
    var personesDependents = (firestoreData['personesDependents'] is List<dynamic>)
        ? (firestoreData['personesDependents'] as List<dynamic>)
            .map((e) => PersonaDependent.fromMap(e))
            .toList()
        : <PersonaDependent>[];

    var activitats = (firestoreData['activitats'] is List<dynamic>)
        ? (firestoreData['activitats'] as List<dynamic>)
            .map((e) => Activitat.fromMap(e))
            .toList()
        : <Activitat>[];

    return Usuari(
      nomCognoms: firestoreData['nomCognoms'] ?? '',
      dataNaixement: DateTime.parse(firestoreData['dataNaixement']),
      correu: firestoreData['correu'] ?? '',
      contrasena: firestoreData['contrasena'] ?? '',
      esCuidadorPersonal: firestoreData['esCuidadorPersonal'] ?? false,
      descripcio: firestoreData['descripcio'] ?? '',
      fotoPerfil: firestoreData['fotoPerfil'] ?? '',
      personesDependents: personesDependents,
      activitats: activitats,
    );
  }
}