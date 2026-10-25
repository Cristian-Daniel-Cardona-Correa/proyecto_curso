import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_curso/models/department_model.dart';
import 'package:proyecto_curso/models/endpoint_type.dart';
import 'package:proyecto_curso/models/president_model.dart';
import 'package:proyecto_curso/models/touristic_attraction_model.dart';
import 'package:proyecto_curso/models/typical_dish_model.dart';

void main() {
  group('Pruebas unitarias de Modelos - API Colombia', () {
    test('DepartmentModel serialización y deserialización correcta', () {
      final json = {
        'id': 1,
        'name': 'Amazonas',
        'description': 'Departamento del sur de Colombia',
        'cityCapitalId': 10,
        'municipalities': 2,
        'surface': 109665,
        'population': 82068,
        'phonePrefix': '8',
        'countryId': 1,
        'cityCapital': {'id': 10, 'name': 'Leticia'},
        'regionId': 4,
      };

      final model = DepartmentModel.fromJson(json);

      expect(model.id, 1);
      expect(model.name, 'Amazonas');
      expect(model.capitalName, 'Leticia');
      expect(model.municipalities, 2);
      expect(model.surface, 109665);

      final exported = model.toJson();
      expect(exported['id'], 1);
      expect(exported['capitalName'], 'Leticia');
    });

    test('PresidentModel parsea fechas, nombre completo y periodo formateado', () {
      final json = {
        'id': 1,
        'name': 'José María',
        'lastName': 'Campo Serrano',
        'startPeriodDate': '1886-08-05',
        'endPeriodDate': '1887-01-06',
        'politicalParty': 'Partido Nacional',
        'description': 'Presidente que sancionó la constitución de 1886',
        'city': {'id': 709, 'name': 'Santa Marta'},
      };

      final president = PresidentModel.fromJson(json);

      expect(president.fullName, 'José María Campo Serrano');
      expect(president.periodFormatted, '1886-08-05 — 1887-01-06');
      expect(president.cityName, 'Santa Marta');
      expect(president.politicalParty, 'Partido Nacional');
    });

    test('TouristicAttractionModel parsea lista de imagenes y coordenadas', () {
      final json = {
        'id': 1,
        'name': 'Museo del Oro',
        'description': 'Museo precolombino en Bogotá',
        'images': [
          'https://images.example.com/oro1.jpg',
          'https://images.example.com/oro2.jpg',
        ],
        'latitude': '4.6019',
        'longitude': '-74.072',
        'city': {'id': 167, 'name': 'Bogotá D.C.'},
      };

      final attraction = TouristicAttractionModel.fromJson(json);

      expect(attraction.name, 'Museo del Oro');
      expect(attraction.images.length, 2);
      expect(attraction.firstImage, 'https://images.example.com/oro1.jpg');
      expect(attraction.cityName, 'Bogotá D.C.');
      expect(attraction.latitude, '4.6019');
    });

    test('TypicalDishModel deserializa ingredientes e imagen', () {
      final json = {
        'id': 1,
        'name': 'Bandeja Paisa',
        'description': 'Plato tradicional antioqueño',
        'ingredients': 'Frijoles, arroz, carne molida, chicharrón, huevo',
        'imageUrl': 'https://storage.example.com/bandeja.jpg',
        'departmentId': 2,
        'department': {'id': 2, 'name': 'Antioquia'},
      };

      final dish = TypicalDishModel.fromJson(json);

      expect(dish.name, 'Bandeja Paisa');
      expect(dish.departmentName, 'Antioquia');
      expect(dish.ingredients, contains('chicharrón'));
      expect(dish.imageUrl, 'https://storage.example.com/bandeja.jpg');
    });

    test('EndpointType resuelve adecuadamente por claves de ruta', () {
      expect(EndpointType.fromKey('department'), EndpointType.department);
      expect(EndpointType.fromKey('president'), EndpointType.president);
      expect(EndpointType.fromKey('touristic-attraction'), EndpointType.touristicAttraction);
      expect(EndpointType.fromKey('typical-dish'), EndpointType.typicalDish);
      expect(EndpointType.fromKey('inexistente'), isNull);
    });
  });
}
