/// Modelo para representar un Presidente de Colombia.
class PresidentModel {
  final int id;
  final String name;
  final String lastName;
  final String? image;
  final String? startPeriodDate;
  final String? endPeriodDate;
  final String? politicalParty;
  final String? description;
  final int? cityId;
  final String? cityName;

  const PresidentModel({
    required this.id,
    required this.name,
    required this.lastName,
    this.image,
    this.startPeriodDate,
    this.endPeriodDate,
    this.politicalParty,
    this.description,
    this.cityId,
    this.cityName,
  });

  String get fullName => '$name $lastName'.trim();

  String get periodFormatted {
    if (startPeriodDate == null && endPeriodDate == null) return 'Periodo no disponible';
    final start = startPeriodDate ?? 'Desc.';
    final end = endPeriodDate ?? 'Actualidad';
    return '$start — $end';
  }

  factory PresidentModel.fromJson(Map<String, dynamic> json) {
    String? city;
    if (json['city'] is Map<String, dynamic>) {
      city = json['city']['name'] as String?;
    }

    return PresidentModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      image: json['image'] as String?,
      startPeriodDate: json['startPeriodDate'] as String?,
      endPeriodDate: json['endPeriodDate'] as String?,
      politicalParty: json['politicalParty'] as String?,
      description: json['description'] as String?,
      cityId: json['cityId'] as int?,
      cityName: city,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'image': image,
      'startPeriodDate': startPeriodDate,
      'endPeriodDate': endPeriodDate,
      'politicalParty': politicalParty,
      'description': description,
      'cityId': cityId,
      'cityName': cityName,
    };
  }
}
