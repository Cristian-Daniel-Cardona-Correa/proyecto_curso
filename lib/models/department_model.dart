/// Modelo para representar un Departamento de Colombia.
class DepartmentModel {
  final int id;
  final String name;
  final String? description;
  final int? cityCapitalId;
  final int? municipalities;
  final num? surface;
  final num? population;
  final String? phonePrefix;
  final int? countryId;
  final String? capitalName;
  final int? regionId;

  const DepartmentModel({
    required this.id,
    required this.name,
    this.description,
    this.cityCapitalId,
    this.municipalities,
    this.surface,
    this.population,
    this.phonePrefix,
    this.countryId,
    this.capitalName,
    this.regionId,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    String? capName;
    if (json['cityCapital'] is Map<String, dynamic>) {
      capName = json['cityCapital']['name'] as String?;
    }

    return DepartmentModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Sin nombre',
      description: json['description'] as String?,
      cityCapitalId: json['cityCapitalId'] as int?,
      municipalities: json['municipalities'] as int?,
      surface: json['surface'] as num?,
      population: json['population'] as num?,
      phonePrefix: json['phonePrefix']?.toString(),
      countryId: json['countryId'] as int?,
      capitalName: capName,
      regionId: json['regionId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cityCapitalId': cityCapitalId,
      'municipalities': municipalities,
      'surface': surface,
      'population': population,
      'phonePrefix': phonePrefix,
      'countryId': countryId,
      'capitalName': capitalName,
      'regionId': regionId,
    };
  }
}
