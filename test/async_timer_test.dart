import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_curso/screens/stopwatch_screen.dart';
import 'package:proyecto_curso/services/fake_service.dart';
import 'package:proyecto_curso/services/heavy_task.dart';

void main() {
  group('FakeService Tests', () {
    final service = FakeService();

    test('fetchWorkoutData(fail: false) retorna mapa con datos de entrenamiento', () async {
      final result = await service.fetchWorkoutData(fail: false);

      expect(result, isA<Map<String, dynamic>>());
      expect(result.containsKey('routineName'), isTrue);
      expect(result.containsKey('durationMinutes'), isTrue);
      expect(result['routineName'], equals('Empuje y Fuerza - Torso'));
    });

    test('fetchWorkoutData(fail: true) lanza excepción controlada', () async {
      expectLater(
        service.fetchWorkoutData(fail: true),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('HeavyTask Tests', () {
    test('heavySum calcula suma acumulativa con operaciones modulares', () {
      final res = heavySum(100);
      expect(res, isPositive);
    });
  });

  group('StopwatchScreen Widget Tests', () {
    testWidgets('Visualiza marcador inicial 00:00.00 y botón Iniciar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StopwatchScreen(),
        ),
      );

      // Verificación de estado inicial
      expect(find.text('00:00.00'), findsOneWidget);
      expect(find.text('INICIAR CRONÓMETRO'), findsOneWidget);
      expect(find.text('EN ESPERA'), findsOneWidget);
    });

    testWidgets('Iniciar avanza el tiempo con Timer.periodic y permite pausar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StopwatchScreen(),
        ),
      );

      // 1. Presionar Iniciar
      await tester.tap(find.text('INICIAR CRONÓMETRO'));
      await tester.pump();

      // 2. Simular paso de 500 ms en el temporizador
      await tester.pump(const Duration(milliseconds: 500));

      // 3. El tiempo no debe ser 00:00.00
      expect(find.text('00:00.00'), findsNothing);
      expect(find.text('PAUSAR'), findsOneWidget);
      expect(find.text('EN EJECUCIÓN'), findsOneWidget);

      // 4. Presionar Pausar
      await tester.tap(find.text('PAUSAR'));
      await tester.pump();

      expect(find.text('REANUDAR'), findsOneWidget);
      expect(find.text('REINICIAR'), findsOneWidget);
      expect(find.text('PAUSADO'), findsOneWidget);

      // 5. Presionar Reiniciar
      await tester.tap(find.text('REINICIAR'));
      await tester.pump();

      expect(find.text('00:00.00'), findsOneWidget);
      expect(find.text('INICIAR CRONÓMETRO'), findsOneWidget);
    });
  });
}
