import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_curso/themes/app_theme.dart';
import 'package:proyecto_curso/views/dashboard_view.dart';
import 'package:proyecto_curso/widgets/dashboard_card.dart';

void main() {
  testWidgets('DashboardView renderiza encabezado, métricas y 4 cards Zeris', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const DashboardView(),
      ),
    );

    // Verificar branding y títulos
    expect(find.text('COLOMBIA ABIERTA'), findsOneWidget);
    expect(find.text('Explora el Patrimonio Nacional'), findsOneWidget);

    // Verificar que existen exactamente 4 DashboardCards
    expect(find.byType(DashboardCard), findsNWidgets(4));

    // Verificar títulos de los 4 endpoints
    expect(find.text('Departamentos'), findsOneWidget);
    expect(find.text('Presidentes'), findsOneWidget);
    expect(find.text('Atracciones Turísticas'), findsOneWidget);
    expect(find.text('Gastronomía Típica'), findsOneWidget);
  });
}
