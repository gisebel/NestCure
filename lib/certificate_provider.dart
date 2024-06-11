import 'package:flutter/material.dart';

class Certificate {
  final String name;
  final String description;
  final String fileUrl;

  Certificate({
    required this.name,
    required this.description,
    required this.fileUrl,
  });
}

class CertificateProvider with ChangeNotifier {
  final List<Certificate> _certificates = [];

  List<Certificate> get certificates => _certificates;

  void addCertificate(Certificate certificate) {
    _certificates.add(certificate);
    notifyListeners();
  }
}
