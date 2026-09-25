import 'package:flutter/material.dart';
import 'theme.dart';

/// Pantalla principal (HomePage) que implementa el Taller 1 replicando
/// la estética y reglas del sistema de diseño Zeris Fitness Platform.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Variable de estado obligatoria para el título del AppBar.
  /// Estado inicial: "Hola, Flutter"
  String _titulo = 'Hola, Flutter';

  /// Alterna el título de la AppBar entre "Hola, Flutter" y "¡Título cambiado!"
  /// usando setState(), y despliega un SnackBar de confirmación.
  void _toggleTitulo() {
    setState(() {
      _titulo = (_titulo == 'Hola, Flutter')
          ? '¡Título cambiado!'
          : 'Hola, Flutter';
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: ZerisColors.kicker,
              size: 20,
            ),
            const SizedBox(width: ZerisSpacing.sm),
            Text(
              'Título actualizado',
              style: ZerisTypography.body(color: ZerisColors.fgStrong),
            ),
          ],
        ),
        backgroundColor: ZerisColors.panelBg,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ZerisRadius.md),
          side: const BorderSide(color: ZerisColors.panelBorder, width: 1),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Requisito a) AppBar estilo .fp-topbar: fondo translúcido oscuro, borde inferior sutil
      appBar: AppBar(
        title: Text(
          _titulo,
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
      // Requisito g) Layout: SingleChildScrollView > Column, Padding 16, SizedBox de 24 entre secciones
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ZerisSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Requisito b) Text centrado con el nombre completo del estudiante
            Center(
              child: Text(
                'Cristian Daniel Cardona Correa',
                textAlign: TextAlign.center,
                style: ZerisTypography.headline(),
              ),
            ),

            const SizedBox(height: ZerisSpacing.lg),

            // Requisito c) Row con Image.network e Image.asset, ambos con borderRadius 16 (rounded.lg)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Imagen desde red con placeholder/error tolerante a desconexión
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: ZerisColors.panelBg,
                    border: Border.all(color: ZerisColors.panelBorder, width: 1),
                    borderRadius: BorderRadius.circular(ZerisRadius.lg),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(ZerisRadius.lg - 1),
                    child: Image.network(
                      'https://picsum.photos/150',
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: ZerisColors.primaryIndigo,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: ZerisColors.panelBg,
                          child: const Center(
                            child: Icon(
                              Icons.image_outlined,
                              color: ZerisColors.uiMuted,
                              size: 40,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(width: ZerisSpacing.md),

                // Imagen local desde assets: logo_zeris.png
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: ZerisColors.panelBg,
                    border: Border.all(color: ZerisColors.panelBorder, width: 1),
                    borderRadius: BorderRadius.circular(ZerisRadius.lg),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(ZerisRadius.lg - 1),
                    child: Image.asset(
                      'assets/logo_zeris.png',
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: ZerisSpacing.lg),

            // Requisito d) Botón principal traducido de .fp-cta-training:
            // Container con LinearGradient(#6366F1→#7C3AED), radius 16, padding 16x24,
            // glow shadow índigo al 45%, texto #f4f4ff weight 700.
            // Implementado con ElevatedButton interactivo.
            Container(
              decoration: zerisCtaButtonDecoration(),
              child: ElevatedButton(
                onPressed: _toggleTitulo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ZerisRadius.lg),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: ZerisSpacing.lg,
                    vertical: ZerisSpacing.md,
                  ),
                ),
                child: Text(
                  'CAMBIAR TÍTULO',
                  style: ZerisTypography.title(color: ZerisColors.buttonText),
                ),
              ),
            ),

            const SizedBox(height: ZerisSpacing.lg),

            // Requisito e) Widget adicional 1 — Traducción de .fp-panel:
            // Container con zerisPanelDecoration() (fondo panel + borde 1px violeta 22%
            // + radius 16 + sombra 0/10/40), padding 24, con kicker "TU SERIE DE HOY, PRIMERO"
            // en mayúsculas 10px tracking 0.14em color kicker, y texto motivador en estilo body.
            Container(
              decoration: zerisPanelDecoration(),
              padding: const EdgeInsets.all(ZerisSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TU SERIE DE HOY, PRIMERO',
                    style: ZerisTypography.kicker(),
                  ),
                  const SizedBox(height: ZerisSpacing.sm),
                  Text(
                    'Cada repetición cuenta para construir tu mejor versión. '
                    'Mantén la concentración, sigue el plan con disciplina '
                    'y supera tus límites serie a serie.',
                    style: ZerisTypography.body(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: ZerisSpacing.lg),

            // Requisito f) Widget adicional 2 — ListView dentro de panel fp-panel:
            // Altura fija ~240 con 4 ListTile: icono en color kicker + texto title (14px, weight 700):
            // Pecho, Espalda, Piernas, Hombros.
            Container(
              height: 240,
              decoration: zerisPanelDecoration(),
              padding: const EdgeInsets.symmetric(vertical: ZerisSpacing.sm),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.fitness_center,
                      color: ZerisColors.kicker,
                    ),
                    title: Text(
                      'Pecho',
                      style: ZerisTypography.title(),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: ZerisColors.uiMuted,
                      size: 20,
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    indent: ZerisSpacing.md,
                    endIndent: ZerisSpacing.md,
                    color: ZerisColors.panelBorder,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.accessibility_new,
                      color: ZerisColors.kicker,
                    ),
                    title: Text(
                      'Espalda',
                      style: ZerisTypography.title(),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: ZerisColors.uiMuted,
                      size: 20,
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    indent: ZerisSpacing.md,
                    endIndent: ZerisSpacing.md,
                    color: ZerisColors.panelBorder,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.directions_run,
                      color: ZerisColors.kicker,
                    ),
                    title: Text(
                      'Piernas',
                      style: ZerisTypography.title(),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: ZerisColors.uiMuted,
                      size: 20,
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    indent: ZerisSpacing.md,
                    endIndent: ZerisSpacing.md,
                    color: ZerisColors.panelBorder,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.sports_gymnastics,
                      color: ZerisColors.kicker,
                    ),
                    title: Text(
                      'Hombros',
                      style: ZerisTypography.title(),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: ZerisColors.uiMuted,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
