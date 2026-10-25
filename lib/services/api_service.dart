import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/department_model.dart';
import '../models/endpoint_type.dart';
import '../models/president_model.dart';
import '../models/touristic_attraction_model.dart';
import '../models/typical_dish_model.dart';
import 'api_exception.dart';

/// Servicio encargado del consumo HTTP de la API de Datos Abiertos de Colombia.
class ApiService {
  final http.Client _client;
  final String _baseUrl;

  ApiService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? AppConfig.apiBaseUrl;

  /// Realiza una petición GET genérica con validación de estados y timeouts.
  Future<dynamic> _get(String path) async {
    final uri = Uri.parse('$_baseUrl$path');
    try {
      final response = await _client
          .get(uri, headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          })
          .timeout(AppConfig.requestTimeout);

      if (response.statusCode == 200) {
        final decoded = json.decode(utf8.decode(response.bodyBytes));
        return decoded;
      } else {
        throw ApiException(
          'Error en el servidor: Código ${response.statusCode}',
          statusCode: response.statusCode,
          details: response.body,
        );
      }
    } on SocketException catch (e) {
      throw ApiException(
        'Sin conexión a internet. Revisa tu red y vuelve a intentar.',
        details: e.toString(),
      );
    } on TimeoutException catch (e) {
      throw ApiException(
        'Tiempo de espera agotado. El servidor tardó demasiado en responder.',
        details: e.toString(),
      );
    } on FormatException catch (e) {
      throw ApiException(
        'Formato de datos devuelto por la API inválido.',
        details: e.toString(),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Ocurrió un error inesperado: $e');
    }
  }

  // ─── Departamentos ─────────────────────────────────────────────────────────

  Future<List<DepartmentModel>> getDepartments() async {
    final data = await _get('/Department');
    if (data is List) {
      return data
          .map((item) => DepartmentModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<DepartmentModel> getDepartmentById(int id) async {
    final data = await _get('/Department/$id');
    if (data is Map<String, dynamic>) {
      return DepartmentModel.fromJson(data);
    }
    throw const ApiException('No se encontró el departamento solicitado', statusCode: 404);
  }

  // ─── Presidentes ───────────────────────────────────────────────────────────

  Future<List<PresidentModel>> getPresidents() async {
    final data = await _get('/President');
    if (data is List) {
      return data
          .map((item) => PresidentModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<PresidentModel> getPresidentById(int id) async {
    final data = await _get('/President/$id');
    if (data is Map<String, dynamic>) {
      return PresidentModel.fromJson(data);
    }
    throw const ApiException('No se encontró el presidente solicitado', statusCode: 404);
  }

  // ─── Atracciones Turísticas ────────────────────────────────────────────────

  Future<List<TouristicAttractionModel>> getTouristicAttractions() async {
    final data = await _get('/TouristicAttraction');
    if (data is List) {
      return data
          .map((item) => TouristicAttractionModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<TouristicAttractionModel> getTouristicAttractionById(int id) async {
    final data = await _get('/TouristicAttraction/$id');
    if (data is Map<String, dynamic>) {
      return TouristicAttractionModel.fromJson(data);
    }
    throw const ApiException('No se encontró la atracción turística', statusCode: 404);
  }

  // ─── Platos Típicos ────────────────────────────────────────────────────────

  Future<List<TypicalDishModel>> getTypicalDishes() async {
    final data = await _get('/TypicalDish');
    if (data is List) {
      return data
          .map((item) => TypicalDishModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<TypicalDishModel> getTypicalDishById(int id) async {
    final data = await _get('/TypicalDish/$id');
    if (data is Map<String, dynamic>) {
      return TypicalDishModel.fromJson(data);
    }
    throw const ApiException('No se encontró el plato típico', statusCode: 404);
  }

  // ─── Despachadores polimórficos por tipo ────────────────────────────────────

  Future<List<dynamic>> fetchList(EndpointType type) {
    switch (type) {
      case EndpointType.department:
        return getDepartments();
      case EndpointType.president:
        return getPresidents();
      case EndpointType.touristicAttraction:
        return getTouristicAttractions();
      case EndpointType.typicalDish:
        return getTypicalDishes();
    }
  }

  Future<dynamic> fetchDetail(EndpointType type, int id) {
    switch (type) {
      case EndpointType.department:
        return getDepartmentById(id);
      case EndpointType.president:
        return getPresidentById(id);
      case EndpointType.touristicAttraction:
        return getTouristicAttractionById(id);
      case EndpointType.typicalDish:
        return getTypicalDishById(id);
    }
  }

  void dispose() {
    _client.close();
  }
}
