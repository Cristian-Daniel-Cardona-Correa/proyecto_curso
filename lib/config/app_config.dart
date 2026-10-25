import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuración central de la aplicación y carga de variables de entorno.
class AppConfig {
  AppConfig._();

  /// URL base para consumir la API pública de Colombia.
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api-colombia.com/api/v1';

  /// Nombre representativo de la aplicación.
  static const String appTitle = 'Datos Abiertos Colombia';

  /// Tiempo máximo de espera para peticiones HTTP.
  static const Duration requestTimeout = Duration(seconds: 15);
}
