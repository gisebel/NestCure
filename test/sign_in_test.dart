import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nestcure/sign_in.dart';  // Asegúrate de importar el archivo correcto

// Mock de FirebaseAuth
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// Mock de UserCredential
class MockUserCredential extends Mock implements UserCredential {}

// Mock de User
class MockUser extends Mock implements User {
  @override
  String get uid => '12345';

  @override
  String get email => 'test@example.com';
}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();

    // Configura el mock de UserCredential para que devuelva el mockUser
    when(mockUserCredential.user).thenReturn(mockUser);

    // Simulamos el comportamiento de Firebase Auth
    when(mockFirebaseAuth.createUserWithEmailAndPassword(
      email: 'test@example.com',
      password: 'Password123',
    )).thenAnswer((_) async => mockUserCredential);
  });

  testWidgets('Test de Registro de Usuario', (WidgetTester tester) async {
    // Cargar la página de registro
    await tester.pumpWidget(MaterialApp(home: RegisterPage()));

    // Ingresar datos en los campos de texto
    await tester.enterText(find.byType(TextField).at(0), 'Juan Perez');
    await tester.enterText(find.byType(TextField).at(1), '01-01-1990');
    await tester.enterText(find.byType(TextField).at(2), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(3), 'Password123');
    await tester.enterText(find.byType(TextField).at(4), 'Experiencia previa');
    await tester.enterText(find.byType(TextField).at(5), '1234567890');
    await tester.enterText(find.byType(TextField).at(6), 'Calle Falsa 123');

    // Esperar a que la animación termine y los widgets se rendericen completamente
    await tester.pumpAndSettle();

    // Asegurarse de que el botón de 'Crear' es visible antes de presionarlo
    await tester.scrollUntilVisible(find.text('Crear'), 50.0);
    await tester.tap(find.text('Crear'));

    // Esperar a que la animación o el renderizado termine
    await tester.pumpAndSettle();

    // Verificar si el flujo funciona como se espera
    expect(find.text('Usuario registrado correctamente'), findsOneWidget);
  });
}