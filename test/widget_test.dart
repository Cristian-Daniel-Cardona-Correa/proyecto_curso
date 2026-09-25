import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_curso/main.dart';

void main() {
  testWidgets('Verificación de HomePage: Título inicial, nombre del estudiante y widgets Zeris', (WidgetTester tester) async {
    // Construir la app
    await tester.pumpWidget(const ZerisApp());

    // a) Verificar título inicial en el AppBar
    expect(find.text('Hola, Flutter'), findsOneWidget);

    // b) Verificar nombre centrado del estudiante
    expect(find.text('Cristian Daniel Cardona Correa'), findsOneWidget);

    // c) Verificar presencia del botón principal
    expect(find.text('CAMBIAR TÍTULO'), findsOneWidget);

    // e) Verificar Widget adicional 1: Panel con kicker
    expect(find.text('TU SERIE DE HOY, PRIMERO'), findsOneWidget);

    // f) Verificar Widget adicional 2: Lista de grupos musculares
    expect(find.text('Pecho'), findsOneWidget);
    expect(find.text('Espalda'), findsOneWidget);
    expect(find.text('Piernas'), findsOneWidget);
    expect(find.text('Hombros'), findsOneWidget);
  });

  testWidgets('Verificación de setState(): alternancia de título y visualización de SnackBar', (WidgetTester tester) async {
    await tester.pumpWidget(const ZerisApp());

    // Estado inicial
    expect(find.text('Hola, Flutter'), findsOneWidget);
    expect(find.text('¡Título cambiado!'), findsNothing);

    // Presionar el botón principal
    await tester.tap(find.text('CAMBIAR TÍTULO'));
    await tester.pump(); // Inicia animación y setState

    // Verificar que el título cambió en la AppBar
    expect(find.text('¡Título cambiado!'), findsOneWidget);
    expect(find.text('Hola, Flutter'), findsNothing);

    // Verificar que aparece el SnackBar
    expect(find.text('Título actualizado'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);

    // Presionar nuevamente para verificar que vuelve al estado inicial
    await tester.tap(find.text('CAMBIAR TÍTULO'));
    await tester.pump();

    expect(find.text('Hola, Flutter'), findsOneWidget);
    expect(find.text('¡Título cambiado!'), findsNothing);
  });
}
