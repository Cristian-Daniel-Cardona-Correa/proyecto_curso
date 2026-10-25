import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:proyecto_curso/models/endpoint_type.dart';
import 'package:proyecto_curso/services/api_exception.dart';
import 'package:proyecto_curso/services/api_service.dart';

void main() {
  group('Pruebas unitarias de ApiService', () {
    test('getDepartments retorna lista de departamentos ante 200 OK', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/v1/Department');
        return http.Response(
          json.encode([
            {'id': 1, 'name': 'Amazonas'},
            {'id': 2, 'name': 'Antioquia'},
          ]),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final service = ApiService(
        client: mockClient,
        baseUrl: 'https://api-colombia.com/api/v1',
      );

      final result = await service.getDepartments();

      expect(result.length, 2);
      expect(result.first.name, 'Amazonas');
      expect(result.last.name, 'Antioquia');
    });

    test('getDepartmentById retorna departamento individual correctamente', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/v1/Department/1');
        return http.Response(
          json.encode({'id': 1, 'name': 'Amazonas', 'municipalities': 2}),
          200,
        );
      });

      final service = ApiService(
        client: mockClient,
        baseUrl: 'https://api-colombia.com/api/v1',
      );

      final dept = await service.getDepartmentById(1);
      expect(dept.id, 1);
      expect(dept.name, 'Amazonas');
      expect(dept.municipalities, 2);
    });

    test('Lanza ApiException con statusCode cuando la API retorna 500', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      final service = ApiService(
        client: mockClient,
        baseUrl: 'https://api-colombia.com/api/v1',
      );

      expect(
        () => service.getPresidents(),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'statusCode', 500)),
      );
    });

    test('fetchList invoca el endpoint adecuado según EndpointType', () async {
      final mockClient = MockClient((request) async {
        if (request.url.path == '/api/v1/TypicalDish') {
          return http.Response(
            json.encode([{'id': 1, 'name': 'Ajiaco'}]),
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      final service = ApiService(
        client: mockClient,
        baseUrl: 'https://api-colombia.com/api/v1',
      );

      final dishes = await service.fetchList(EndpointType.typicalDish);
      expect(dishes.length, 1);
    });
  });
}
