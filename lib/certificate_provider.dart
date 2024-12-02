import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Certificate {
  final String name;
  final String description;
  final String fileUrl;
  final DateTime date; 

  Certificate({
    required this.name,
    required this.description,
    required this.fileUrl,
    required this.date,
  });

  factory Certificate.fromMap(Map<String, dynamic> data) {
    return Certificate(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      fileUrl: data['fileUrl'] ?? '',
      date: data['date'] is Timestamp
          ? (data['date'] as Timestamp).toDate()
          : DateTime.parse(data['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'fileUrl': fileUrl,
      'date': date,
    };
  }
}

class CertificateProvider with ChangeNotifier {
  final List<Certificate> _certificates = [];

  List<Certificate> get certificates => _certificates;

  void addCertificate(Certificate certificate) {
    _certificates.add(certificate);
    notifyListeners();
  }

  void removeCertificate(Certificate certificate) {
    _certificates.remove(certificate);
    notifyListeners();
  }
}