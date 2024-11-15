import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';
import 'package:nestcure/activitat.dart';
import 'package:nestcure/persona_dependent.dart';

class LoggedUsuari {
  static final LoggedUsuari _instance = LoggedUsuari._internal();

  Usuari _usuari = Usuari(
    nomCognoms: '',
    dataNaixement: DateTime.now(),
    correu: '',
    contrasena: '',
    esCuidadorPersonal: false,
    descripcio: '',
    fotoPerfil: '',
    personesDependents: [],
    activitats: {},
  );

  LoggedUsuari._internal();

  factory LoggedUsuari() {
    return _instance;
  }

  Future<void> loginWithFirebase() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Usuarios')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

          _usuari = Usuari(
            nomCognoms: data['nomCognoms'] ?? '',
            dataNaixement: (data['dataNaixement'] as Timestamp).toDate(),
            correu: data['correu'] ?? '',
            contrasena: '',
            esCuidadorPersonal: data['esCuidadorPersonal'] ?? false,
            descripcio: data['descripcio'] ?? '',
            personesDependents: List<PersonaDependent>.from(
              data['personesDependents']?.map((x) => PersonaDependent.fromMap(x)) ?? [],
            ),
            activitats: Map<String, List<Activitat>>.from(
              data['activitats'] ?? {},
            ),
            fotoPerfil: data['fotoPerfil'] ?? 'images/avatar_predeterminado.png',
          );
        }
      }
    } catch (e) {
      print("Error al obtener los datos del usuario desde Firestore: $e");
    }
  }

  // Escuchar cambios en los datos del usuario en tiempo real
  Stream<Usuari> get userStream {
    return FirebaseAuth.instance.authStateChanges().asyncMap((user) async {
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Usuarios')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

          _usuari = Usuari(
            nomCognoms: data['nomCognoms'] ?? '',
            dataNaixement: (data['dataNaixement'] as Timestamp).toDate(),
            correu: data['correu'] ?? '',
            contrasena: '',
            esCuidadorPersonal: data['esCuidadorPersonal'] ?? false,
            descripcio: data['descripcio'] ?? '',
            personesDependents: List<PersonaDependent>.from(
              data['personesDependents']?.map((x) => PersonaDependent.fromMap(x)) ?? [],
            ),
            activitats: Map<String, List<Activitat>>.from(
              data['activitats'] ?? {},
            ),
            fotoPerfil: data['fotoPerfil'] ?? 'images/avatar_predeterminado.png',
          );
        }
      }
      return _usuari;
    });
  }

  void logout() {
    _usuari = Usuari(
      nomCognoms: '',
      dataNaixement: DateTime.now(),
      correu: '',
      contrasena: '',
      esCuidadorPersonal: false,
      descripcio: '',
      fotoPerfil: '',
      personesDependents: [],
      activitats: {},
    );
  }

  Usuari get usuari => _usuari;

  // Método para eliminar la cuenta del usuario
  Future<void> deleteAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Eliminar datos del usuario en Firestore
        await FirebaseFirestore.instance
            .collection('Usuarios')
            .doc(user.uid)
            .delete();

        // Eliminar el usuario de Firebase Auth
        await user.delete();
        print("Cuenta eliminada exitosamente.");
      }
    } catch (e) {
      print("Error al eliminar la cuenta: $e");
    }
  }
}