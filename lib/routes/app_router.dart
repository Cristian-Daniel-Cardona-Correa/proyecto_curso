import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../themes/app_theme.dart';
import '../views/dashboard_view.dart';
import '../views/detail_view.dart';
import '../views/list_view.dart';

/// Configuración declarativa de rutas con GoRouter para Datos Abiertos Colombia.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/',
        name: 'dashboard',
        builder: (context, state) => const DashboardView(),
        routes: [
          GoRoute(
            path: 'list/:endpoint',
            name: 'list',
            builder: (context, state) {
              final endpoint = state.pathParameters['endpoint'] ?? '';
              return ListViewScreen(endpointKey: endpoint);
            },
            routes: [
              GoRoute(
                path: 'detail/:id',
                name: 'detail',
                builder: (context, state) {
                  final endpoint = state.pathParameters['endpoint'] ?? '';
                  final idStr = state.pathParameters['id'] ?? '0';
                  final id = int.tryParse(idStr) ?? 0;
                  return DetailView(endpointKey: endpoint, id: id);
                },
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Ruta no encontrada'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surfacePanel,
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              border: Border.all(color: AppTheme.borderSubtle),
              boxShadow: AppTheme.panelShadow,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: AppTheme.errorRed,
                ),
                const SizedBox(height: 16),
                Text(
                  '404 • PÁGINA NO ENCONTRADA',
                  style: AppTheme.kickerStyle.copyWith(color: AppTheme.errorRed),
                ),
                const SizedBox(height: 8),
                Text(
                  'La ruta "${state.uri}" no existe en la aplicación.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => context.goNamed('dashboard'),
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Volver al Dashboard'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
