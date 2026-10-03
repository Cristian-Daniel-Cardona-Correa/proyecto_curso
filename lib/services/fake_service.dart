import 'package:flutter/foundation.dart';

/// Servicio simulado para demostrar asincronía con Future, async y await.
/// Simula la latencia de red hacia el backend de Zeris Fitness Platform.
class FakeService {
  /// Realiza una petición simulada con latencia de 2.5 segundos.
  /// Si [fail] es true, lanza una excepción controlada para probar flujos de error.
  Future<Map<String, dynamic>> fetchWorkoutData({bool fail = false}) async {
    // 1. Mensaje de inicio de la tarea asíncrona
    debugPrint('[FakeService] Iniciando consulta...');

    // 2. Simulación de tiempo de espera de red (2.5 segundos)
    debugPrint('[FakeService] Esperando respuesta...');
    await Future.delayed(const Duration(milliseconds: 2500));

    // 3. Simulación de fallo en el servicio
    if (fail) {
      debugPrint('[FakeService] Error');
      throw Exception('Fallo en la conexión: No fue posible sincronizar la sesión.');
    }

    // 4. Retorno exitoso de datos de entrenamiento
    debugPrint('[FakeService] Datos recibidos');
    return {
      'routineName': 'Empuje y Fuerza - Torso',
      'phase': 'Fase 2: Hipertrofia Funcional',
      'durationMinutes': 55,
      'completedSets': 18,
      'estimatedCalories': 420,
      'coachNotes': 'Mantener tensión controlada en la fase excéntrica del press militar.',
      'lastSync': DateTime.now().toIso8601String(),
    };
  }
}
