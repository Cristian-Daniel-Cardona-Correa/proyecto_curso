# 📋 Historial de Lanzamientos y Release Notes — Firebase App Distribution

Este documento compila las notas de versión (Release Notes) y la bitácora de control de cambios utilizada para la distribución y pruebas de control de calidad (QA) mediante **Firebase App Distribution**.

---

## 🚀 Versión 1.0.0 (Build 1) — Lanzamiento Inicial (Initial Release)

- **Fecha:** 2 de Noviembre de 2026
- **Version Name:** `1.0.0`
- **Version Code:** `1`
- **Destinatarios / Grupo:** `QA_Clase`
- **Testers:**
  - `dduran@uceva.edu.co` (Docente evaluador)
  - `cristian.cardona02@uceva.edu.co` (Tester QA interno)
- **Estado de Pruebas:** Aprobado / Estable

### 📝 Notas de Versión (Release Notes para Firebase Console)
```text
[Lanzamiento Inicial v1.0.0+1]
- Despliegue de la app de Datos Abiertos de Colombia con arquitectura por capas limpias y GoRouter.
- Dashboard interactivo con tarjetas Zeris para 4 recursos: Departamentos, Presidentes, Atracciones y Platos Típicos.
- Vistas de listado con búsqueda y filtrado dinámico en memoria.
- Vistas de detalle en profundidad con consumo directo por ID.
- Manejo determinista de 4 estados: cargando, éxito, error con reintento y vacío.
- Configuración de variables de entorno con flutter_dotenv (.env).
- Permisos configurados: android.permission.INTERNET.
Tester de pruebas asignado: dduran@uceva.edu.co.
```

---

## ⚡ Versión 1.0.1 (Build 2) — Actualización Incremental (Incremental Update)

- **Fecha:** 2 de Noviembre de 2026
- **Version Name:** `1.0.1`
- **Version Code:** `2`
- **Destinatarios / Grupo:** `QA_Clase`
- **Testers:**
  - `dduran@uceva.edu.co` (Docente evaluador)
  - `cristian.cardona02@uceva.edu.co` (Tester QA interno)
- **Estado de Pruebas:** Verificado / En distribución

### 📝 Notas de Versión (Release Notes para Firebase Console)
```text
[Actualización Incremental v1.0.1+2]
- Incremento de versión semántica de 1.0.0+1 a 1.0.1+2 para validación del ciclo de distribución continua en Firebase App Distribution.
- Integración visual de badge dinámico en DashboardView indicando la versión activa (v1.0.1 • BUILD 2).
- Optimización en el refresco de pantalla ante reintentos de conexión de red.
- Depuración de metadatos de lanzamiento y validación de compatibilidad con Android 14/15/16.
Tester de pruebas asignado: dduran@uceva.edu.co.
```

---

## 🛠️ Bitácora de QA (Control de Calidad e Incidencias)

| Versión | Fecha | Caso de Prueba / Flujo | Incidencia Detectada | Resolución / Estado |
|---|---|---|---|---|
| **1.0.0 (1)** | 02/11/2026 | Instalación inicial mediante APK en Android | Advertencia de orígenes desconocidos | Se habilitó "Permitir instalación de fuentes desconocidas" en ajustes de seguridad. **Aprobado**. |
| **1.0.0 (1)** | 02/11/2026 | Consumo de API en modo release | Error de conexión inicial si no hay permiso de red | Se verificó `android.permission.INTERNET` en `AndroidManifest.xml`. **Aprobado**. |
| **1.0.1 (2)** | 02/11/2026 | Actualización sobre versión previa 1.0.0 | Comprobación de retención de datos y reemplazo de binario | Android actualizó exitosamente el paquete `com.example.proyecto_curso` conservando configuración y mostrando el nuevo badge `v1.0.1 • BUILD 2`. **Aprobado**. |
