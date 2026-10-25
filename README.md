# Datos Abiertos de Colombia — Flutter

Aplicación móvil desarrollada en **Flutter** que consume la API pública oficial del gobierno [API Colombia](https://api-colombia.com/), implementando un Dashboard interactivo, Listado dinámico con filtros en tiempo real y vista de Detalle estructurada mediante **go_router**, manejo integral de 4 estados reactivos (cargando, éxito, error con reintento y vacío), arquitectura limpia por capas y el sistema de diseño **Zeris Dark Theme**.

---

## 👤 Información del Estudiante y Proyecto

- **Estudiante:** Cristian Daniel Cardona Correa
- **Correo Institucional:** cristian.cardona02@uceva.edu.co
- **Institución:** Unidad Central del Valle del Cauca (UCEVA)
- **Asignatura:** Desarrollo Móvil / Programación Móvil con Flutter
- **Repositorio:** [https://github.com/Cristian-Daniel-Cardona-Correa/proyecto_curso](https://github.com/Cristian-Daniel-Cardona-Correa/proyecto_curso)
- **Ramas del Proyecto (GitFlow):**
  - `main`: Rama estable y de producción.
  - `dev`: Rama de integración continua.
  - `feature/taller_api_colombia`: Rama de desarrollo del taller.

---

## 🌐 API Pública y Endpoints Seleccionados

- **Portal Oficial:** [https://api-colombia.com/](https://api-colombia.com/)
- **Documentación Swagger:** [https://api-colombia.com/swagger/index.html](https://api-colombia.com/swagger/index.html)
- **URL Base:** `https://api-colombia.com/api/v1` (configurada dinámicamente mediante `.env`)

### 4 Endpoints Consumidos (GET)

| Recurso | Endpoint Listado | Endpoint Detalle | Descripción |
|---|---|---|---|
| **1. Departamentos** | `GET /Department` | `GET /Department/{id}` | Geografía, división política, municipios, superficies, población y ciudades capitales. |
| **2. Presidentes** | `GET /President` | `GET /President/{id}` | Mandatarios históricos de la República, periodos de gobierno, partidos y biografías. |
| **3. Atracciones Turísticas** | `GET /TouristicAttraction` | `GET /TouristicAttraction/{id}` | Parques naturales, museos, monumentos, coordenadas geográficas y galería de imágenes. |
| **4. Platos Típicos** | `GET /TypicalDish` | `GET /TypicalDish/{id}` | Gastronomía tradicional colombiana, ingredientes autóctonos y departamento de origen. |

---

## 🧱 Arquitectura y Estructura del Proyecto

Se aplicó una arquitectura estricta por capas donde la lógica de red está 100% desacoplada de la interfaz de usuario:

```
lib/
├── config/
│   └── app_config.dart          # Variables de entorno (.env) y constantes globales
├── models/
│   ├── department_model.dart     # Modelo Department con fromJson() y toJson()
│   ├── endpoint_type.dart        # Enum tipado con metadatos de los 4 endpoints
│   ├── president_model.dart      # Modelo President con fromJson() y periodFormatted
│   ├── touristic_attraction_model.dart # Modelo TouristicAttraction con imágenes y coordenadas
│   └── typical_dish_model.dart   # Modelo TypicalDish con ingredientes y departamento
├── routes/
│   └── app_router.dart           # Configuración de GoRouter con rutas nombradas y 404
├── services/
│   ├── api_exception.dart       # Excepción personalizada con statusCode y detalles
│   └── api_service.dart         # Cliente HTTP centralizado con validación de códigos y timeouts
├── themes/
│   └── app_theme.dart           # Tokens y ThemeData oficial del Design System Zeris Dark
├── views/
│   ├── dashboard_view.dart      # Home con 4 tarjetas interactivas hacia cada endpoint
│   ├── list_view.dart           # Listado con ListView.builder, búsqueda y 4 estados
│   └── detail_view.dart         # Vista de detalle con métricas en panel Zeris
├── widgets/
│   ├── dashboard_card.dart      # Card con kicker, ícono y elevación por superficie
│   ├── empty_state.dart         # Estado vacío cuando no hay registros
│   ├── error_retry.dart         # Estado de fallo con botón gradiente para reintentar
│   ├── item_tiles.dart          # Tiles específicos por recurso para ListView
│   └── loading_indicator.dart   # Spinner índigo con panel translúcido
└── main.dart                    # Entrypoint con inicialización de .env y MaterialApp.router
```

---

## 📦 Paquetes Implementados (`pubspec.yaml`)

| Paquete | Versión | Rol en la Aplicación |
|---|---|---|
| `http` | `^1.2.1` | Realización de peticiones HTTP REST asíncronas hacia API Colombia. |
| `go_router` | `^14.2.0` | Enrutamiento declarativo con rutas nombradas y paso seguro de parámetros por URL. |
| `flutter_dotenv` | `^5.1.0` | Carga de variables de entorno seguras (`API_BASE_URL`) desde el archivo `.env`. |
| `google_fonts` | `^6.2.1` | Tipografía Inter/Manrope optimizada para el sistema de diseño Zeris. |

---

## 🚦 Manejo de Estados en la UI

La aplicación implementa un flujo reactivo completo en la capa de presentación:

1. **Estado Cargando (`loading`):** Renderiza el widget `LoadingIndicator` con un spinner estilizado índigo-violeta y panel oscuro.
2. **Estado Éxito (`success`):** Muestra los datos consumidos en un `ListView.builder` de alto rendimiento, con soporte para filtrado en tiempo real y gesto de recarga (`RefreshIndicator`).
3. **Estado Error (`error`):** En caso de desconexión (`SocketException`), tiempo agotado (`TimeoutException`) o respuesta != 200 de la API, captura la excepción como `ApiException` y despliega `ErrorRetry` con el mensaje claro y un botón CTA con gradiente índigo para reintentar la llamada.
4. **Estado Vacío (`empty`):** Muestra `EmptyState` cuando la categoría no tiene registros o cuando el filtro de búsqueda no encuentra coincidencias.

---

## 🧭 Rutas Implementadas con `go_router`

Se configuró un árbol de rutas declarativo con nombres unívocos:

| Nombre | Ruta | Parámetros | Vista Renderizada |
|---|---|---|---|
| `dashboard` | `/` | Ninguno | `DashboardView` |
| `list` | `/list/:endpoint` | `endpoint` (p. ej. `department`, `president`, `touristic-attraction`, `typical-dish`) | `ListViewScreen` |
| `detail` | `/list/:endpoint/detail/:id` | `endpoint`, `id` (entero del registro) | `DetailView` |

### Ejemplo de Navegación con Parámetros

```dart
// Desde Dashboard hacia Listado:
context.goNamed('list', pathParameters: {'endpoint': 'president'});

// Desde Listado hacia Detalle:
context.goNamed('detail', pathParameters: {
  'endpoint': 'president',
  'id': '1',
});
```

En caso de rutas inexistentes, `errorBuilder` captura la excepción y muestra una pantalla 404 personalizada con botón de retorno al Dashboard.

---

## 📄 Ejemplos de Respuestas JSON de la API

### 1. Departamentos (`GET /Department/1`)

```json
{
  "id": 1,
  "name": "Amazonas",
  "description": "Amazonas es uno de los treinta y dos departamentos...",
  "cityCapitalId": 1,
  "municipalities": 2,
  "surface": 109665,
  "population": 82068,
  "phonePrefix": "8",
  "cityCapital": {
    "id": 1,
    "name": "Leticia"
  }
}
```

### 2. Presidentes (`GET /President/1`)

```json
{
  "id": 1,
  "image": "https://upload.wikimedia.org/.../José_María_Campo_Serrano_1.jpg",
  "name": "José María",
  "lastName": "Campo Serrano",
  "startPeriodDate": "1886-08-05",
  "endPeriodDate": "1887-01-06",
  "politicalParty": "Partido Nacional",
  "description": "José María Campo Serrano fue un político, abogado y militar...",
  "city": {
    "id": 709,
    "name": "Santa Marta"
  }
}
```

### 3. Atracciones Turísticas (`GET /TouristicAttraction/1`)

```json
{
  "id": 1,
  "name": "Museo del oro",
  "description": "El Museo del Oro del Banco de la República de Colombia...",
  "images": [
    "https://upload.wikimedia.org/.../800px-BOG_Museo_del_Oro.JPG"
  ],
  "latitude": "4.601919",
  "longitude": "-74.072",
  "city": {
    "id": 167,
    "name": "Bogotá D.C."
  }
}
```

### 4. Platos Típicos (`GET /TypicalDish/1`)

```json
{
  "id": 1,
  "name": "Bandeja Paisa",
  "description": "La bandeja paisa es el orgullo de la cocina paisa...",
  "ingredients": "Frijoles, arroz, carne molida, chicharrón, huevo, plátano maduro...",
  "imageUrl": "https://apicolombiastorage.blob.core.windows.net/.../1. Bandeja Paisa.jpg",
  "department": {
    "id": 2,
    "name": "Antioquia"
  }
}
```

---

## 🎨 Sistema de Diseño Zeris Dark

La interfaz adopta rigurosamente los principios visuales de **Zeris**:

- **Fondo Neutral Frío:** `#0B0B12` como color base (`pageDark`), evitando negros y blancos puros.
- **Superficies de Panel:** Fondo `#151625` con bordes sutiles de 1px en violeta translúcido (`#7C3AED` al 20%) y elevaciones suaves por sombra difusa.
- **Regla del Acento Único:** El gradiente índigo-violeta (`#6366F1` → `#7C3AED`) se reserva para los botones de acción principal (CTA) como el reintento de conexión y branding.
- **Jerarquía Tipográfica:** Títulos en pesos 700 a 900 y kickers en 10px mayúsculas con espaciado amplio (`letter-spacing: 1.4`).

---

## 🚀 Guía de Instalación y Ejecución

### 1. Clonar el repositorio y ubicarse en la rama

```bash
git clone https://github.com/Cristian-Daniel-Cardona-Correa/proyecto_curso.git
cd proyecto_curso
git checkout feature/taller_api_colombia
```

### 2. Configurar variables de entorno

El archivo `.env` ya se encuentra configurado en la raíz del proyecto y registrado en los assets de `pubspec.yaml`:

```env
API_BASE_URL=https://api-colombia.com/api/v1
```

### 3. Instalar dependencias

```bash
flutter pub get
```

### 4. Ejecutar pruebas automatizadas

```bash
flutter test test/models_test.dart test/api_service_test.dart test/dashboard_view_test.dart
```

### 5. Iniciar la aplicación

```bash
flutter run
```

---

## 🌿 Flujo GitFlow y Commits Realizados

El desarrollo siguió estrictamente la metodología GitFlow con commits atómicos y semánticos:

1. `chore(config): configurar flutter_dotenv, http y go_router con variables de entorno`
2. `feat(theme): implementar tema Zeris con paleta indigo-violeta y tokens de diseno`
3. `feat(models): implementar modelos de Department, President, TouristicAttraction y TypicalDish con serializacion JSON`
4. `feat(services): crear capa de servicio ApiService y excepciones personalizadas con manejo de status codes y timeout`
5. `feat(widgets): crear componentes reutilizables Zeris (DashboardCard, LoadingIndicator, ErrorRetry, EmptyState, ItemTiles)`
6. `feat(views): implementar DashboardView, ListViewScreen y DetailView con estados reactivos`
7. `feat(routes): configurar GoRouter con rutas nombradas, paso de parametros y errorBuilder`
8. `fix(ui): corregir CardThemeData en AppTheme, EdgeInsets y fallbacks de error en imagenes`
9. `fix(dashboard): asegurar ajuste flexible en DashboardCard para evitar desbordamientos`
10. `test: anadir pruebas unitarias de modelos, api_service con MockClient y widget tests de DashboardView`
11. `docs: documentar endpoints, arquitectura, rutas go_router y guia de ejecucion en README.md`
