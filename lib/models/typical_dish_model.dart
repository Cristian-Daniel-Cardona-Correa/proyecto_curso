/// Modelo para representar un Plato Típico de Colombia.
class TypicalDishModel {
  final int id;
  final String name;
  final String? description;
  final String? ingredients;
  final String? imageUrl;
  final int? departmentId;
  final String? departmentName;

  const TypicalDishModel({
    required this.id,
    required this.name,
    this.description,
    this.ingredients,
    this.imageUrl,
    this.departmentId,
    this.departmentName,
  });

  factory TypicalDishModel.fromJson(Map<String, dynamic> json) {
    String? depName;
    if (json['department'] is Map<String, dynamic>) {
      depName = json['department']['name'] as String?;
    }

    return TypicalDishModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Sin nombre',
      description: json['description'] as String?,
      ingredients: json['ingredients'] as String?,
      imageUrl: json['imageUrl'] as String?,
      departmentId: json['departmentId'] as int?,
      departmentName: depName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ingredients': ingredients,
      'imageUrl': imageUrl,
      'departmentId': departmentId,
      'departmentName': departmentName,
    };
  }
}
