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
  Map<String, List<Activitat>> activitats;

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

  factory Usuari.fromFirestore(Map<String, dynamic> firestoreData) {
    var personesDependentsData = firestoreData['personesDependents'] as List;
    List<PersonaDependent> personesDependents = personesDependentsData
        .map((personaData) => PersonaDependent(
              id: personaData['id'],
              nombre: personaData['nombre'],
              genero: personaData['genero'],
              fechaNacimiento: DateTime.parse(personaData['fechaNacimiento']),
              edad: personaData['edad'],
              telefono: personaData['telefono'],
              direccion: personaData['direccion'],
              peso: personaData['peso'],
              altura: personaData['altura'],
              descripcion: personaData['descripcion'],
            ))
        .toList();

    return Usuari(
      nomCognoms: firestoreData['nomCognoms'],
      dataNaixement: DateTime.parse(firestoreData['dataNaixement']),
      correu: firestoreData['correu'],
      contrasena: firestoreData['contrasena'],
      esCuidadorPersonal: firestoreData['esCuidadorPersonal'],
      descripcio: firestoreData['descripcio'],
      fotoPerfil: firestoreData['fotoPerfil'],
      personesDependents: personesDependents,
      activitats: Map<String, List<Activitat>>.from(firestoreData['activitats'] ?? {}),
    );
  }
}