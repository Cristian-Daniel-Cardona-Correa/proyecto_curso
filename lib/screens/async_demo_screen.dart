import 'package:flutter/material.dart';
import '../services/fake_service.dart';
import '../theme.dart';

/// Estados posibles durante la consulta asíncrona de datos.
enum LoadingState {
  idle,
  loading,
  success,
  error,
}

/// Pantalla que demuestra el ciclo de vida y manejo de estados asíncronos
/// mediante Future, async, await y bloques try/catch/finally sin bloquear la UI.
class AsyncDemoScreen extends StatefulWidget {
  const AsyncDemoScreen({super.key});

  @override
  State<AsyncDemoScreen> createState() => _AsyncDemoScreenState();
}

class _AsyncDemoScreenState extends State<AsyncDemoScreen> {
  final FakeService _fakeService = FakeService();
  LoadingState _loadingState = LoadingState.idle;
  Map<String, dynamic>? _workoutData;
  String? _errorMessage;

  /// Ejecuta la consulta asíncrona demostrando el flujo de ejecución no bloqueante.
  Future<void> _fetchData({bool fail = false}) async {
    // 1. Antes del await: Se actualiza el estado a 'loading' de inmediato
    debugPrint('[AsyncDemoScreen] 1. Antes del await: Iniciando solicitud (fail=$fail)');
    setState(() {
      _loadingState = LoadingState.loading;
      _errorMessage = null;
    });

    try {
      // 2. Ejecución asíncrona: El hilo principal queda libre para atender gestos y animaciones
      final data = await _fakeService.fetchWorkoutData(fail: fail);

      // Si el widget sigue montado, actualizamos con los datos recibidos
      if (mounted) {
        setState(() {
          _workoutData = data;
          _loadingState = LoadingState.success;
        });
      }
      debugPrint('[AsyncDemoScreen] 2. Después del await: Datos recibidos con éxito en la UI');
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
          _loadingState = LoadingState.error;
        });
      }
      debugPrint('[AsyncDemoScreen] 2. Después del await (Catch): Excepción capturada -> $e');
    } finally {
      // 3. Bloque finally: Garantiza la ejecución de limpieza independientemente del resultado
      debugPrint('[AsyncDemoScreen] 3. Bloque finally: Ciclo de consulta completado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZerisColors.page,
      appBar: AppBar(
        title: Text(
          'Demo Async (Future)',
          style: ZerisTypography.headline(),
        ),
        centerTitle: true,
        backgroundColor: ZerisColors.topbarBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: ZerisColors.topbarBorder,
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ZerisSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Panel de información conceptual
            Container(
              decoration: zerisPanelDecoration(),
              padding: const EdgeInsets.all(ZerisSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FLUJO ASÍNCRONO NO BLOQUEANTE',
                    style: ZerisTypography.kicker(),
                  ),
                  const SizedBox(height: ZerisSpacing.xs),
                  Text(
                    'Las peticiones con async/await suspenden la función sin congelar el hilo '
                    'principal de la interfaz, permitiendo mantener la interactividad mientras '
                    'se espera la resolución del Future.',
                    style: ZerisTypography.body(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: ZerisSpacing.lg),

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: zerisCtaButtonDecoration(),
                    child: ElevatedButton(
                      onPressed: _loadingState == LoadingState.loading
                          ? null
                          : () => _fetchData(fail: false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        disabledBackgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: ZerisSpacing.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ZerisRadius.lg),
                        ),
                      ),
                      child: Text(
                        'CONSULTAR DATOS',
                        style: ZerisTypography.title(color: ZerisColors.buttonText),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: ZerisSpacing.md),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _loadingState == LoadingState.loading
                        ? null
                        : () => _fetchData(fail: true),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFEF4444), width: 1.2),
                      backgroundColor: const Color(0x1AEF4444),
                      padding: const EdgeInsets.symmetric(vertical: ZerisSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ZerisRadius.lg),
                      ),
                    ),
                    child: Text(
                      'SIMULAR ERROR',
                      style: ZerisTypography.title(color: const Color(0xFFFCA5A5)),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: ZerisSpacing.lg),

            // Renderizado condicional según el estado de carga
            _buildStateWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildStateWidget() {
    switch (_loadingState) {
      case LoadingState.idle:
        return Container(
          decoration: zerisPanelDecoration(),
          padding: const EdgeInsets.all(ZerisSpacing.lg),
          child: Column(
            children: [
              const Icon(
                Icons.cloud_download_outlined,
                color: ZerisColors.uiMuted,
                size: 48,
              ),
              const SizedBox(height: ZerisSpacing.sm),
              Text(
                'LISTO PARA CONSULTAR',
                style: ZerisTypography.kicker(color: ZerisColors.uiMuted),
              ),
              const SizedBox(height: ZerisSpacing.xs),
              Text(
                'Presiona "Consultar datos" para simular una petición exitosa o '
                '"Simular error" para comprobar el control con try/catch.',
                textAlign: TextAlign.center,
                style: ZerisTypography.body(color: ZerisColors.uiMuted),
              ),
            ],
          ),
        );

      case LoadingState.loading:
        return Container(
          decoration: zerisPanelDecoration(),
          padding: const EdgeInsets.all(ZerisSpacing.xl),
          child: Column(
            children: [
              const CircularProgressIndicator(
                strokeWidth: 3,
                color: ZerisColors.primaryIndigo,
              ),
              const SizedBox(height: ZerisSpacing.md),
              Text(
                'SINCRONIZANDO CON ZERIS...',
                style: ZerisTypography.kicker(),
              ),
              const SizedBox(height: ZerisSpacing.xs),
              Text(
                'Cargando datos de entrenamiento en segundo plano...',
                style: ZerisTypography.body(),
              ),
            ],
          ),
        );

      case LoadingState.success:
        final data = _workoutData!;
        return Container(
          decoration: zerisPanelDecoration(),
          padding: const EdgeInsets.all(ZerisSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SESIÓN ASIGNADA DE HOY',
                    style: ZerisTypography.kicker(),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0x3310B981),
                      borderRadius: BorderRadius.circular(ZerisRadius.sm),
                      border: Border.all(color: const Color(0x6610B981), width: 1),
                    ),
                    child: Text(
                      'ÉXITO 200 OK',
                      style: ZerisTypography.label(color: const Color(0xFF34D399)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: ZerisSpacing.sm),
              Text(
                data['routineName'] as String,
                style: ZerisTypography.headline(),
              ),
              const SizedBox(height: ZerisSpacing.xs),
              Text(
                data['phase'] as String,
                style: ZerisTypography.body(color: ZerisColors.kicker),
              ),
              const Divider(color: ZerisColors.panelBorder, height: ZerisSpacing.lg),
              _buildDataRow(Icons.timer_outlined, 'Duración estimada', '${data['durationMinutes']} min'),
              const SizedBox(height: ZerisSpacing.xs),
              _buildDataRow(Icons.fitness_center_outlined, 'Series totales', '${data['completedSets']} series'),
              const SizedBox(height: ZerisSpacing.xs),
              _buildDataRow(Icons.local_fire_department_outlined, 'Gasto calórico', '${data['estimatedCalories']} kcal'),
              const Divider(color: ZerisColors.panelBorder, height: ZerisSpacing.lg),
              Text(
                'INDICACIÓN DEL COACH',
                style: ZerisTypography.kicker(),
              ),
              const SizedBox(height: ZerisSpacing.xs),
              Text(
                data['coachNotes'] as String,
                style: ZerisTypography.body(),
              ),
            ],
          ),
        );

      case LoadingState.error:
        return Container(
          decoration: zerisPanelDecoration(
            color: const Color(0x26EF4444),
          ),
          padding: const EdgeInsets.all(ZerisSpacing.lg),
          child: Column(
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFFEF4444),
                size: 44,
              ),
              const SizedBox(height: ZerisSpacing.sm),
              Text(
                'ERROR DE SINCRONIZACIÓN',
                style: ZerisTypography.kicker(color: const Color(0xFFF87171)),
              ),
              const SizedBox(height: ZerisSpacing.xs),
              Text(
                _errorMessage ?? 'Ocurrió un error inesperado al procesar la solicitud.',
                textAlign: TextAlign.center,
                style: ZerisTypography.body(color: ZerisColors.fgStrong),
              ),
              const SizedBox(height: ZerisSpacing.md),
              OutlinedButton.icon(
                onPressed: () => _fetchData(fail: false),
                icon: const Icon(Icons.refresh, size: 18, color: ZerisColors.fgStrong),
                label: Text(
                  'REINTENTAR',
                  style: ZerisTypography.title(color: ZerisColors.fgStrong),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: ZerisColors.panelBorder),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ZerisRadius.md),
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildDataRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: ZerisColors.kicker, size: 18),
        const SizedBox(width: ZerisSpacing.sm),
        Text(label, style: ZerisTypography.body(color: ZerisColors.uiMuted)),
        const Spacer(),
        Text(value, style: ZerisTypography.title()),
      ],
    );
  }
}
