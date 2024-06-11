import 'package:nestcure/login.dart';

class LoggedUsuari {
  static final LoggedUsuari _instance = LoggedUsuari._internal();

  Usuari _usuari = Usuari(
    nomCognoms: '',
    dataNaixement: DateTime.now(),
    correu: '',
    contrasena: '',
    esCuidadorPersonal: false,
    descripcio: '',
    personesDependents: [],
  );

  LoggedUsuari._internal();

  factory LoggedUsuari() {
    return _instance;
  }

  void login(Usuari usuari) {
    _usuari = usuari;
  }

  void logout() {
    _usuari = Usuari(
      nomCognoms: '',
      dataNaixement: DateTime.now(),
      correu: '',
      contrasena: '',
      esCuidadorPersonal: false,
      descripcio: '',
      personesDependents: [],
    );
  }

  Usuari get usuari => _usuari;
}
