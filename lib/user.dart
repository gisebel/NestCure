import 'package:nestcure/activitat.dart';
import 'package:nestcure/persona_dependent.dart';
import 'package:nestcure/certificate_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Usuari {
  String nomCognoms;
  DateTime dataNaixement;
  String correu;
  bool esCuidadorPersonal;
  String descripcio;
  String fotoPerfil;
  List<PersonaDependent> personesDependents;
  List<Activitat> activitats;
  Map<String, int> tests;
  List<Certificate> certificats;
  String genero;
  String telefono;
  String direccion;

  Usuari({
    required this.nomCognoms,
    required this.dataNaixement,
    required this.correu,
    required this.esCuidadorPersonal,
    required this.descripcio,
    required this.fotoPerfil,
    required this.personesDependents,
    required this.activitats,
    required this.certificats,
    required Map<String, int>? tests,
    required this.genero,
    required this.telefono,
    required this.direccion,
  }) : tests = tests ?? {
      'basicAttentionKnowledgeTest': 0,
      'intermediateHealthKnowledgeTest': 0,
      'advancedHealthKnowledgeTest': 0,
      'basicCommunicationSkillsTest': 0,
      'intermediateAttentionKnowledgeTest': 0,
      'advancedAttentionKnowledgeTest': 0,
      'basicPracticalSkillsTest': 0,
      'intermediateCommunicationSkillsTest': 0,
      'advancedCommunicationSkillsTest': 0,
      'intermediatePracticalSkillsTest': 0,
      'advancedPracticalSkillsTest': 0,
      'basicHealthKnowledgeTest': 0,
  };

  @override
  String toString() {
    return 'Usuari(nomCognoms: $nomCognoms, dataNaixement: $dataNaixement, correu: $correu, descripcio: $descripcio, genero: $genero, telefono: $telefono, direccion: $direccion)';
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

    var tests = (firestoreData['tests'] is Map<String, dynamic>)
        ? Map<String, int>.from(firestoreData['tests'])
        : {
            'basicAttentionKnowledgeTest': 0,
            'intermediateHealthKnowledgeTest': 0,
            'advancedHealthKnowledgeTest': 0,
            'basicCommunicationSkillsTest': 0,
            'intermediateAttentionKnowledgeTest': 0,
            'advancedAttentionKnowledgeTest': 0,
            'basicPracticalSkillsTest': 0,
            'intermediateCommunicationSkillsTest': 0,
            'advancedCommunicationSkillsTest': 0,
            'intermediatePracticalSkillsTest': 0,
            'advancedPracticalSkillsTest': 0,
            'basicHealthKnowledgeTest': 0,
          };

    var certificats = (firestoreData['certificats'] is List<dynamic>)
        ? (firestoreData['certificats'] as List<dynamic>)
            .map((e) => Certificate.fromMap(e))
            .toList()
        : <Certificate>[];

    var dataNaixement = firestoreData['dataNaixement'];
    DateTime birthDate;
    if (dataNaixement is Timestamp) {
      birthDate = dataNaixement.toDate();
    } else if (dataNaixement is String) {
      birthDate = DateTime.parse(dataNaixement);
    } else {
      birthDate = DateTime.now();
    }

    return Usuari(
      nomCognoms: firestoreData['nomCognoms'] ?? '',
      dataNaixement: birthDate,
      correu: firestoreData['correu'] ?? '',
      esCuidadorPersonal: firestoreData['esCuidadorPersonal'] ?? false,
      descripcio: firestoreData['descripcio'] ?? '',
      fotoPerfil: firestoreData['fotoPerfil'] ?? '',
      personesDependents: personesDependents,
      activitats: activitats,
      tests: tests,
      certificats: certificats,
      genero: firestoreData['genero'] ?? 'Mujer',
      telefono: firestoreData['telefono'] ?? '',
      direccion: firestoreData['direccion'] ?? '',
    );
  }
}