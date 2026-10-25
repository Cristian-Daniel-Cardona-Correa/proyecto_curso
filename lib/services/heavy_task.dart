import 'dart:isolate';

/// Función intensiva en uso de CPU (CPU-bound) que simula el procesamiento masivo
/// de métricas biométricas o cálculo acumulativo de series y repeticiones.
int heavySum(int n) {
  int total = 0;
  for (int i = 1; i <= n; i++) {
    // Operación aritmética no trivial para forzar cálculo en el procesador
    total += (i % 7 == 0) ? i ~/ 2 : i;
  }
  return total;
}

/// Función de entrada top-level requerida por [Isolate.spawn].
/// Se ejecuta en un espacio de memoria aislado (hilo secundario independiente).
void isolateEntry(SendPort sendPort) {
  final stopwatch = Stopwatch()..start();
  const int target = 500000000;

  // Ejecución de la tarea pesada en el hilo del Isolate
  final int result = heavySum(target);
  stopwatch.stop();

  // Comunicación bidireccional / retorno al hilo principal vía SendPort
  sendPort.send({
    'result': result,
    'elapsedMs': stopwatch.elapsedMilliseconds,
    'target': target,
  });
}
