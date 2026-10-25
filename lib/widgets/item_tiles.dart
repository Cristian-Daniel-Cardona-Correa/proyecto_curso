import 'package:flutter/material.dart';
import '../models/department_model.dart';
import '../models/president_model.dart';
import '../models/touristic_attraction_model.dart';
import '../models/typical_dish_model.dart';
import '../themes/app_theme.dart';

/// Card contenedor base con estética Zeris para ítems de listado.
class _BaseZerisTile extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _BaseZerisTile({
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surfacePanel,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.borderSubtle, width: 1),
        boxShadow: AppTheme.panelShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          splashColor: AppTheme.primaryIndigo.withAlpha(35),
          highlightColor: AppTheme.primaryIndigo.withAlpha(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Tile para mostrar un Departamento en la lista.
class DepartmentTile extends StatelessWidget {
  final DepartmentModel department;
  final VoidCallback onTap;

  const DepartmentTile({
    super.key,
    required this.department,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseZerisTile(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.primaryIndigo.withAlpha(30),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              border: Border.all(color: AppTheme.borderSubtle),
            ),
            child: const Icon(
              Icons.location_city_outlined,
              color: AppTheme.kickerText,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ID: #${department.id} • ${department.municipalities ?? 0} MUNICIPIOS',
                  style: AppTheme.kickerStyle,
                ),
                const SizedBox(height: 3),
                Text(
                  department.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  department.capitalName != null
                      ? 'Capital: ${department.capitalName}'
                      : 'Superficie: ${department.surface ?? 0} km²',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppTheme.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }
}

/// Tile para mostrar un Presidente en la lista.
class PresidentTile extends StatelessWidget {
  final PresidentModel president;
  final VoidCallback onTap;

  const PresidentTile({
    super.key,
    required this.president,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseZerisTile(
      onTap: onTap,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            child: SizedBox(
              width: 44,
              height: 44,
              child: president.image != null && president.image!.isNotEmpty
                  ? Image.network(
                      president.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _buildFallbackAvatar(),
                    )
                  : _buildFallbackAvatar(),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (president.politicalParty ?? 'HISTORIA REPUBLICANA').toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.kickerStyle,
                ),
                const SizedBox(height: 3),
                Text(
                  president.fullName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  president.periodFormatted,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppTheme.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackAvatar() {
    return Container(
      color: AppTheme.primaryIndigo.withAlpha(30),
      child: const Icon(
        Icons.person_outline_rounded,
        color: AppTheme.kickerText,
        size: 24,
      ),
    );
  }
}

/// Tile para mostrar un Atractivo Turístico en la lista.
class TouristicAttractionTile extends StatelessWidget {
  final TouristicAttractionModel attraction;
  final VoidCallback onTap;

  const TouristicAttractionTile({
    super.key,
    required this.attraction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseZerisTile(
      onTap: onTap,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            child: SizedBox(
              width: 50,
              height: 50,
              child: attraction.firstImage != null
                  ? Image.network(
                      attraction.firstImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _buildFallbackIcon(),
                    )
                  : _buildFallbackIcon(),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (attraction.cityName ?? 'COLOMBIA').toUpperCase(),
                  style: AppTheme.kickerStyle,
                ),
                const SizedBox(height: 3),
                Text(
                  attraction.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  attraction.description ?? 'Sin descripción disponible',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppTheme.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return Container(
      color: AppTheme.primaryIndigo.withAlpha(30),
      child: const Icon(
        Icons.landscape_outlined,
        color: AppTheme.kickerText,
        size: 24,
      ),
    );
  }
}

/// Tile para mostrar un Plato Típico en la lista.
class TypicalDishTile extends StatelessWidget {
  final TypicalDishModel dish;
  final VoidCallback onTap;

  const TypicalDishTile({
    super.key,
    required this.dish,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseZerisTile(
      onTap: onTap,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            child: SizedBox(
              width: 50,
              height: 50,
              child: dish.imageUrl != null && dish.imageUrl!.isNotEmpty
                  ? Image.network(
                      dish.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _buildFallbackIcon(),
                    )
                  : _buildFallbackIcon(),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (dish.departmentName ?? 'GASTRONOMÍA COLOMBIANA').toUpperCase(),
                  style: AppTheme.kickerStyle,
                ),
                const SizedBox(height: 3),
                Text(
                  dish.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  dish.ingredients ?? dish.description ?? 'Plato típico tradicional',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppTheme.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return Container(
      color: AppTheme.primaryIndigo.withAlpha(30),
      child: const Icon(
        Icons.restaurant_outlined,
        color: AppTheme.kickerText,
        size: 24,
      ),
    );
  }
}
