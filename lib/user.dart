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

    var activitatsData = firestoreData['activitats'] as List;
    List<Activitat> activitat = activitatsData
      .map((activitatsData) => Activitat(
        id: activitatsData['id'],
        title: activitatsData['title'], 
        description: activitatsData['description'], 
        hours: activitatsData['hours'], 
        date: activitatsData['date'], 
        type: activitatsData['type']))
      .toList();

    return Usuari(
      nomCognoms: firestoreData['nomCognoms'] ?? '',
      dataNaixement: DateTime.parse(firestoreData['dataNaixement']),
      correu: firestoreData['correu'] ?? '',
      contrasena: firestoreData['contrasena'] ?? '',
      esCuidadorPersonal: firestoreData['esCuidadorPersonal'] ?? false,
      descripcio: firestoreData['descripcio'] ?? '',
      fotoPerfil: firestoreData['fotoPerfil'] ?? '',
      personesDependents: personesDependents,
      activitats: activitat,
    );
  }
}