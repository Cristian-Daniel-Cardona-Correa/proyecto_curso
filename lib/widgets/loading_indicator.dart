import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

/// Indicador de carga con estilo Zeris y spinner índigo-violeta.
class LoadingIndicator extends StatelessWidget {
  final String? message;

  const LoadingIndicator({
    super.key,
    this.message = 'Cargando datos...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfacePanel,
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              border: Border.all(color: AppTheme.borderSubtle),
              boxShadow: AppTheme.panelShadow,
            ),
            child: const SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryIndigo),
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!.toUpperCase(),
              style: AppTheme.kickerStyle.copyWith(letterSpacing: 1.6),
            ),
          ],
        ],
      ),
    );
  }
}
