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

  Future<void> loginWithFirebase(UserCredential userCredential) async {
  try {
    // Obtener datos adicionales del usuario desde Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('usuarios') // Asumiendo que los datos están en una colección llamada 'usuarios'
        .doc(userCredential.user?.uid)
        .get();

    if (userDoc.exists) {
      // Aquí asumimos que tu documento tiene una estructura que coincide con Usuari
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

      _usuari = Usuari(
        nomCognoms: data['nomCognoms'] ?? '',
        dataNaixement: (data['dataNaixement'] as Timestamp).toDate(),
        correu: data['correu'] ?? '',
        contrasena: '',  // La contraseña no se guarda en Firestore
        esCuidadorPersonal: data['esCuidadorPersonal'] ?? false,
        descripcio: data['descripcio'] ?? '',
        personesDependents: List<PersonaDependent>.from(
          data['personesDependents']?.map((x) => PersonaDependent.fromMap(x)) ?? [],
        ),
        activitats: Map<String, List<Activitat>>.from(
          data['activitats'] ?? {},
        ),
        fotoPerfil: data['fotoPerfil'] ?? 'images/avatar_predeterminado.png',  // Valor por defecto si no se encuentra 'fotoPerfil'
      );
    }
  } catch (e) {
    print("Error al obtener los datos del usuario desde Firestore: $e");
  }
}

  // Logout: Borra la información del usuario actual
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

  // Obtener el usuario actual
  Usuari get usuari => _usuari;
}
