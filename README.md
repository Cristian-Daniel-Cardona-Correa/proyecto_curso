# Zeris Mobile — Taller 1: StatefulWidget & setState()

Aplicación móvil construida en **Flutter** que traduce fielmente el sistema de diseño y la identidad visual de **Zeris**, una plataforma fitness web desarrollada originalmente en SvelteKit. Este proyecto corresponde a la entrega del **Taller 1** para la asignatura de desarrollo móvil.

---

## 👤 Datos del Estudiante

- **Nombre Completo:** Cristian Daniel Cardona Correa
- **Correo Institucional:** cristian.cardona02@uceva.edu.co
- **Asignatura:** Desarrollo Móvil / Programación Móvil con Flutter
- **Institución:** UCEVA (Unidad Central del Valle del Cauca)
- **Repositorio en GitHub:** [https://github.com/Cristian-Daniel-Cardona-Correa/proyecto_curso](https://github.com/Cristian-Daniel-Cardona-Correa/proyecto_curso)
- **Rama del Taller:** `feature/taller1`

---

## 🎯 Objetivo del Taller

1. Construir una pantalla básica e interactiva en Flutter haciendo uso de `StatefulWidget` y evidenciando el ciclo de actualización de la interfaz con `setState()`.
2. Replicar fielmente los tokens de diseño (colores OKLCH traducidos a hex ARGB, tipografía Manrope, bordes redondeados y elevaciones por superficie/sombra) de **Zeris Fitness Platform**.
3. Aplicar buenas prácticas profesionales de control de versiones con Git (flujo con ramas `main`, `dev` y `feature/taller1`, commits semánticos y flujo de Pull Request).

---

## 🎨 Sistema de Diseño (Design System Zeris)

La interfaz respeta estrictamente las directrices del design system de Zeris:

- **"The One Accent Gradient Rule":** El gradiente índigo-violeta (`#6366F1` → `#7C3AED`) se reserva exclusivamente para la acción principal (botón de entrenamiento / CTA), evitando su saturación decorativa.
- **"No Pure White Rule":** Se eliminan blancos y negros puros `#FFFFFF`/`#000000` en modo oscuro; se emplean tonos matizados (`#0B0B12`, `#1B1C2E`, `#EEEDF7`, `#F7F6FB`).
- **Kickers Editoriales:** Etiquetas en mayúsculas sostenidas, 10px, peso 700 y espaciado amplio (`letterSpacing: 1.4`).
- **Elevación por Superficie:** Sustitución de `elevation` plano de Material por combinación de contenedor translúcido (`.fp-panel`), borde sutil de 1px (`#7C3AED` al 22%) y sombra profunda difusa (`blurRadius: 40, offset: Offset(0, 10)`).

### Mapeo de Tokens de Color (OKLCH a Flutter ARGB)

| Token Web (CSS / OKLCH) | Equivalente Flutter | Hex / ARGB | Rol en la App |
|---|---|---|---|
| `--fp-page` (oscuro) | `ZerisColors.page` | `Color(0xFF0B0B12)` | Fondo de pantalla (`scaffoldBackgroundColor`) |
| `--fp-panel-bg` (oscuro) | `ZerisColors.panelBg` | `Color(0xE01B1C2E)` | Fondo translúcido de paneles (`fp-panel`) |
| `--fp-panel-border` | `ZerisColors.panelBorder` | `Color(0x387C3AED)` | Borde de 1px en paneles y separadores |
| `--fp-panel-shadow` | `ZerisColors.panelShadow` | `BoxShadow(...)` | Sombra difusa suave |
| `--fp-topbar-bg` | `ZerisColors.topbarBg` | `Color(0xE00B0B12)` | Fondo translúcido de AppBar |
| `--fp-fg` | `ZerisColors.fg` | `Color(0xFFEEEDF7)` | Texto de cuerpo principal |
| `--fp-fg-strong` | `ZerisColors.fgStrong` | `Color(0xFFF7F6FB)` | Títulos y énfasis |
| `--fp-ui-muted` | `ZerisColors.uiMuted` | `Color(0xFF84849B)` | Metadatos e iconos secundarios |
| `--fp-kicker` | `ZerisColors.kicker` | `Color(0xFFA5A0F0)` | Kickers e iconos activos |
| `primary-indigo` | `ZerisColors.primaryIndigo` | `Color(0xFF6366F1)` | Acento índigo de marca |
| `accent-violet` | `ZerisColors.accentViolet` | `Color(0xFF7C3AED)` | Acento violeta |
| Gradiente CTA | `zerisCtaGradient` | `LinearGradient(...)` | Gradiente acción principal |

---

## 📱 Requisitos Técnicos Implementados

1. **AppBar estilo `.fp-topbar`:** Con fondo translúcido (`Color(0xE00B0B12)`), borde inferior sutil de 1px (`Color(0x387C3AED)`) y título dinámico inicializado en `"Hola, Flutter"` mediante una variable de estado.
2. **Texto con Nombre del Estudiante:** Texto centrado en tipografía Manrope 18px, weight 800: `Cristian Daniel Cardona Correa`.
3. **Row con dos Imágenes:**
   - `Image.network('https://picsum.photos/150')`: Con esquinas redondeadas (`BorderRadius.circular(16)`), indicador de carga y control de error en caso de falta de red.
   - `Image.asset('assets/logo_zeris.png')`: Isotipo oficial de Zeris con radio de 16px.
4. **Botón Principal interactivo (.fp-cta-training / ElevatedButton):**
   - Diseñado con `LinearGradient(#6366F1 → #7C3AED)`, radio de 16px, padding de 16x24 y glow shadow índigo al 45%.
   - Al presionarse ejecuta `setState()`, alternando el título de la AppBar entre `"Hola, Flutter"` y `"¡Título cambiado!"`.
   - Lanza un `SnackBar` flotante con el texto `"Título actualizado"` con el estilo visual de panel Zeris.
5. **Widget adicional 1 — Panel de Motivación (.fp-panel):**
   - Contenedor decorado con `zerisPanelDecoration()`, padding de 24px, kicker `"TU SERIE DE HOY, PRIMERO"` (mayúsculas, tracking amplio) y texto motivador en estilo body.
6. **Widget adicional 2 — Lista de Grupos Musculares (.fp-panel con ListView):**
   - Contenedor de altura fija (240px) con `ListView` que lista 4 `ListTile`: *Pecho*, *Espalda*, *Piernas*, *Hombros* con iconos temáticos en color kicker y divisores con borde Zeris.
7. **Diseño y Maquetación:** Organizado jerárquicamente con `SingleChildScrollView`, `Column`, `Padding(16)` y espaciados `SizedBox(height: 24)`.

---

## ⚙️ Instrucciones de Ejecución

### Prerrequisitos
- Tener instalado el SDK de Flutter (versión estable 3.x o superior).
- Tener un emulador Android/iOS configurado o dispositivo físico conectado por USB con depuración habilitada.

### Pasos para clonar y ejecutar

1. **Clonar el repositorio:**
   ```bash
   git clone https://github.com/Cristian-Daniel-Cardona-Correa/proyecto_curso.git
   cd proyecto_curso
   ```

2. **Pasar a la rama del taller:**
   ```bash
   git checkout feature/taller1
   ```

3. **Descargar las dependencias:**
   ```bash
   flutter pub get
   ```

4. **Ejecutar pruebas automatizadas:**
   ```bash
   flutter test
   ```

5. **Verificar análisis estático de código:**
   ```bash
   flutter analyze
   ```

6. **Ejecutar la aplicación en el emulador o dispositivo:**
   ```bash
   flutter run
   ```

---

## 📖 Justificación Teórica: Uso de StatefulWidget y setState()

> **Párrafo explicativo para el informe PDF:**
>
> En el ecosistema de Flutter, la interfaz de usuario es declarativa y se reconstruye a partir del estado de la aplicación. Para este taller se implementó un `StatefulWidget` en la clase `HomePage`, la cual delega su ciclo de vida y mutabilidad a la clase `_HomePageState`. A diferencia de un `StatelessWidget` (cuyo contenido es inmutable una vez instanciado), el `StatefulWidget` permite conservar variables mutables a lo largo del tiempo, como la variable de estado `_titulo`. 
>
> Al interactuar con el botón principal de acción (`CAMBIAR TÍTULO`), se invoca el método `setState()`. Esta función es fundamental porque notifica al framework de Flutter que el estado interno del widget ha cambiado; Flutter agenda inmediatamente una llamada al método `build()` del State correspondiente, recalculando el sub-árbol de widgets de forma eficiente y reflejando en pantalla la alternancia entre `"Hola, Flutter"` y `"¡Título cambiado!"`, al mismo tiempo que despacha el `SnackBar` flotante mediante el `ScaffoldMessenger`. Sin el uso de `setState()`, la variable interna cambiaría de valor en memoria pero la interfaz gráfica permanecería estática e insensible al cambio.

---

## 🌿 Flujo de Trabajo en Git

El proyecto sigue una estrategia basada en ramas estructuradas para control de versiones:

- `main`: Rama de producción / estable.
- `dev`: Rama de desarrollo base donde convergen los talleres.
- `feature/taller1`: Rama de trabajo específica para el desarrollo del Taller 1.

```
(main)           [Commit Inicial] ───────────────────────────> [Merge de dev]
                         \                                           ▲
(dev)                     └───> [Rama base dev] ─────────────────────┤
                                      \                               ▲
(feature/taller1)                      └───> [Commits Taller 1] ─────┘
                                                (Pull Request)
```

### Comandos Git utilizados para este flujo:
```bash
# 1. Crear y pasar a la rama del taller desde dev
git checkout dev
git checkout -b feature/taller1

# 2. Realizar commits descriptivos
git add .
git commit -m "feat: implementar design tokens y tema Zeris"
git commit -m "feat: construir HomePage con StatefulWidget, imagenes y lista muscular"
git commit -m "docs: documentar instrucciones, justificacion teorica y evidencias del Taller 1"

# 3. Integración dev y main
git checkout dev
git merge feature/taller1
git checkout main
git merge dev
```

---

## 📸 Evidencias de la Aplicación (Para Informe PDF)

*(Sección reservada para anexar las capturas de pantalla tomadas del emulador o dispositivo)*

| Evidencia | Descripción | Estado |
|---|---|---|
| **Captura 1** | Estado inicial de la aplicación (AppBar con `"Hola, Flutter"`, nombre del estudiante, Row con imágenes, botón CTA y paneles). | `[Espacio para captura]` |
| **Captura 2** | Estado tras presionar el botón: Título cambiado a `"¡Título cambiado!"`. | `[Espacio para captura]` |
| **Captura 3** | Notificación `SnackBar` flotante en pantalla con `"Título actualizado"`. | `[Espacio para captura]` |
| **Captura 4** | Funcionamiento y visualización de los 2 widgets adicionales: Panel motivacional (`fp-panel`) y `ListView` de grupos musculares. | `[Espacio para captura]` |
| **Captura 5** | Evidencia de ramas Git en terminal o GitHub (`feature/taller1`, `dev`, `main`) y registro de commits. | `[Espacio para captura]` |
