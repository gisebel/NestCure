import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nestcure/activitat.dart';
import 'package:nestcure/llistat_activitats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockUser extends Mock implements User {
  @override
  String get uid => 'eljJNPZ43nYFffWzB4tx6CstLV72';
  @override
  bool get emailVerified => true;
}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {
  final Map<String, dynamic> _data;

  MockDocumentSnapshot(this._data);

  @override
  Map<String, dynamic>? data() {
    return _data;
  }
}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockCollectionReference mockCollectionReference;
  late MockDocumentReference mockDocumentReference;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirebaseFirestore = MockFirebaseFirestore();
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();

    when(mockFirebaseAuth.currentUser).thenReturn(MockUser());
    when(mockFirebaseFirestore.collection('usuarios')).thenReturn(mockCollectionReference);
    when(mockCollectionReference.doc('mockUserId')).thenReturn(mockDocumentReference);
  });

  testWidgets('Añadir una actividad se guarda correctamente y se muestra en la lista', (WidgetTester tester) async {
    final initialData = {
      'activitats': [],
    };

    final newActivity = {
      'id': 'bce07c1a-8740-4065-add8-8a2535423a36',
      'title': 'Compra semanal',
      'description': 'Ayuda para comprar fruta, verdura y pescado para la semana',
      'hours': 3,
      'date': Timestamp.fromDate(DateTime(2024, 12, 25)),
      'dependantName': 'Paco Martínez',
      'type': 'Compra',
    };

    when(mockDocumentReference.snapshots()).thenAnswer((_) =>
        Stream.value(MockDocumentSnapshot(initialData)));

    when(mockDocumentReference.update({
      'activitats': [newActivity],
    })).thenAnswer((_) async => {});

    await tester.pumpWidget(
      MaterialApp(
        home: LlistaActivitats(),
      ),
    );

    expect(find.text('No hay actividades registradas.'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add_circle_outline_rounded));
    await tester.pumpAndSettle();

    initialData['activitats'] = [newActivity];
    when(mockDocumentReference.snapshots()).thenAnswer((_) =>
        Stream.value(MockDocumentSnapshot(initialData)));
    await tester.pumpAndSettle();

    expect(find.text('Paco Martínez'), findsOneWidget);
    expect(find.text('Tiene 1 actividades'), findsOneWidget);
    expect(find.text('Compra semanal'), findsOneWidget);
  });
}