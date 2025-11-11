# Referencia Rápida - Gestor de Tareas

## 🎯 Funcionalidades Implementadas

### ✅ Persistencia de Datos
- **SwiftData**: Modelo `Tarea` con @Model para persistencia automática
- **UserDefaults**: Tema oscuro y preferencias de ordenamiento
- **FileManager**: Exportación/importación JSON en Documents directory

### ✅ System View Controllers
- **PhotosPicker**: Selección de fotos desde la galería
- **ActivityViewController**: Compartir tareas por correo, mensajes, etc.
- **ShareSheet**: Wrapper personalizado para compartir archivos

### ✅ Modelo de Datos (Tarea)
```swift
- id: UUID                    // Identificador único
- titulo: String              // Título de la tarea
- descripcion: String         // Descripción detallada
- completada: Bool            // Estado de completitud
- imagenData: Data?           // Imagen adjunta (opcional)
- fechaCreacion: Date         // Fecha de creación
- fechaVencimiento: Date?     // Fecha límite (opcional)
- prioridad: Int              // 1=Baja, 2=Media, 3=Alta
```

### ✅ Características de UI
- **Filtros**: Todas, Completadas, Pendientes, Vencidas
- **Búsqueda**: En tiempo real por título y descripción
- **Ordenamiento**: Fecha, Prioridad, Alfabético
- **Swipe Actions**: Completar (izq.), Eliminar/Compartir (der.)
- **Tema**: Claro/Oscuro persistente
- **Animaciones**: Transiciones suaves con SwiftUI

## 📱 Flujo de Usuario

### Crear Tarea
```
1. Tap botón "+" → TareaFormView
2. Llenar formulario (título obligatorio)
3. Opcionalmente: agregar foto, prioridad, fecha
4. Tap "Crear" → Guarda en SwiftData
```

### Editar Tarea
```
1. Tap en tarea → TareaDetailView
2. Tap menú (⋯) → "Editar"
3. Modificar campos inline
4. Automáticamente guarda al salir del modo edición
```

### Compartir Tarea
```
Método 1 (Swipe):
- Deslizar izquierda → Botón azul "Compartir"

Método 2 (Detalle):
- Tap tarea → Menú (⋯) → "Compartir"
- Incluye texto + imagen (si existe)
```

### Exportar/Importar
```
Exportar:
1. Menú (≡) → "Exportar a JSON"
2. Archivo guardado: Documents/tareas_export_YYYY-MM-DD.json
3. Opción de compartir archivo

Importar:
1. Menú (≡) → "Importar desde JSON"
2. Seleccionar archivo de la lista
3. Tareas importadas automáticamente
```

## 🔧 Arquitectura

### Archivos por Módulo

