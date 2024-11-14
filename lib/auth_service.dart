import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nestcure/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> registerUser(Usuari user) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: user.correu,
        password: user.contrasena,
      );

      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'nomCognoms': user.nomCognoms,
        'dataNaixement': user.dataNaixement.toIso8601String(),
        'correu': user.correu,
        'esCuidadorPersonal': user.esCuidadorPersonal,
        'descripcio': user.descripcio,
        'fotoPerfil': user.fotoPerfil,
        'personesDependents': user.personesDependents.map((persona) => persona.toJson()).toList(),
        'activitats': user.activitats,
      });

      return null; 
    } catch (e) {
      return e.toString();
    }
  }
}