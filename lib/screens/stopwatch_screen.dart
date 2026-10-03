import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

/// Pantalla de cronómetro deportivo de alta precisión para control de tiempos de descanso y series.
/// Utiliza la clase [Stopwatch] para medir el paso del tiempo real y [Timer.periodic]
/// para refrescar la interfaz de usuario cada 100 milisegundos sin desfases acumulativos.
class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  /// Inicia el cronómetro y activa el temporizador periódico a 100 ms.
  void _start() {
    _stopwatch.start();
    // Refresco de UI a 100 ms para centésimas de segundo (mm:ss.cs)
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted) {
        setState(() {});
      }
    });
    setState(() {});
  }

  /// Pausa el cronómetro y cancela el Timer para no consumir ciclos de CPU en reposo.
  void _pause() {
    _stopwatch.stop();
    _timer?.cancel();
    _timer = null;
    setState(() {});
  }

  /// Reanuda el cronómetro desde el tiempo acumulado.
  void _resume() {
    _start();
  }

  /// Reinicia el cronómetro a cero y cancela el Timer.
  void _reset() {
    _stopwatch.reset();
    _timer?.cancel();
    _timer = null;
    setState(() {});
  }

  /// Limpieza obligatoria de recursos al salir de la pantalla para evitar fugas de memoria (memory leaks).
  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  /// Formatea los milisegundos en formato de cronómetro deportivo mm:ss.cs
  String _formattedTime() {
    final int ms = _stopwatch.elapsedMilliseconds;
    final int minutes = ms ~/ 60000;
    final int seconds = (ms % 60000) ~/ 1000;
    final int centiseconds = (ms % 1000) ~/ 10;

    final String minStr = minutes.toString().padLeft(2, '0');
    final String secStr = seconds.toString().padLeft(2, '0');
    final String csStr = centiseconds.toString().padLeft(2, '0');

    return '$minStr:$secStr.$csStr';
  }

  @override
  Widget build(BuildContext context) {
    final bool isRunning = _stopwatch.isRunning;
    final bool hasStarted = _stopwatch.elapsedMilliseconds > 0;

    return Scaffold(
      backgroundColor: ZerisColors.page,
      appBar: AppBar(
        title: Text(
          'Cronómetro (Timer)',
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
            // Panel informativo de buenas prácticas
            Container(
              decoration: zerisPanelDecoration(),
              padding: const EdgeInsets.all(ZerisSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CONTROL DE TEMPORIZADORES Y RECURSOS',
                    style: ZerisTypography.kicker(),
                  ),
                  const SizedBox(height: ZerisSpacing.xs),
                  Text(
                    'El cronómetro combina un Stopwatch interno para cálculo de tiempo real de alta '
                    'precisión con un Timer.periodic a 100 ms. Es indispensable cancelar el Timer '
                    'en dispose() y al pausar para liberar memoria y batería.',
                    style: ZerisTypography.body(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: ZerisSpacing.xl),

            // Panel del marcador digital
            Container(
              decoration: zerisPanelDecoration(),
              padding: const EdgeInsets.symmetric(
                vertical: ZerisSpacing.xl,
                horizontal: ZerisSpacing.lg,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isRunning ? Icons.play_circle_fill : Icons.pause_circle_filled,
                        color: isRunning ? const Color(0xFF10B981) : ZerisColors.kicker,
                        size: 16,
                      ),
                      const SizedBox(width: ZerisSpacing.xs),
                      Text(
                        isRunning ? 'EN EJECUCIÓN' : (hasStarted ? 'PAUSADO' : 'EN ESPERA'),
                        style: ZerisTypography.kicker(
                          color: isRunning ? const Color(0xFF10B981) : ZerisColors.kicker,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: ZerisSpacing.md),
                  // Marcador grande estilo display con tipografía tabular para evitar jitter
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _formattedTime(),
                      style: GoogleFonts.manrope(
                        fontSize: 56,
                        fontWeight: FontWeight.w800,
                        color: ZerisColors.fgStrong,
                        letterSpacing: -1.0,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                  const SizedBox(height: ZerisSpacing.xs),
                  Text(
                    'MINUTOS : SEGUNDOS . CENTÉSIMAS',
                    style: ZerisTypography.label(color: ZerisColors.uiMuted),
                  ),
                ],
              ),
            ),

            const SizedBox(height: ZerisSpacing.xl),

            // Botonera de control
            if (!hasStarted)
              // Estado inicial: Sólo Iniciar
              Container(
                decoration: zerisCtaButtonDecoration(),
                child: ElevatedButton.icon(
                  onPressed: _start,
                  icon: const Icon(Icons.play_arrow, color: ZerisColors.buttonText),
                  label: Text(
                    'INICIAR CRONÓMETRO',
                    style: ZerisTypography.title(color: ZerisColors.buttonText),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: ZerisSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ZerisRadius.lg),
                    ),
                  ),
                ),
              )
            else if (isRunning)
              // Estado en ejecución: Botón de Pausar
              ElevatedButton.icon(
                onPressed: _pause,
                icon: const Icon(Icons.pause, color: ZerisColors.fgStrong),
                label: Text(
                  'PAUSAR',
                  style: ZerisTypography.title(color: ZerisColors.fgStrong),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: ZerisColors.fgStrong,
                  padding: const EdgeInsets.symmetric(vertical: ZerisSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ZerisRadius.lg),
                  ),
                ),
              )
            else
              // Estado pausado: Opciones de Reanudar y Reiniciar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: zerisCtaButtonDecoration(),
                      child: ElevatedButton.icon(
                        onPressed: _resume,
                        icon: const Icon(Icons.play_arrow, color: ZerisColors.buttonText),
                        label: Text(
                          'REANUDAR',
                          style: ZerisTypography.title(color: ZerisColors.buttonText),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: ZerisSpacing.md),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ZerisRadius.lg),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: ZerisSpacing.md),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _reset,
                      icon: const Icon(Icons.restart_alt, color: ZerisColors.fgStrong),
                      label: Text(
                        'REINICIAR',
                        style: ZerisTypography.title(color: ZerisColors.fgStrong),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: ZerisColors.panelBorder, width: 1.2),
                        padding: const EdgeInsets.symmetric(vertical: ZerisSpacing.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ZerisRadius.lg),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
