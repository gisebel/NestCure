import 'package:flutter/material.dart';
import 'user.dart';

class UserProvider extends ChangeNotifier {
  Usuari? _usuari;

  Usuari? get usuari => _usuari;

  UserProvider();

  void setUsuari(Usuari usuari) {
    _usuari = usuari;
    notifyListeners();
  }

  void logout() {
    _usuari = null;
    notifyListeners();
  }
}
