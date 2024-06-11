import 'usuari.dart';

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
      activitats: {});

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
        activitats: {});
  }

  Usuari get usuari => _usuari;
}