**Models/**
- `Tarea.swift` - @Model SwiftData, Codable, JSON serialization

**Views/**
- `ContentView.swift` - Lista principal, filtros, búsqueda
- `TareaFormView.swift` - Formulario de creación
- `TareaDetailView.swift` - Vista de detalle con edición
- `SettingsView.swift` - Configuración de la app

**ViewModels/**
- `TareaViewModel.swift` - Lógica de filtrado, ordenamiento, UserDefaults

**Utilities/**
- `Constants.swift` - Enums: Filtro, Ordenamiento
- `FileManager+Extensions.swift` - Export/import JSON
- `ShareSheet.swift` - UIActivityViewController wrapper

## 🎨 Código Importante

### Inicialización del ModelContainer
```swift
// Tema13SwiftApp.swift
let schema = Schema([Tarea.self])
let modelConfiguration = ModelConfiguration(
    schema: schema, 
    isStoredInMemoryOnly: false
)
```

### Query de SwiftData
```swift
// ContentView.swift
@Query private var todasLasTareas: [Tarea]
```

### Operaciones CRUD
```swift
// Crear
modelContext.insert(tarea)
try? modelContext.save()

// Actualizar
tarea.completada.toggle()
try? modelContext.save()

// Eliminar
modelContext.delete(tarea)
try? modelContext.save()
```

### Export a JSON
```swift
FileManager.exportarTareasAJSON(tareas: todasLasTareas)
// → Documents/tareas_export_2025-11-11.json
```

### PhotosPicker
```swift
PhotosPicker(selection: $selectedPhoto, matching: .images) {
    Label("Seleccionar Foto", systemImage: "photo")
}

.onChange(of: selectedPhoto) { _, newValue in
    Task {
        if let data = try? await newValue?.loadTransferable(type: Data.self) {
            imagenData = data
        }
    }
}
```

### ActivityViewController (Compartir)
```swift
let activityVC = UIActivityViewController(
    activityItems: [texto, uiImage], 
    applicationActivities: nil
)
rootVC.present(activityVC, animated: true)
```

## 🐛 Debug Rápido

### Ver datos de SwiftData
```swift
// En Preview o código de prueba
.onAppear {
    print("Tareas totales: \(todasLasTareas.count)")
    todasLasTareas.forEach { print($0.titulo) }
}
```

### Ver archivos exportados
```bash
# En terminal del simulador
ls -la ~/Library/Developer/CoreSimulator/Devices/*/data/Containers/Data/Application/*/Documents/
```

### Resetear datos
```swift
// Eliminar todas las tareas
todasLasTareas.forEach { modelContext.delete($0) }
try? modelContext.save()

// Resetear UserDefaults
UserDefaults.standard.removeObject(forKey: Constants.temaOscuroKey)
UserDefaults.standard.removeObject(forKey: Constants.ordenamientoKey)
```

## ⚠️ Importante Recordar

1. **Permisos**: Agregar `NSPhotoLibraryUsageDescription` en Info.plist
2. **SwiftData**: Requiere iOS 17+ (para versiones anteriores usar CoreData)
3. **@Query**: Actualiza automáticamente la UI cuando cambian los datos
4. **Codable**: Necesario para serialización JSON
5. **@Bindable**: Permite edición bidireccional en TareaDetailView

## 🚀 Testing

### Probar manualmente:
```
✓ Crear tarea nueva
✓ Editar tarea existente
✓ Marcar como completada (swipe derecha)
✓ Eliminar tarea (swipe izquierda)
✓ Adjuntar foto desde galería
✓ Compartir tarea (texto + imagen)
✓ Buscar tareas por texto
✓ Filtrar por estado
✓ Cambiar ordenamiento
✓ Cambiar tema (claro/oscuro)
✓ Exportar a JSON
✓ Importar desde JSON
✓ Agregar tareas de ejemplo
✓ Ver tareas vencidas con indicador rojo
```

## 📊 Estadísticas del Proyecto

- **Total de archivos**: 11 archivos Swift
- **Líneas de código**: ~1,500+ líneas
- **Modelos**: 1 (Tarea)
- **Vistas**: 7 (ContentView, TareaDetailView, TareaFormView, SettingsView, TareaRowView, ImportadorView, SettingsView)
- **ViewModels**: 1 (TareaViewModel)
- **Utilities**: 3 (Constants, FileManager+Extensions, ShareSheet)

## 🎓 Conceptos Aprendidos

- ✅ SwiftData y @Model
- ✅ @Query y ModelContext
- ✅ Codable y JSON serialization
- ✅ FileManager y Documents directory
- ✅ PhotosPicker (iOS 16+)
- ✅ UIActivityViewController
- ✅ UserDefaults
- ✅ MVVM architecture
- ✅ SwiftUI State management
- ✅ NavigationStack y sheets
- ✅ List y ForEach
- ✅ Swipe actions
- ✅ Filtrado y búsqueda
- ✅ Tema claro/oscuro
- ✅ Animaciones con withAnimation
- ✅ Manejo de errores con try-catch

---

**Listo para demostración y evaluación** ✨
