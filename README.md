# 📱 Gestor de Tareas - iOS con SwiftData

<p align="center">
  <img src="https://img.shields.io/badge/iOS-17.0+-blue.svg" alt="iOS 17.0+"/>
  <img src="https://img.shields.io/badge/Swift-5.9-orange.svg" alt="Swift 5.9"/>
  <img src="https://img.shields.io/badge/SwiftUI-5.9-green.svg" alt="SwiftUI"/>
  <img src="https://img.shields.io/badge/SwiftData-Enabled-purple.svg" alt="SwiftData"/>
</p>

Una aplicación completa de gestión de tareas para iOS que implementa **SwiftData** para persistencia de datos, **System View Controllers** para funcionalidades nativas, y exportación/importación de datos.

## 🎯 Características Principales

### ✅ Gestión Completa de Tareas
- **Crear, Editar y Eliminar** tareas con persistencia automática
- **Adjuntar imágenes** desde la galería de fotos
- **Prioridades**: Baja, Media, Alta con indicadores visuales
- **Fechas de vencimiento** con alertas visuales
- **Estados**: Pendiente/Completada con swipe gestures

### 💾 Persistencia de Datos
- **SwiftData**: Almacenamiento automático y eficiente
- **UserDefaults**: Preferencias de usuario (tema, ordenamiento)
- **Exportación/Importación JSON**: Backup y restauración de datos
- **FileManager**: Gestión de archivos en Documents directory

### 🎨 Interfaz de Usuario
- **Modo Oscuro/Claro**: Tema persistente
- **Búsqueda en tiempo real**: Por título y descripción
- **Filtros inteligentes**: Todas, Completadas, Pendientes, Vencidas
- **Ordenamiento flexible**: Por fecha, prioridad o alfabético
- **Animaciones suaves**: Transiciones con SwiftUI
- **Swipe Actions**: Completar, eliminar y compartir

### 📤 Compartir y Exportar
- **ActivityViewController**: Compartir tareas por correo, mensajes, etc.
- **Exportar todas las tareas** a JSON
- **Importar desde archivo** JSON
- **Compartir tareas individuales** con todos sus detalles

## 📋 Requisitos

- **iOS 17.0+**
- **Xcode 15.0+**
- **Swift 5.9+**

## 🚀 Instalación y Configuración

### 1. Clonar el Repositorio
```bash
git clone git@github.com:jesus-garza-tecmilenio/iOS-tema13.git
cd iOS-tema13
```

### 2. Abrir en Xcode
```bash
open Tema13Swift.xcodeproj
```

### 3. Configurar Permisos (⚠️ IMPORTANTE)
Antes de ejecutar la app, debes configurar los permisos de acceso a fotos:

1. Selecciona el proyecto **Tema13Swift** en el navegador
2. Selecciona el target **"Tema13Swift"**
3. Ve a la pestaña **"Info"**
4. Agrega una nueva entrada: **Privacy - Photo Library Usage Description**
5. Valor: `Necesitamos acceso a tus fotos para adjuntar imágenes a las tareas`

### 4. Ejecutar la Aplicación
- Selecciona un simulador o dispositivo físico
- Presiona **⌘ + R** o el botón ▶️ para compilar y ejecutar

## 📂 Estructura del Proyecto

```
Tema13Swift/
├── 📄 README.md                          # Este archivo
├── 📄 INICIO_RAPIDO.md                   # Guía de inicio rápido
├── 📄 REFERENCIA_RAPIDA.md               # Referencia técnica
├── 📄 CONFIGURACION_PERMISOS.md          # Guía de configuración
├── 📄 GUIA_DEBUG_SWIFTDATA.md            # Debugging con SwiftData
│
└── Tema13Swift/
    ├── 📱 Tema13SwiftApp.swift           # Entry point de la app
    ├── 📱 ContentView.swift              # Vista principal
    │
    ├── 📁 Models/
    │   └── Tarea.swift                   # Modelo SwiftData
    │
    ├── 📁 Views/
    │   ├── TareaFormView.swift           # Formulario crear/editar
    │   ├── TareaDetailView.swift         # Detalle de tarea
    │   ├── SettingsView.swift            # Configuración
    │   └── DebugDataView.swift           # Vista de debug
    │
    ├── 📁 ViewModels/
    │   └── TareaViewModel.swift          # Lógica de negocio
    │
    └── 📁 Utilities/
        ├── Constants.swift               # Constantes de la app
        ├── FileManager+Extensions.swift  # Extensiones FileManager
        └── ShareSheet.swift              # Wrapper para compartir
```

## 🎓 Conceptos Técnicos Implementados

### SwiftData (Persistencia)
- **@Model**: Macro para definir modelos persistentes
- **ModelContainer**: Contenedor de datos principal
- **ModelContext**: Contexto para operaciones CRUD
- **@Query**: Property wrapper para consultas reactivas

### System View Controllers
- **PHPickerViewController**: Selector de fotos nativo
- **UIActivityViewController**: Panel de compartir del sistema
- **UIViewControllerRepresentable**: Bridge SwiftUI-UIKit

### Arquitectura
- **MVVM**: Model-View-ViewModel pattern
- **ObservableObject**: Para ViewModels reactivos
- **@Published**: Propiedades observables
- **@Environment**: Inyección de dependencias

## 📖 Documentación Adicional

- **[🚀 INICIO_RAPIDO.md](INICIO_RAPIDO.md)**: Guía paso a paso para comenzar
- **[📚 REFERENCIA_RAPIDA.md](REFERENCIA_RAPIDA.md)**: API y funcionalidades
- **[⚙️ CONFIGURACION_PERMISOS.md](CONFIGURACION_PERMISOS.md)**: Configuración de permisos
- **[🐛 GUIA_DEBUG_SWIFTDATA.md](GUIA_DEBUG_SWIFTDATA.md)**: Debugging y troubleshooting

## 🎯 Casos de Uso

### Crear una Tarea
1. Tap en el botón **"+"**
2. Ingresa título (obligatorio)
3. Opcionalmente: descripción, fecha, prioridad, imagen
4. Tap **"Crear"**

### Completar una Tarea
- **Swipe izquierdo** sobre la tarea → Tap **"Completar"**
- O desde el detalle: Toggle del estado

### Exportar Datos
1. Ve a **Configuración** (ícono engranaje)
2. Tap **"Exportar Todas las Tareas"**
3. Selecciona la app destino (Archivos, Mail, etc.)

### Compartir una Tarea
- **Swipe derecho** sobre la tarea → Tap **"Compartir"**
- O desde el detalle: Menú **⋯** → **"Compartir"**

## 🔧 Tecnologías Utilizadas

- **SwiftUI**: Framework de UI declarativo
- **SwiftData**: Framework de persistencia moderna
- **PhotosUI**: Selector de fotos del sistema
- **Combine**: Programación reactiva
- **Foundation**: Utilidades base (FileManager, JSONEncoder, etc.)

## 👨‍💻 Autor

**Jesús Garza** - TecMilenio
- Curso: Desarrollo de Aplicaciones iOS
- Tema 13: SwiftData y System View Controllers

## 📄 Licencia

Este proyecto es material educativo para el curso de iOS en TecMilenio.

## 🤝 Contribuciones

Este es un proyecto educativo. Si encuentras errores o tienes sugerencias:
1. Abre un **Issue**
2. O envía un **Pull Request**

---

<p align="center">
  Desarrollado con ❤️ usando Swift y SwiftUI
</p>
