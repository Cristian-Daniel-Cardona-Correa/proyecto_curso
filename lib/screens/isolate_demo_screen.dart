import 'dart:isolate';
import 'package:flutter/material.dart';
import '../services/heavy_task.dart';
import '../theme.dart';

/// Pantalla que demuestra la ejecución paralela en segundo plano mediante Isolates
/// en comparación directa con la ejecución en el hilo principal (UI thread).
class IsolateDemoScreen extends StatefulWidget {
  const IsolateDemoScreen({super.key});

  @override
  State<IsolateDemoScreen> createState() => _IsolateDemoScreenState();
}

class _IsolateDemoScreenState extends State<IsolateDemoScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _spinnerController;

  bool _isIsolateRunning = false;
  bool _isMainThreadRunning = false;

  int? _isolateResult;
  int? _isolateElapsedMs;

  int? _mainThreadResult;
  int? _mainThreadElapsedMs;

  Isolate? _activeIsolate;
  ReceivePort? _activeReceivePort;

  @override
  void initState() {
    super.initState();
    // Animación continua para evidenciar visualmente el congelamiento del hilo principal
    _spinnerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  /// Ejecuta la tarea en un Isolate secundario con memoria aislada.
  /// La interfaz permanece 100% fluida a 60 FPS mientras se procesa.
  Future<void> _runInIsolate() async {
    if (_isIsolateRunning || _isMainThreadRunning) return;

    setState(() {
      _isIsolateRunning = true;
      _isolateResult = null;
      _isolateElapsedMs = null;
    });

    debugPrint('[IsolateDemo] 1. Creando ReceivePort en el hilo principal...');
    final receivePort = ReceivePort();
    _activeReceivePort = receivePort;

    try {
      debugPrint('[IsolateDemo] 2. Spawning nuevo Isolate con Isolate.spawn()...');
      final isolate = await Isolate.spawn<SendPort>(
        isolateEntry,
        receivePort.sendPort,
        onError: receivePort.sendPort,
      );
      _activeIsolate = isolate;

      debugPrint('[IsolateDemo] 3. Esperando mensaje a través de receivePort.first...');
      final dynamic response = await receivePort.first;
      debugPrint('[IsolateDemo] 4. Mensaje recibido del Isolate: $response');

      if (mounted && response is Map<String, dynamic>) {
        setState(() {
          _isolateResult = response['result'] as int?;
          _isolateElapsedMs = response['elapsedMs'] as int?;
        });
      }
    } catch (e) {
      debugPrint('[IsolateDemo] Excepción en Isolate: $e');
    } finally {
      // Limpieza de recursos del Isolate
      debugPrint('[IsolateDemo] 5. Cerrando ReceivePort y finalizando Isolate.');
      receivePort.close();
      _activeIsolate?.kill(priority: Isolate.immediate);
      _activeIsolate = null;
      _activeReceivePort = null;

      if (mounted) {
        setState(() {
          _isIsolateRunning = false;
        });
      }
    }
  }

  /// Ejecuta la tarea directamente en el hilo de la interfaz de usuario (Main UI Thread).
  /// Esto bloqueará el Event Loop, congelando la animación del spinner y los toques en pantalla.
  void _runOnMainThread() {
    if (_isIsolateRunning || _isMainThreadRunning) return;

    setState(() {
      _isMainThreadRunning = true;
      _mainThreadResult = null;
      _mainThreadElapsedMs = null;
    });

    debugPrint('[MainThreadDemo] 1. Bloqueando hilo principal con cálculo masivo...');

    // addPostFrameCallback asegura que el estado visual previo se pinte antes de congelar el motor
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final stopwatch = Stopwatch()..start();
      const int target = 500000000;
      final int result = heavySum(target);
      stopwatch.stop();

      debugPrint('[MainThreadDemo] 2. Cálculo en hilo principal terminado: ${stopwatch.elapsedMilliseconds} ms');

      if (mounted) {
        setState(() {
          _mainThreadResult = result;
          _mainThreadElapsedMs = stopwatch.elapsedMilliseconds;
          _isMainThreadRunning = false;
        });
      }
    });
  }

  /// Limpieza obligatoria de puertos e isolates activos al destruir la vista.
  @override
  void dispose() {
    _spinnerController.dispose();
    _activeReceivePort?.close();
    _activeIsolate?.kill(priority: Isolate.immediate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZerisColors.page,
      appBar: AppBar(
        title: Text(
          'Tarea Pesada (Isolate)',
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
            // Indicador visual de bloqueo del hilo
            Container(
              decoration: zerisPanelDecoration(),
              padding: const EdgeInsets.all(ZerisSpacing.md),
              child: Row(
                children: [
                  RotationTransition(
                    turns: _spinnerController,
                    child: Container(
                      width: 44,
                      height: 44,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: ZerisColors.panelBg,
                        shape: BoxShape.circle,
                        border: Border.all(color: ZerisColors.panelBorder),
                      ),
                      child: const CircularProgressIndicator(
                        strokeWidth: 3,
                        color: ZerisColors.primaryIndigo,
                      ),
                    ),
                  ),
                  const SizedBox(width: ZerisSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MONITOR DEL EVENT LOOP (UI THREAD)',
                          style: ZerisTypography.kicker(),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _isMainThreadRunning
                              ? '⚠️ HILO BLOQUEADO: La animación se detiene por completo.'
                              : (_isIsolateRunning
                                  ? '✨ HILO LIBRE: El Isolate corre en paralelo a 60 FPS.'
                                  : 'Animación activa continua. Observa si se detiene.'),
                          style: ZerisTypography.body(
                            color: _isMainThreadRunning
                                ? const Color(0xFFF87171)
                                : (_isIsolateRunning ? const Color(0xFF34D399) : ZerisColors.fg),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: ZerisSpacing.lg),

            // Botón 1: Isolate (Recomendado)
            Container(
              decoration: zerisCtaButtonDecoration(),
              child: ElevatedButton.icon(
                onPressed: (_isIsolateRunning || _isMainThreadRunning) ? null : _runInIsolate,
                icon: _isIsolateRunning
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: ZerisColors.buttonText),
                      )
                    : const Icon(Icons.memory, color: ZerisColors.buttonText),
                label: Text(
                  _isIsolateRunning ? 'PROCESANDO EN ISOLATE...' : 'EJECUTAR EN ISOLATE',
                  style: ZerisTypography.title(color: ZerisColors.buttonText),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: ZerisSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ZerisRadius.lg),
                  ),
                ),
              ),
            ),

            const SizedBox(height: ZerisSpacing.md),

            // Botón 2: Hilo Principal (Para comparar el bloqueo)
            OutlinedButton.icon(
              onPressed: (_isIsolateRunning || _isMainThreadRunning) ? null : _runOnMainThread,
              icon: _isMainThreadRunning
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFEF4444)),
                    )
                  : const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444)),
              label: Text(
                _isMainThreadRunning ? 'BLOQUEANDO UI THREAD...' : 'EJECUTAR EN HILO PRINCIPAL',
                style: ZerisTypography.title(color: const Color(0xFFFCA5A5)),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFEF4444), width: 1.2),
                backgroundColor: const Color(0x1AEF4444),
                padding: const EdgeInsets.symmetric(vertical: ZerisSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ZerisRadius.lg),
                ),
              ),
            ),

            const SizedBox(height: ZerisSpacing.lg),

            // Panel Comparativo de Resultados
            Container(
              decoration: zerisPanelDecoration(),
              padding: const EdgeInsets.all(ZerisSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RESULTADOS COMPARATIVOS',
                    style: ZerisTypography.kicker(),
                  ),
                  const SizedBox(height: ZerisSpacing.sm),
                  Text(
                    'Cálculo de suma acumulativa pesada (500,000,000 iteraciones):',
                    style: ZerisTypography.body(color: ZerisColors.uiMuted),
                  ),
                  const Divider(color: ZerisColors.panelBorder, height: ZerisSpacing.lg),

                  // Métrica Isolate
                  _buildResultCard(
                    title: 'Isolate en Segundo Plano',
                    icon: Icons.check_circle_outline,
                    iconColor: const Color(0xFF10B981),
                    elapsedMs: _isolateElapsedMs,
                    result: _isolateResult,
                    statusText: 'No bloquea la UI ni causa freeze.',
                  ),

                  const SizedBox(height: ZerisSpacing.md),

                  // Métrica Hilo Principal
                  _buildResultCard(
                    title: 'Hilo Principal (UI Thread)',
                    icon: Icons.cancel_outlined,
                    iconColor: const Color(0xFFEF4444),
                    elapsedMs: _mainThreadElapsedMs,
                    result: _mainThreadResult,
                    statusText: 'Congela la pantalla y detiene animaciones.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required int? elapsedMs,
    required int? result,
    required String statusText,
  }) {
    return Container(
      padding: const EdgeInsets.all(ZerisSpacing.md),
      decoration: BoxDecoration(
        color: ZerisColors.panelBg,
        borderRadius: BorderRadius.circular(ZerisRadius.md),
        border: Border.all(color: ZerisColors.panelBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: ZerisSpacing.xs),
              Text(title, style: ZerisTypography.title()),
              const Spacer(),
              if (elapsedMs != null)
                Text(
                  '$elapsedMs ms',
                  style: ZerisTypography.headline(color: ZerisColors.kicker),
                )
              else
                Text(
                  'Pendiente',
                  style: ZerisTypography.label(color: ZerisColors.uiMuted),
                ),
            ],
          ),
          const SizedBox(height: ZerisSpacing.xs),
          Text(
            result != null ? 'Resultado: $result' : 'Presiona el botón para procesar.',
            style: ZerisTypography.body(color: ZerisColors.uiMuted),
          ),
          const SizedBox(height: 2),
          Text(
            statusText,
            style: ZerisTypography.label(color: iconColor),
          ),
        ],
      ),
    );
  }
}
