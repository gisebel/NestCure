/*import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nestcure/sign_in.dart';  // Asegúrate de importar el archivo correcto

// Mock de FirebaseAuth
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// Mock de UserCredential
class MockUserCredential extends Mock implements UserCredential {}

// Mock de User
class MockUser extends Mock implements User {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
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

    // Simular que el botón de 'Crear' es presionado
    await tester.tap(find.text('Crear'));

    // Simulamos el comportamiento de Firebase Auth
    when(mockFirebaseAuth.createUserWithEmailAndPassword(
      email: 'test@example.com',
      password: 'Password123',
    )).thenAnswer((_) async {
      // Configuramos el mock de User
      when(mockUser.uid).thenReturn('12345');
      when(mockUser.email).thenReturn('test@example.com');

      // Configuramos el mock de UserCredential
      when(mockUserCredential.user).thenReturn(mockUser);

      // Retornamos el mock de UserCredential
      return Future.value(mockUserCredential);  // Asegúrate de devolver Future.value
    });

    // Esperar a que la animación o el renderizado termine
    await tester.pumpAndSettle();

    // Verificar si el flujo funciona como se espera
    expect(find.text('Usuario registrado correctamente'), findsOneWidget);
  });
}*/