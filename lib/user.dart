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
  Map<String, bool> tests;
  List<Certificate> certificats;

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
    required Map<String, bool>? tests,
  }) : tests = tests ?? {
      'basicAttentionKnowledgeTest': false,
      'intermediateHealthKnowledgeTest': false,
      'advancedHealthKnowledgeTest': false,
      'basicCommunicationSkillsTest': false,
      'intermediateAttentionKnowledgeTest': false,
      'advancedAttentionKnowledgeTest': false,
      'basicPracticalSkillsTest': false,
      'intermediateCommunicationSkillsTest': false,
      'advancedCommunicationSkillsTest': false,
      'intermediatePracticalSkillsTest': false,
      'advancedPracticalSkillsTest': false,
  };

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

    var tests = (firestoreData['tests'] is Map<String, dynamic>)
        ? Map<String, bool>.from(firestoreData['tests'])
        : {
            'basicAttentionKnowledgeTest': false,
            'intermediateHealthKnowledgeTest': false,
            'advancedHealthKnowledgeTest': false,
            'basicCommunicationSkillsTest': false,
            'intermediateAttentionKnowledgeTest': false,
            'advancedAttentionKnowledgeTest': false,
            'basicPracticalSkillsTest': false,
            'intermediateCommunicationSkillsTest': false,
            'advancedCommunicationSkillsTest': false,
            'intermediatePracticalSkillsTest': false,
            'advancedPracticalSkillsTest': false,
            'basicHealthKnowledgeTest': false,
          };

    var certificats = (firestoreData['certificats'] is List<dynamic>)
        ? (firestoreData['certificats'] as List<dynamic>)
            .map((e) => Certificate.fromMap(e))
            .toList()
        : <Certificate>[];

    // Aquí se agrega la verificación si 'dataNaixement' es un Timestamp
    var dataNaixement = firestoreData['dataNaixement'];
    DateTime birthDate;
    if (dataNaixement is Timestamp) {
      birthDate = dataNaixement.toDate();  // Convertir el Timestamp a DateTime
    } else if (dataNaixement is String) {
      birthDate = DateTime.parse(dataNaixement);  // Parsear la cadena a DateTime
    } else {
      birthDate = DateTime.now();  // Valor por defecto si no está presente
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
    );
  }
}