import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nestcure/edit_profile.dart';
import 'package:nestcure/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}

class MockUser extends Mock implements User {
  @override
  String get uid => 'eljJNPZ43nYFffWzB4tx6CstLV72';
  @override
  bool get emailVerified => true;
}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockDocumentReference mockDocumentReference;
  late MockCollectionReference mockCollectionReference;
  late Usuari mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirebaseFirestore = MockFirebaseFirestore();
    mockDocumentReference = MockDocumentReference();
    mockCollectionReference = MockCollectionReference();

    mockUser = Usuari(
      correu: "gisela.beltran@estudiantat.upc.edu",
      dataNaixement: DateTime(2002, 5, 31),
      descripcio: "Marzo 2021 - Septiembre 2022 Cuidadora en la reisdencia Ballesol (Badalona)",
      direccion: "Avenida Cataluña 45, 08917 Badalona",
      esCuidadorPersonal: true,
      fotoPerfil: "",
      genero: "Mujer",
      nomCognoms: "Gisela Beltrán",
      telefono: "632529828",
      personesDependents: [],
      activitats: [],
      certificats: [],
      tests: {},
    );
  });

  testWidgets('Editar perfil carga correctamente los datos y permite guardarlos', (WidgetTester tester) async {
    when(mockFirebaseAuth.currentUser).thenReturn(MockUser());

    when(mockFirebaseFirestore.collection('usuarios')).thenReturn(mockCollectionReference);

    await tester.pumpWidget(
      MaterialApp(
        home: EditProfileScreen(user: mockUser),
      ),
    );

    expect(find.text("Gisela Beltrán"), findsOneWidget);
    expect(find.text("Marzo 2021 - Septiembre 2022 Cuidadora en la reisdencia Ballesol (Badalona)"), findsOneWidget);
    expect(find.text("632529828"), findsOneWidget);
    expect(find.text("Avenida Cataluña 45, 08917 Badalona"), findsOneWidget);
    expect(find.text("Cuidador personal"), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), "Gisela Actualizada");
    await tester.enterText(find.byType(TextField).at(1), "Descripción actualizada");
    await tester.enterText(find.byType(TextField).at(2), "123456789");
    await tester.enterText(find.byType(TextField).at(3), "Nueva dirección");

    await tester.tap(find.text("Guardar"));
    await tester.pumpAndSettle();

    verify(mockDocumentReference.update({
      'nomCognoms': "Gisela Actualizada",
      'descripcio': "Descripción actualizada",
      'telefono': "123456789",
      'direccion': "Nueva dirección",
      'dataNaixement': mockUser.dataNaixement,
      'esCuidadorPersonal': true,
    })).called(1);
  });
}