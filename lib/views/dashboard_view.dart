import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/endpoint_type.dart';
import '../themes/app_theme.dart';
import '../widgets/dashboard_card.dart';

/// Pantalla principal con el Dashboard de los 4 endpoints seleccionados.
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: const Icon(Icons.hub_rounded, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'COLOMBIA ABIERTA',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'DATOS ABIERTOS & GOBIERNO',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.kickerText,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryIndigo.withAlpha(30),
                        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                        border: Border.all(color: AppTheme.borderSubtle),
                      ),
                      child: Text(
                        'API COLOMBIA v1 • DART & FLUTTER',
                        style: AppTheme.kickerStyle.copyWith(fontSize: 9),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Explora el Patrimonio Nacional',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Accede a registros oficiales de la República de Colombia consumidos mediante peticiones REST, arquitectura por capas y navegación reactiva.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.crossAxisExtent > 600 ? 2 : 1;
                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      mainAxisExtent: 200,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final endpoint = EndpointType.values[index];
                        return DashboardCard(
                          endpoint: endpoint,
                          onTap: () {
                            context.goNamed(
                              'list',
                              pathParameters: {'endpoint': endpoint.key},
                            );
                          },
                        );
                      },
                      childCount: EndpointType.values.length,
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfacePanel,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    border: Border.all(color: AppTheme.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryIndigo.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified_outlined,
                          color: AppTheme.kickerText,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FUENTE DE DATOS OFICIAL',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.kickerText,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'api-colombia.com/swagger/index.html',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
