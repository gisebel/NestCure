import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nestcure/login.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {
  @override
  String get uid => 'eljJNPZ43nYFffWzB4tx6CstLV72';
  @override
  bool get emailVerified => true;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockFirebaseAuth mockFirebaseAuth;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
  });

  testWidgets('Test successful login', (WidgetTester tester) async {
    final mockUser = MockUser();
    final mockUserCredential = MockUserCredential();
    when(mockUserCredential.user).thenReturn(mockUser);

    when(mockFirebaseAuth.signInWithEmailAndPassword(
      email: 'gisela.beltran@estudiantat.upc.edu',
      password: '1234567',
    )).thenAnswer((_) async => mockUserCredential);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: Builder(builder: (BuildContext context) {
        return LoginPage();
      })),
    ));
  });
}