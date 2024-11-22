import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nestcure/user.dart';

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
    activitats: [],
  );

  LoggedUsuari._internal();

  factory LoggedUsuari() => _instance;

  Usuari get usuari => _usuari;

  Future<void> loginWithFirebase() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No hay ningún usuario autenticado.");
        return;
      }

      print("Usuario autenticado: ${user.uid}");

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        print("Documento del usuario encontrado en Firestore.");
        print("Datos recuperados: ${userDoc.data()}");
        _usuari = Usuari.fromFirestore(userDoc.data() as Map<String, dynamic>);
        print("Usuario cargado correctamente: $_usuari");
      } else {
        print("El documento del usuario no existe en Firestore.");
      }
    } catch (e) {
      print("Error al obtener los datos del usuario desde Firestore: $e");
    }
  }

  Stream<Usuari> get userStream async* {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      yield* FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists) {
          return Usuari.fromFirestore(snapshot.data() as Map<String, dynamic>);
        }
        return Usuari(
          nomCognoms: '',
          dataNaixement: DateTime.now(),
          correu: '',
          contrasena: '',
          esCuidadorPersonal: false,
          descripcio: '',
          fotoPerfil: '',
          personesDependents: [],
          activitats: [],
        );
      });
    }
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
      activitats: [],
    );
  }

  Future<void> deleteAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .delete();
        await user.delete();
        print("Cuenta eliminada exitosamente.");
      }
    } catch (e) {
      print("Error al eliminar la cuenta: $e");
    }
  }
}