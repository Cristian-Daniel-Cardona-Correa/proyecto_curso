import 'package:flutter/material.dart';

/// Enumeración tipada de los 4 endpoints seleccionados de API Colombia.
enum EndpointType {
  department(
    key: 'department',
    title: 'Departamentos',
    kicker: 'GEOGRAFÍA & DIVISIÓN',
    description: 'Explora los 32 departamentos de Colombia, sus capitales y superficies.',
    icon: Icons.map_outlined,
    apiPath: '/Department',
  ),
  president(
    key: 'president',
    title: 'Presidentes',
    kicker: 'HISTORIA REPUBLICANA',
    description: 'Líderes de la República, periodos gubernamentales y partidos políticos.',
    icon: Icons.account_balance_outlined,
    apiPath: '/President',
  ),
  touristicAttraction(
    key: 'touristic-attraction',
    title: 'Atracciones Turísticas',
    kicker: 'PATRIMONIO & TURISMO',
    description: 'Destinos icónicos, museos, parques naturales y maravillas culturales.',
    icon: Icons.landscape_outlined,
    apiPath: '/TouristicAttraction',
  ),
  typicalDish(
    key: 'typical-dish',
    title: 'Gastronomía Típica',
    kicker: 'CULTURA CULINARIA',
    description: 'Platos tradicionales colombianos, ingredientes autóctonos y orígenes.',
    icon: Icons.restaurant_menu_outlined,
    apiPath: '/TypicalDish',
  );

  final String key;
  final String title;
  final String kicker;
  final String description;
  final IconData icon;
  final String apiPath;

  const EndpointType({
    required this.key,
    required this.title,
    required this.kicker,
    required this.description,
    required this.icon,
    required this.apiPath,
  });

  /// Busca el tipo de endpoint por su clave de ruta (key).
  static EndpointType? fromKey(String? key) {
    if (key == null) return null;
    final normalized = key.toLowerCase().trim();
    for (final type in EndpointType.values) {
      if (type.key.toLowerCase() == normalized ||
          type.name.toLowerCase() == normalized) {
        return type;
      }
    }
    return null;
  }
}
