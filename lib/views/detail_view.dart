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
import '../widgets/error_retry.dart';
import '../widgets/loading_indicator.dart';

/// Pantalla de Detalle que consume GET /<Recurso>/{id} con diseño de panel Zeris.
class DetailView extends StatefulWidget {
  final String endpointKey;
  final int id;
  final ApiService? apiService;

  const DetailView({
    super.key,
    required this.endpointKey,
    required this.id,
    this.apiService,
  });

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  late final ApiService _apiService;
  late final EndpointType? _endpointType;

  bool _isLoading = true;
  String _errorMessage = '';
  dynamic _detailData;

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService ?? ApiService();
    _endpointType = EndpointType.fromKey(widget.endpointKey);
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    if (_endpointType == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Endpoint inválido: ${widget.endpointKey}';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final data = await _apiService.fetchDetail(_endpointType, widget.id);
      if (!mounted) return;
      setState(() {
        _detailData = data;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error inesperado al cargar el detalle: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _endpointType?.title ?? 'Detalle';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalle de $title',
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.goNamed(
                'list',
                pathParameters: {'endpoint': widget.endpointKey},
              );
            }
          },
        ),
      ),
      body: SafeArea(
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const LoadingIndicator(
        message: 'Cargando información detallada...',
      );
    }

    if (_errorMessage.isNotEmpty || _detailData == null) {
      return ErrorRetry(
        message: _errorMessage.isNotEmpty
            ? _errorMessage
            : 'No se encontró la información del registro solicitado.',
        onRetry: _loadDetail,
      );
    }

    final data = _detailData;
    if (data is DepartmentModel) {
      return _buildDepartmentDetail(data);
    } else if (data is PresidentModel) {
      return _buildPresidentDetail(data);
    } else if (data is TouristicAttractionModel) {
      return _buildAttractionDetail(data);
    } else if (data is TypicalDishModel) {
      return _buildDishDetail(data);
    }

    return const Center(child: Text('Tipo de dato no reconocido'));
  }

  // ─── Detalle Departamento ──────────────────────────────────────────────────

  Widget _buildDepartmentDetail(DepartmentModel dept) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroHeader(
            kicker: 'DEPARTAMENTO DE COLOMBIA • ID #${dept.id}',
            title: dept.name,
            subtitle: dept.capitalName != null ? 'Capital: ${dept.capitalName}' : null,
            icon: Icons.map_outlined,
          ),
          const SizedBox(height: 20),
          _buildMetricGrid([
            _MetricItem('Capital', dept.capitalName ?? 'No disponible', Icons.location_city),
            _MetricItem('Municipios', '${dept.municipalities ?? 0}', Icons.holiday_village),
            _MetricItem('Superficie', '${dept.surface ?? 0} km²', Icons.aspect_ratio),
            _MetricItem('Población', '${dept.population ?? 0} hab.', Icons.people_outline),
            _MetricItem('Prefijo Tel.', dept.phonePrefix ?? 'N/A', Icons.phone_outlined),
            _MetricItem('ID Región', '${dept.regionId ?? "N/A"}', Icons.public),
          ]),
          const SizedBox(height: 20),
          _buildDescriptionCard(
            title: 'Descripción Geográfica',
            description: dept.description ?? 'Sin descripción detallada disponible en el sistema.',
          ),
        ],
      ),
    );
  }

  // ─── Detalle Presidente ────────────────────────────────────────────────────

  Widget _buildPresidentDetail(PresidentModel pres) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (pres.image != null && pres.image!.isNotEmpty)
            Center(
              child: Container(
                margin: const EdgeInsets.bottom(20),
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  border: Border.all(color: AppTheme.borderSubtle, width: 2),
                  boxShadow: AppTheme.panelShadow,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg - 2),
                  child: Image.network(
                    pres.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppTheme.surfacePanel,
                      child: const Icon(Icons.person, size: 60, color: AppTheme.kickerText),
                    ),
                  ),
                ),
              ),
            ),
          _buildHeroHeader(
            kicker: 'MANDATARIO HISTÓRICO • ID #${pres.id}',
            title: pres.fullName,
            subtitle: pres.periodFormatted,
            icon: Icons.account_balance,
          ),
          const SizedBox(height: 20),
          _buildMetricGrid([
            _MetricItem('Partido', pres.politicalParty ?? 'No registrado', Icons.flag_outlined),
            _MetricItem('Ciudad Natal', pres.cityName ?? 'No registrada', Icons.location_city_outlined),
            _MetricItem('Inicio Periodo', pres.startPeriodDate ?? 'N/A', Icons.calendar_today_outlined),
            _MetricItem('Fin Periodo', pres.endPeriodDate ?? 'N/A', Icons.event_available_outlined),
          ]),
          const SizedBox(height: 20),
          _buildDescriptionCard(
            title: 'Biografía y Mandato',
            description: pres.description ?? 'Sin biografía registrada en la API.',
          ),
        ],
      ),
    );
  }

  // ─── Detalle Atracción Turística ───────────────────────────────────────────

  Widget _buildAttractionDetail(TouristicAttractionModel attr) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (attr.firstImage != null)
            Container(
              margin: const EdgeInsets.bottom(20),
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                border: Border.all(color: AppTheme.borderSubtle, width: 1),
                boxShadow: AppTheme.panelShadow,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusLg - 1),
                child: Image.network(
                  attr.firstImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppTheme.surfacePanel,
                    child: const Icon(Icons.landscape, size: 60, color: AppTheme.kickerText),
                  ),
                ),
              ),
            ),
          _buildHeroHeader(
            kicker: 'PATRIMONIO TURÍSTICO • ID #${attr.id}',
            title: attr.name,
            subtitle: attr.cityName != null ? 'Ubicación: ${attr.cityName}' : null,
            icon: Icons.place_outlined,
          ),
          const SizedBox(height: 20),
          _buildMetricGrid([
            _MetricItem('Ciudad', attr.cityName ?? 'Colombia', Icons.location_on_outlined),
            _MetricItem('Latitud', attr.latitude ?? 'No registrada', Icons.explore_outlined),
            _MetricItem('Longitud', attr.longitude ?? 'No registrada', Icons.explore_outlined),
            _MetricItem('Imágenes', '${attr.images.length}', Icons.photo_library_outlined),
          ]),
          const SizedBox(height: 20),
          _buildDescriptionCard(
            title: 'Acerca del Atractivo Turístico',
            description: attr.description ?? 'Sin información descriptiva disponible.',
          ),
        ],
      ),
    );
  }

  // ─── Detalle Plato Típico ──────────────────────────────────────────────────

  Widget _buildDishDetail(TypicalDishModel dish) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dish.imageUrl != null && dish.imageUrl!.isNotEmpty)
            Container(
              margin: const EdgeInsets.bottom(20),
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                border: Border.all(color: AppTheme.borderSubtle, width: 1),
                boxShadow: AppTheme.panelShadow,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusLg - 1),
                child: Image.network(
                  dish.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppTheme.surfacePanel,
                    child: const Icon(Icons.restaurant, size: 60, color: AppTheme.kickerText),
                  ),
                ),
              ),
            ),
          _buildHeroHeader(
            kicker: 'GASTRONOMÍA COLOMBIANA • ID #${dish.id}',
            title: dish.name,
            subtitle: dish.departmentName != null ? 'Origen: Departamento de ${dish.departmentName}' : null,
            icon: Icons.dining_outlined,
          ),
          const SizedBox(height: 20),
          _buildMetricGrid([
            _MetricItem('Región', dish.departmentName ?? 'Nacional', Icons.map_outlined),
            _MetricItem('ID Depto', '${dish.departmentId ?? "N/A"}', Icons.tag),
          ]),
          if (dish.ingredients != null && dish.ingredients!.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildDescriptionCard(
              title: 'Ingredientes Tradicionales',
              description: dish.ingredients!,
              icon: Icons.lunch_dining_outlined,
            ),
          ],
          const SizedBox(height: 20),
          _buildDescriptionCard(
            title: 'Historia y Preparación',
            description: dish.description ?? 'Sin descripción adicional disponible.',
          ),
        ],
      ),
    );
  }

  // ─── Helpers de Diseño Zeris ───────────────────────────────────────────────

  Widget _buildHeroHeader({
    required String kicker,
    required String title,
    String? subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfacePanel,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppTheme.borderSubtle),
        boxShadow: AppTheme.panelShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryIndigo.withAlpha(30),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                child: Icon(icon, color: AppTheme.kickerText, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  kicker,
                  style: AppTheme.kickerStyle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppTheme.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricGrid(List<_MetricItem> metrics) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 500 ? 3 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 80,
          ),
          itemCount: metrics.length,
          itemBuilder: (context, index) {
            final m = metrics[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.surfacePanel,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(color: AppTheme.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(m.icon, size: 14, color: AppTheme.kickerText),
                      const SizedBox(width: 6),
                      Text(
                        m.label.toUpperCase(),
                        style: AppTheme.kickerStyle.copyWith(fontSize: 9),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    m.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDescriptionCard({
    required String title,
    required String description,
    IconData icon = Icons.notes_outlined,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfacePanel,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppTheme.borderSubtle),
        boxShadow: AppTheme.panelShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppTheme.kickerText),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: AppTheme.kickerStyle,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textPrimary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricItem {
  final String label;
  final String value;
  final IconData icon;

  _MetricItem(this.label, this.value, this.icon);
}
