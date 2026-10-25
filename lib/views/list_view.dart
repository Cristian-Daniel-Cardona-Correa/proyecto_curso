import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/department_model.dart';
import '../models/endpoint_type.dart';
import '../models/president_model.dart';
import '../models/touristic_attraction_model.dart';
import '../models/typical_dish_model.dart';
import '../services/api_exception.dart';
import '../services/api_service.dart';
import '../themes/app_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_retry.dart';
import '../widgets/item_tiles.dart';
import '../widgets/loading_indicator.dart';

/// Estado de la vista de listado.
enum _ListStatus { loading, success, error, empty }

/// Pantalla de Listado conectada a API Colombia mediante ApiService.
class ListViewScreen extends StatefulWidget {
  final String endpointKey;
  final ApiService? apiService;

  const ListViewScreen({
    super.key,
    required this.endpointKey,
    this.apiService,
  });

  @override
  State<ListViewScreen> createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<ListViewScreen> {
  late final ApiService _apiService;
  late final EndpointType? _endpointType;

  _ListStatus _status = _ListStatus.loading;
  String _errorMessage = '';
  List<dynamic> _items = [];
  List<dynamic> _filteredItems = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService ?? ApiService();
    _endpointType = EndpointType.fromKey(widget.endpointKey);
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (_endpointType == null) {
      setState(() {
        _status = _ListStatus.error;
        _errorMessage = 'El endpoint especificado "${widget.endpointKey}" no existe.';
      });
      return;
    }

    setState(() {
      _status = _ListStatus.loading;
      _errorMessage = '';
    });

    try {
      final results = await _apiService.fetchList(_endpointType);
      if (!mounted) return;

      if (results.isEmpty) {
        setState(() {
          _items = [];
          _filteredItems = [];
          _status = _ListStatus.empty;
        });
      } else {
        setState(() {
          _items = results;
          _applyFilter(_searchQuery);
          _status = _filteredItems.isEmpty ? _ListStatus.empty : _ListStatus.success;
        });
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _status = _ListStatus.error;
        _errorMessage = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _status = _ListStatus.error;
        _errorMessage = 'Ocurrió un error inesperado al procesar los datos: $e';
      });
    }
  }

  void _applyFilter(String query) {
    _searchQuery = query.trim().toLowerCase();
    if (_searchQuery.isEmpty) {
      _filteredItems = List.from(_items);
    } else {
      _filteredItems = _items.where((item) {
        if (item is DepartmentModel) {
          return item.name.toLowerCase().contains(_searchQuery) ||
              (item.capitalName?.toLowerCase().contains(_searchQuery) ?? false);
        } else if (item is PresidentModel) {
          return item.fullName.toLowerCase().contains(_searchQuery) ||
              (item.politicalParty?.toLowerCase().contains(_searchQuery) ?? false);
        } else if (item is TouristicAttractionModel) {
          return item.name.toLowerCase().contains(_searchQuery) ||
              (item.cityName?.toLowerCase().contains(_searchQuery) ?? false);
        } else if (item is TypicalDishModel) {
          return item.name.toLowerCase().contains(_searchQuery) ||
              (item.departmentName?.toLowerCase().contains(_searchQuery) ?? false);
        }
        return false;
      }).toList();
    }
  }

  void _navigateToDetail(int id) {
    context.goNamed(
      'detail',
      pathParameters: {
        'endpoint': widget.endpointKey,
        'id': id.toString(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = _endpointType?.title ?? 'Listado';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _endpointType?.kicker ?? 'API COLOMBIA',
              style: AppTheme.kickerStyle.copyWith(fontSize: 9),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Recargar datos',
            onPressed: _fetchData,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Barra de búsqueda en tiempo real
            if (_status == _ListStatus.success || _items.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _applyFilter(value);
                      if (_filteredItems.isEmpty && _items.isNotEmpty) {
                        _status = _ListStatus.empty;
                      } else {
                        _status = _ListStatus.success;
                      }
                    });
                  },
                  style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Buscar en $title...',
                    hintStyle: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                    prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.kickerText, size: 20),
                    filled: true,
                    fillColor: AppTheme.surfacePanel,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      borderSide: const BorderSide(color: AppTheme.borderSubtle),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      borderSide: const BorderSide(color: AppTheme.primaryIndigo),
                    ),
                  ),
                ),
              ),

            // Contenedor de estados
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_status) {
      case _ListStatus.loading:
        return const LoadingIndicator(
          message: 'Consultando API Colombia...',
        );

      case _ListStatus.error:
        return ErrorRetry(
          message: _errorMessage,
          onRetry: _fetchData,
        );

      case _ListStatus.empty:
        return EmptyState(
          title: _searchQuery.isNotEmpty
              ? 'No hay resultados para "$_searchQuery"'
              : 'No se encontraron registros',
          subtitle: _searchQuery.isNotEmpty
              ? 'Prueba con otro término de búsqueda o limpia el filtro.'
              : 'La API no devolvió registros para esta categoría.',
        );

      case _ListStatus.success:
        return RefreshIndicator(
          color: AppTheme.primaryIndigo,
          backgroundColor: AppTheme.surfacePanel,
          onRefresh: _fetchData,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            itemCount: _filteredItems.length,
            padding: const EdgeInsets.only(bottom: 24, top: 4),
            itemBuilder: (context, index) {
              final item = _filteredItems[index];

              if (item is DepartmentModel) {
                return DepartmentTile(
                  department: item,
                  onTap: () => _navigateToDetail(item.id),
                );
              } else if (item is PresidentModel) {
                return PresidentTile(
                  president: item,
                  onTap: () => _navigateToDetail(item.id),
                );
              } else if (item is TouristicAttractionModel) {
                return TouristicAttractionTile(
                  attraction: item,
                  onTap: () => _navigateToDetail(item.id),
                );
              } else if (item is TypicalDishModel) {
                return TypicalDishTile(
                  dish: item,
                  onTap: () => _navigateToDetail(item.id),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        );
    }
  }
}
