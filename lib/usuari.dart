import 'package:nestcure/activitat.dart';
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
  final Map<String, List<Activitat>> activitats;

  Usuari({
    required this.nomCognoms,
    required this.dataNaixement,
    required this.correu,
    required this.contrasena,
    required this.esCuidadorPersonal,
    required this.descripcio,
    required this.personesDependents,
    required this.activitats,
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
        descripcio:
            'Amb problemes de desplaçament i necessita ajuda per les tasques de la casa',
        depenDe: 'Gisela Beltran',
      ),
      PersonaDependent(
        nom: 'Carme Diaz',
        descripcio: 'Necessita més atenció per les matinades',
        depenDe: 'Gisela Beltran',
      ),
    ],
    activitats: {
      'Paco Martinez': [
        Activitat(
          title: 'Companyia',
          description: 'Conversació i realització de jocs de taula',
          hours: 2,
          date: DateTime(2024, 6, 10),
          type: 'Suport emocional',
        ),
        Activitat(
            date: DateTime(2024, 6, 11),
            hours: 2,
            description: 'Neteja de la cuina i del dormitori',
            title: 'Neteja de la casa',
            type: 'Higiene de la llar'),
        Activitat(
          date: DateTime(2024, 6, 12),
          hours: 1,
          description:
              'Exercicis de fisioteràpia per millorar la movilitat de les cames',
          title: 'Fisioteràpia',
          type: 'Rehabilitació',
        ),
        Activitat(
          date: DateTime(2024, 6, 13),
          hours: 2,
          description:
              'Planificació i ajuda en la compra setmanal al supermercat dels productes necessàris.',
          title: 'Compra setmanal al supermercat',
          type: 'Compra',
        ),
      ],
      'Carme Diaz': [
        Activitat(
          date: DateTime(2024, 6, 10),
          hours: 2,
          description: 'Ajuda en la neteja diaria corporal i vestimenta',
          title: 'Higiene personal',
          type: 'Higiene personal',
        ),
        Activitat(
          date: DateTime(2024, 6, 11),
          hours: 1,
          description: 'Preparació de l\'esmorzar i rentat de roba',
          title: 'Tasques de la llar',
          type: 'Higiene de la llar',
        ),
        Activitat(
          date: DateTime(2024, 6, 12),
          hours: 1,
          description:
              'Gestió de la cita amb el metge i acompanyament a la consulta',
          title: 'Gestió mèdica',
          type: 'Gestió',
        ),
        Activitat(
          date: DateTime(2024, 6, 13),
          hours: 1,
          description: 'Acompanyar a passejar pel parc',
          title: 'Passeig diari',
          type: 'Activitat diària',
        ),
      ],
    });
