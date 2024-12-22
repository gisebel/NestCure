import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Certificate {
  final String title;
  final String description;
  final String fileName;
  final DateTime date; 

  Certificate({
    required this.title,
    required this.description,
    required this.fileName,
    required this.date,
  });

  factory Certificate.fromMap(Map<String, dynamic> data) {
    return Certificate(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      fileName: data['fileName'] ?? '',
      date: data['date'] is Timestamp
          ? (data['date'] as Timestamp).toDate()
          : DateTime.parse(data['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'fileName': fileName,
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