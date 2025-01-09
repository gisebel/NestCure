import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nestcure/add_persona_dependent.dart';
import 'package:provider/provider.dart';
import 'package:nestcure/user_provider.dart';

void main() {
  testWidgets('Test adding a dependent person to the form', (WidgetTester tester) async {
    // 1. Preparamos el widget dentro de un cambio de estado con Provider.
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (context) => UserProvider(),  // Asegúrate de que UserProvider esté listo para usarse.
          child: const AddPersonaDependentWidget(),
        ),
      ),
    );

    // 2. Completamos los campos de texto con datos.
    await tester.enterText(find.byType(TextField).at(0), 'Juan Perez');  // Nombre
    await tester.enterText(find.byType(TextField).at(1), '10-10-1990');  // Fecha de nacimiento
    await tester.enterText(find.byType(TextField).at(3), '987654321');   // Teléfono
    await tester.enterText(find.byType(TextField).at(4), 'Calle Ficticia 123');  // Dirección
    await tester.enterText(find.byType(TextField).at(5), '60');  // Peso
    await tester.enterText(find.byType(TextField).at(6), '1.70');  // Altura
    await tester.enterText(find.byType(TextField).at(7), '35');  // Edad
    await tester.enterText(find.byType(TextField).at(8), 'Paciente con diabetes');  // Descripción

    // 3. Hacemos tap en el botón "Guardar" para añadir a la persona dependiente.
    await tester.tap(find.widgetWithText(ElevatedButton, 'Guardar'));
    await tester.pump();  // Esperamos a que el widget se reconstruya.

    // 4. Verificamos si el método de agregar la persona dependiente ha sido llamado.
    // Aquí, como no tenemos un mock de Firestore o Firebase, lo que podemos verificar es que el formulario
    // haya sido procesado y, por ejemplo, que se haya mostrado un mensaje de éxito o que la vista haya cambiado.
    expect(find.text('Persona añadida correctamente'), findsOneWidget);  // Suponiendo que se muestra este mensaje tras añadir.
    
    // Si el test incluye una función de cambio de estado, puedes verificar que el estado se haya actualizado
    // o que el widget se haya reconstruido. Por ejemplo:
    expect(find.byType(AddPersonaDependentWidget), findsNothing);  // Si el widget se elimina o se redirige a otro.
  });
}
