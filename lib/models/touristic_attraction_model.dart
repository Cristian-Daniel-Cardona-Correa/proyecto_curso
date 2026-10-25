/// Modelo para representar un Atractivo Turístico de Colombia.
class TouristicAttractionModel {
  final int id;
  final String name;
  final String? description;
  final List<String> images;
  final String? latitude;
  final String? longitude;
  final int? cityId;
  final String? cityName;

  const TouristicAttractionModel({
    required this.id,
    required this.name,
    this.description,
    this.images = const [],
    this.latitude,
    this.longitude,
    this.cityId,
    this.cityName,
  });

  String? get firstImage => images.isNotEmpty ? images.first : null;

  factory TouristicAttractionModel.fromJson(Map<String, dynamic> json) {
    String? city;
    if (json['city'] is Map<String, dynamic>) {
      city = json['city']['name'] as String?;
    }

    final rawImages = json['images'];
    final List<String> parsedImages = [];
    if (rawImages is List) {
      for (final img in rawImages) {
        if (img != null && img.toString().trim().isNotEmpty) {
          parsedImages.add(img.toString().trim());
        }
      }
    }

    return TouristicAttractionModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Sin nombre',
      description: json['description'] as String?,
      images: parsedImages,
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      cityId: json['cityId'] as int?,
      cityName: city,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'images': images,
      'latitude': latitude,
      'longitude': longitude,
      'cityId': cityId,
      'cityName': cityName,
    };
  }
}
