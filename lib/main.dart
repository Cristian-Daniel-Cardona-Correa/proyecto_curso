import 'package:flutter/material.dart';
import 'home_page.dart';
import 'theme.dart';

void main() {
  runApp(const ZerisApp());
}

/// Aplicación principal de Zeris Fitness Platform.
/// Configurada con el tema oscuro por defecto según el Design System de Zeris.
class ZerisApp extends StatelessWidget {
  const ZerisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zeris',
      debugShowCheckedModeBanner: false,
      theme: ZerisTheme.darkTheme,
      home: const HomePage(),
    );
  }
}
