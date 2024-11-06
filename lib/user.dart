import 'package:nestcure/activitat.dart';
import 'package:nestcure/persona_dependent.dart';

class Usuari {
  String nomCognoms;
   DateTime dataNaixement;
  String correu;
  String contrasena;
  bool esCuidadorPersonal;
  String descripcio;
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

  static bool isEmailRegistered(String email, List<Usuari> users) {
    return users.any((usuari) => usuari.correu == email);
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
        nombre: 'Paco Martinez',
        descripcion: 'Con problemas de desplazamiento y necesita ayuda con las tareas del hogar',
        dependeDe: 'Gisela Beltran',
        genero: 'Home',
        fechaNacimiento: DateTime(1949, 7, 15),
        telefono: 123456789,
        direccion: 'Carrer de la Pau, 12',
        peso: 70.0,
        altura: 1.75,
        edad: 75,
      ),
      PersonaDependent(
        nombre: 'Carme Diaz',
        descripcion: 'Necessita más atención por las mañanas',
        dependeDe: 'Gisela Beltran',
        genero: 'Mujer',
        fechaNacimiento: DateTime(1950, 3, 12),
        telefono: 987654321,
        direccion: 'Carrer de la Llibertat, 34',
        peso: 65.0,
        altura: 1.65,
        edad: 74,
      ),
    ],
    activitats: {
      'Paco Martinez': [
        Activitat(
          title: 'Compañia',
          description: 'Conversación y realización de juegos de mesa',
          hours: 2,
          date: DateTime(2024, 6, 10),
          type: 'Soporte emocional',
        ),
        Activitat(
            date: DateTime(2024, 6, 11),
            hours: 2,
            description: 'Limpieza de la cocina y del dormitorio',
            title: 'Limpieza de la casa',
            type: 'Higiene del hogar'),
        Activitat(
          date: DateTime(2024, 6, 12),
          hours: 1,
          description:
              'Ejercicios de fisioterapia para mejorar la movilidad de las piernas',
          title: 'Fisioterapia',
          type: 'Rehabilitación',
        ),
        Activitat(
          date: DateTime(2024, 6, 13),
          hours: 2,
          description:
              'Planificación y ayuda en la compra semanal al supermercado de los productos necesarios.',
          title: 'Compra semanal al supermercado',
          type: 'Compra',
        ),
      ],
      'Carme Diaz': [
        Activitat(
          date: DateTime(2024, 6, 10),
          hours: 2,
          description: 'Ayuda con la limpieza diaria corporal y vestimenta',
          title: 'Higiene personal',
          type: 'Higiene personal',
        ),
        Activitat(
          date: DateTime(2024, 6, 11),
          hours: 1,
          description: 'Preparación del desayuno y lavadora de ropa sucia',
          title: 'Tareas del hogar',
          type: 'Higiene del hogar',
        ),
        Activitat(
          date: DateTime(2024, 6, 12),
          hours: 1,
          description:
              'Gestión de la cita con el médico y acompañamiento a la consulta',
          title: 'Gestión médica',
          type: 'Gestión',
        ),
        Activitat(
          date: DateTime(2024, 6, 13),
          hours: 1,
          description: 'Acompañar a pasear por el parque',
          title: 'Paseo diario',
          type: 'Actividat diaria',
        ),
      ],
    });