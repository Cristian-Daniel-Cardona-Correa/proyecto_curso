import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_curso/main.dart';
import 'package:proyecto_curso/views/dashboard_view.dart';
import 'package:proyecto_curso/widgets/dashboard_card.dart';

void main() {
  testWidgets('Verificación inicial de TallerDatosAbiertosApp y Dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const TallerDatosAbiertosApp());
    await tester.pumpAndSettle();

    // Verificar presencia del Dashboard
    expect(find.byType(DashboardView), findsOneWidget);
    expect(find.text('COLOMBIA ABIERTA'), findsOneWidget);
    expect(find.byType(DashboardCard), findsNWidgets(4));
  });
}
