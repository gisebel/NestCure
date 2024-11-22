import 'package:cloud_firestore/cloud_firestore.dart';

class Activitat {
  final String id;
  final String title;
  final String description;
  final int hours;
  final DateTime date;
  final String type;
  final String dependantName;

  Activitat({
    required this.id,
    required this.title,
    required this.description,
    required this.hours,
    required this.date,
    required this.type,
    required this.dependantName,
  });

  factory Activitat.fromMap(Map<String, dynamic> data) {
    return Activitat(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      hours: data['hours'] ?? 0,
      date: data['date'] is Timestamp
          ? (data['date'] as Timestamp).toDate()
          : DateTime.parse(data['date']),
      type: data['type'] ?? '',
      dependantName: data['dependantName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'hours': hours,
      'date': Timestamp.fromDate(date),
      'type': type,
      'dependantName': dependantName,
    };
  }
}
