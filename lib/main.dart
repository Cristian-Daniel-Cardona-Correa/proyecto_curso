import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/app_config.dart';
import 'routes/app_router.dart';
import 'themes/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('Aviso: No se pudo cargar el archivo .env, usando configuración por defecto: $e');
  }

  runApp(const TallerDatosAbiertosApp());
}

/// Aplicación principal de Datos Abiertos Colombia.
/// Configurada con GoRouter para navegación declarativa y Tema Zeris oscuro.
class TallerDatosAbiertosApp extends StatelessWidget {
  const TallerDatosAbiertosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConfig.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}
