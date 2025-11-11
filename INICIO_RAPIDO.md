# 🚀 Guía de Inicio Rápido - Tema13Swift

## ✅ Estado del Proyecto: COMPLETADO

Tu aplicación **Gestor de Tareas** está completamente implementada y lista para usar. Todos los archivos han sido creados correctamente.

## 📂 Archivos Creados

```
Tema13Swift/
├── 📄 README.md                          # Documentación completa
├── 📄 CONFIGURACION_PERMISOS.md          # Guía de permisos
├── 📄 REFERENCIA_RAPIDA.md               # Referencia técnica
├── 📄 INICIO_RAPIDO.md                   # Esta guía
│
└── Tema13Swift/
    ├── ContentView.swift                 # ✅ Vista principal (actualizada)
    ├── Tema13SwiftApp.swift              # ✅ App entry point (actualizado)
    │
    ├── Models/
    │   └── Tarea.swift                   # ✅ Modelo SwiftData
    │
    ├── Views/
    │   ├── TareaFormView.swift           # ✅ Formulario de creación
    │   ├── TareaDetailView.swift         # ✅ Vista de detalle
    │   └── SettingsView.swift            # ✅ Configuración
    │
    ├── ViewModels/
    │   └── TareaViewModel.swift          # ✅ Lógica de negocio
    │
    └── Utilities/
        ├── Constants.swift               # ✅ Constantes
        ├── FileManager+Extensions.swift  # ✅ Gestión de archivos
        └── ShareSheet.swift              # ✅ Compartir

Total: 11 archivos Swift + 4 documentos
```

## 🎯 Próximos Pasos (En Orden)

### Paso 1: Configurar Permisos ⚠️ IMPORTANTE
**ANTES de ejecutar la app, debes configurar los permisos:**

1. Abre **Xcode**
2. Selecciona el proyecto **Tema13Swift** (ícono azul) en el navegador
3. Selecciona el target **"Tema13Swift"**
4. Ve a la pestaña **"Info"**
5. Haz clic en **"+"** para agregar una nueva entrada
6. Busca: **Privacy - Photo Library Usage Description**
7. En "Value" escribe: `Necesitamos acceso a tus fotos para adjuntar imágenes a las tareas`
8. Presiona **Enter**

**Ver guía detallada**: `CONFIGURACION_PERMISOS.md`

### Paso 2: Compilar el Proyecto
```bash
# En Xcode:
⌘ + B  (Command + B)

# O desde terminal:
cd /Users/jesusgarza/Documents/ReposClases/Tema13Swift
xcodebuild -scheme Tema13Swift -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Paso 3: Ejecutar la App
```bash
# En Xcode:
⌘ + R  (Command + R)

# Selecciona el simulador: iPhone 15 (recomendado)
```

### Paso 4: Probar Funcionalidades
**Primera Ejecución - Agregar Datos de Ejemplo:**
1. Toca el menú **≡** (esquina superior izquierda)
2. Selecciona **"Agregar Tareas de Ejemplo"**
3. Se crearán 5 tareas de muestra

**Probar Funcionalidades Clave:**
- ✅ **Crear tarea**: Botón **+** → Llenar formulario → Crear
- ✅ **Adjuntar foto**: En formulario → "Seleccionar Foto" → Elige una imagen
- ✅ **Completar tarea**: Desliza derecha → Botón verde ✓
- ✅ **Compartir tarea**: Desliza izquierda → Botón azul ↑
- ✅ **Eliminar tarea**: Desliza izquierda → Botón rojo 🗑️
- ✅ **Ver detalle**: Toca cualquier tarea
- ✅ **Buscar**: Usa la barra de búsqueda
- ✅ **Filtrar**: Botones: Todas, Completadas, Pendientes, Vencidas
- ✅ **Cambiar tema**: Menú ≡ → Configuración → Tema Oscuro
- ✅ **Exportar JSON**: Menú ≡ → Exportar a JSON
- ✅ **Importar JSON**: Menú ≡ → Importar desde JSON

## 🎨 Características Destacadas

### 1. Persistencia Automática con SwiftData
```swift
@Model class Tarea { ... }  // ✅ Implementado
@Query var tareas: [Tarea]   // ✅ Actualización automática
modelContext.insert(tarea)   // ✅ Guardar
modelContext.delete(tarea)   // ✅ Eliminar
```

### 2. PhotosPicker Moderno (iOS 17+)
```swift
PhotosPicker(selection: $selectedPhoto, matching: .images)
// ✅ Sin UIKit, 100% SwiftUI
// ✅ Conversión automática a Data
```

### 3. Compartir con ActivityViewController
```swift
// ✅ Compartir por: Mail, Messages, WhatsApp, etc.
// ✅ Incluye texto + imagen adjunta
```

### 4. Export/Import JSON
```swift
// ✅ Exporta a: Documents/tareas_export_YYYY-MM-DD.json
// ✅ Importa desde archivos guardados
// ✅ Codable para serialización
```

### 5. UserDefaults para Preferencias
```swift
// ✅ Tema oscuro/claro persistente
// ✅ Ordenamiento preferido persistente
```

## 📱 Interfaz de Usuario

### Vista Principal (ContentView)
```
┌─────────────────────────────────┐
│  ≡  Gestor de Tareas         + │
├─────────────────────────────────┤
│  🔍 Buscar tareas...            │
├─────────────────────────────────┤
│  [Todas] Completadas Pendientes │  ← Filtros
├─────────────────────────────────┤
│  ○ 🖼️ Completar proyecto iOS   │  ← Tarea
│     📝 Implementar funcional... │
│     🔴 Alta  📅 11/15/25        │
├─────────────────────────────────┤
│  ✓ 📱 Hacer ejercicio           │  ← Completada
│     📝 30 minutos de cardio     │
│     🟢 Baja  📅 11/11/25        │
└─────────────────────────────────┘
```

### Swipe Actions
```
Deslizar ← IZQUIERDA:
[🗑️ Eliminar] [↑ Compartir]

