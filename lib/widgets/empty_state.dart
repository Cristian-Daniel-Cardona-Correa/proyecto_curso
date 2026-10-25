import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

/// Estado vacío reutilizable con estética de panel Zeris.
class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const EmptyState({
    super.key,
    this.title = 'No se encontraron registros',
    this.subtitle = 'No hay datos disponibles en esta sección actualmente.',
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppTheme.surfacePanel,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            border: Border.all(color: AppTheme.borderSubtle),
            boxShadow: AppTheme.panelShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.primaryIndigo.withAlpha(25),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.kickerText,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'SIN REGISTROS',
                style: AppTheme.kickerStyle,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
