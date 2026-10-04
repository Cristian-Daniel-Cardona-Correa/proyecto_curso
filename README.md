# Taller 1 - Flutter Básico

Este repositorio contiene la solución al Taller 1 de desarrollo móvil con Flutter, evidenciando el uso de `StatefulWidget`, `setState()` y componentes visuales adicionales.

## Datos del Estudiante
- **Nombre:** Cristian Daniel Cardona Correa
- **Código:** 230232024

## Requisitos Generales
- `HomePage` con título manejado con variables de estado.
- `setState()` accionado a través del botón (`ElevatedButton.icon`), refrescando la UI y el texto del AppBar, generando que se lance un `SnackBar` en la acción.
- Filas de imágenes cargando dinámicamente desde assets locales e imágenes de red `Image.network` y `Image.asset`.
- Widgets adicionales demostrados (`Stack` animado, `Container` adornado, un `ListView` horizontal que enlista componentes extra usados debajo de las imágenes y la acción del botón).

## Pasos para ejecutar

1. Clonar el repositorio y acceder a la rama principal (o estar en la rama de `feature/taller1`).
2. Resolver y descargar las dependencias del proyecto ejecutando:
   ```bash
   flutter pub get
   ```
3. Correr la aplicación en el dispositivo conectado (emulador web, Android o iOS):
   ```bash
   flutter run
   ```

## Capturas

1. Estado inicial
<img width="452" height="886" alt="imagen" src="https://github.com/user-attachments/assets/b0b35958-f8e4-4058-9117-97e7d84f9063" />

2. Cambio de titulo
<img width="457" height="899" alt="imagen" src="https://github.com/user-attachments/assets/0fe5031f-cdaa-4f22-9229-5fdb029281ea" />

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


# Zeris Mobile — Taller 2: Asincronía, Segundo Plano y Servicios

Extensión de la plataforma **Zeris** orientada al procesamiento asíncrono, concurrencia en segundo plano y gestión eficiente del ciclo de vida de recursos sin bloquear el hilo de la interfaz de usuario (*UI Thread*).

- **Rama de Trabajo:** `feature/taller_segundo_plano`
- **Rama Base:** `dev`
- **Flujo de Integración:** `feature/taller_segundo_plano` $\rightarrow$ `dev` $\rightarrow$ `main`

---

## 🧠 ¿Cuándo usar cada tecnología?

| Mecanismo | ¿Cuándo usarlo? | ¿Crea un nuevo hilo? | Caso de uso en Zeris |
|---|---|---|---|
| **`Future` / `async` / `await`** | Para operaciones de **I/O-bound** (red, lectura de bases de datos, disco o temporizadores de espera). | **No** (usa el Event Loop del hilo principal). | `FakeService.fetchWorkoutData()`: Consulta remota de planes y rutinas sin congelar la app. |
| **`Timer` / `Timer.periodic`** | Para programar eventos diferidos o tareas repetitivas en intervalos fijos. | **No** (se agenda en la cola de eventos). | `StopwatchScreen`: Refresco del marcador a 100 ms combinado con `Stopwatch` para precisión absoluta. |
| **`Isolate` (`Isolate.spawn`)** | Para tareas **CPU-bound** (procesamiento pesado de datos, algoritmos matemáticos, compresión, parseo de JSON masivo). | **Sí** (espacio de memoria propio y nuevo hilo del SO). | `IsolateDemoScreen`: Cálculo de 500M de iteraciones sin detener la animación a 60 FPS. |

---

## 🗺️ Diagrama y Flujo de Pantallas

```
[HomePage (Pantalla Principal)]
  │
  ├──> [Demo Async (Future)] ───> Botón "Consultar" ───> Estados: Cargando / Éxito / Error (try-catch)
  │
  ├──> [Cronómetro (Timer)]   ───> Iniciar / Pausar / Reanudar / Reiniciar (Stopwatch + Timer.periodic 100ms)
  │
  └──> [Tarea Pesada (Isolate)] ─┬─> "Ejecutar en Isolate" (Hilo independiente a 60 FPS, spinner fluido)
                                 └─> "Ejecutar en Hilo Principal" (Demuestra congelamiento del Event Loop)
```

---