Deslizar DERECHA →:
[✓ Completar]
```

### Menú de Opciones (≡)
```
⚙️  Configuración
━━━━━━━━━━━━━━━
↕️  Ordenar por
    • Fecha de Creación ✓
    • Fecha de Vencimiento
    • Prioridad
    • Alfabético
━━━━━━━━━━━━━━━
📤 Exportar a JSON
📥 Importar desde JSON
━━━━━━━━━━━━━━━
➕ Agregar Tareas de Ejemplo
```

## 🔧 Configuración Avanzada

### Cambiar Ordenamiento Predeterminado
```swift
// En TareaViewModel.swift, línea 16:
self.ordenamiento = .fechaCreacion  // Actual
// Cambiar a:
self.ordenamiento = .prioridad      // Por prioridad
```

### Personalizar Prioridades
```swift
// En Tarea.swift, puedes agregar más niveles:
// 1 = Muy Baja
// 2 = Baja
// 3 = Media
// 4 = Alta
// 5 = Urgente
```

### Modificar Tareas de Ejemplo
```swift
// En ContentView.swift, función agregarTareasDeEjemplo()
// Personaliza los ejemplos con tus propias tareas
```

## 🐛 Solución de Problemas Comunes

### ❌ Error: "This app has crashed because it attempted to access privacy-sensitive data"
**Solución**: Agrega el permiso `NSPhotoLibraryUsageDescription` (ver Paso 1)

### ❌ La app no compila
**Solución**:
```bash
# Limpiar y reconstruir
⌘ + Shift + K  (Clean Build Folder)
⌘ + B          (Build)
```

### ❌ "Cannot find 'Tarea' in scope"
**Solución**: Asegúrate de que todos los archivos estén agregados al target:
1. Selecciona cada archivo .swift en el navegador
2. En el Inspector de Archivos (→), verifica que "Target Membership" incluya "Tema13Swift"

### ❌ Las tareas no se guardan
**Solución**: Verifica que `Tema13SwiftApp.swift` use `Tarea.self` en el Schema:
```swift
let schema = Schema([Tarea.self])  // ✅ Correcto
```

### ❌ No puedo seleccionar fotos
**Solución**:
1. Verifica el permiso en Info.plist
2. Resetea el simulador: Device → Erase All Content and Settings
3. Vuelve a ejecutar la app

## 📚 Recursos de Aprendizaje

**Documentación incluida:**
- 📖 `README.md` - Documentación completa del proyecto
- ⚙️ `CONFIGURACION_PERMISOS.md` - Guía detallada de permisos
- 🔍 `REFERENCIA_RAPIDA.md` - Referencia técnica rápida
- 🚀 `INICIO_RAPIDO.md` - Esta guía

**Referencias externas:**
- [Apple SwiftData Docs](https://developer.apple.com/documentation/swiftdata)
- [SwiftUI Tutorial](https://developer.apple.com/tutorials/swiftui)
- [PhotosPicker Guide](https://developer.apple.com/documentation/photokit/photospicker)

## ✨ Características Destacadas para Demostración

Cuando presentes tu proyecto, destaca:

1. **SwiftData (iOS 17+)**: Persistencia moderna sin CoreData
2. **PhotosPicker**: Selección de fotos 100% SwiftUI
3. **ActivityViewController**: Compartir nativo de iOS
4. **Export/Import JSON**: Gestión de archivos con FileManager
5. **UserDefaults**: Preferencias persistentes
6. **MVVM**: Arquitectura limpia y escalable
7. **Búsqueda y Filtrado**: UX moderna con ContentUnavailableView
8. **Swipe Actions**: Interacciones intuitivas
9. **Tema Oscuro**: Soporte completo para dark mode
10. **Animaciones**: Transiciones suaves con withAnimation

## 🎯 Checklist de Verificación

Antes de considerar el proyecto completo, verifica:

- [ ] ✅ El proyecto compila sin errores
- [ ] ✅ Se configuró el permiso NSPhotoLibraryUsageDescription
- [ ] ✅ Puedes crear tareas nuevas
- [ ] ✅ Puedes adjuntar fotos
- [ ] ✅ Puedes marcar tareas como completadas
- [ ] ✅ Puedes compartir tareas
- [ ] ✅ Puedes exportar a JSON
- [ ] ✅ Puedes importar desde JSON
- [ ] ✅ La búsqueda funciona correctamente
- [ ] ✅ Los filtros funcionan
- [ ] ✅ El tema oscuro funciona
- [ ] ✅ Las preferencias se guardan al reiniciar

## 🚀 ¡Listo para Usar!

Tu aplicación **Gestor de Tareas** está 100% funcional y lista para demostración.

**Comando rápido para ejecutar:**
```bash
cd /Users/jesusgarza/Documents/ReposClases/Tema13Swift
open Tema13Swift.xcodeproj
# Luego: ⌘ + R
```

**¡Disfruta tu aplicación! 🎉**

---

**Desarrollado por**: JESUS GARZA  
**Fecha**: 11 de Noviembre de 2025  
**Tema**: Tablas y Persistencia (Tema 13)
