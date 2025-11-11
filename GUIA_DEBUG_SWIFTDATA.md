# 🐛 Guía Completa: Cómo Ver y Debuggear Datos de SwiftData en Xcode

## 📱 Métodos para Ver los Datos de SwiftData

### 1. **Vista de Debug Integrada en la App** ✅ (YA IMPLEMENTADA)

He creado una vista especial llamada `DebugDataView.swift` que te permite ver todos los datos directamente en la app.

#### Cómo Acceder:
1. Ejecuta la app en el simulador (⌘ + R)
2. Toca el botón del menú (≡) en la esquina superior izquierda
3. Selecciona **"Ver Datos (Debug)"**
4. Verás una lista completa con:
   - ✅ Total de tareas guardadas
   - 📋 Todos los campos de cada tarea
   - 🖼️ Vista previa de imágenes adjuntas
   - 📊 Información detallada de cada registro
   - 🔄 Botón para refrescar datos
   - 🗑️ Botón para eliminar todos los datos

**Ventajas:**
- No necesitas herramientas externas
- Ves los datos en tiempo real
- Puedes hacer pruebas mientras desarrollas
- Funciona en simulador y dispositivo físico

---

### 2. **Console de Xcode (Método Manual)**

Puedes agregar `print()` statements en tu código para ver qué datos se están guardando:

```swift
// En cualquier parte de tu código
@Query private var tareas: [Tarea]

var body: some View {
    List(tareas) { tarea in
        // ... tu UI
    }
    .onAppear {
        print("📊 Total de tareas: \(tareas.count)")
        for tarea in tareas {
            print("🔹 ID: \(tarea.id)")
            print("   Título: \(tarea.titulo)")
            print("   Completada: \(tarea.completada)")
            print("   Prioridad: \(tarea.prioridad)")
            print("   ---")
        }
    }
}
```

**Cómo Ver la Console:**
1. En Xcode, ejecuta la app (⌘ + R)
2. Abre el panel de Debug: View → Debug Area → Show Debug Area (⌘ + Shift + Y)
3. Verás todos los prints en la consola

---

### 3. **Breakpoints y LLDB Debugger**

Usa breakpoints para inspeccionar datos en tiempo de ejecución:

#### Pasos:
1. **Coloca un Breakpoint:**
   - Haz clic en el número de línea donde quieres pausar
   - Aparecerá un icono azul

2. **Ejecuta la App:**
   - Presiona ⌘ + R
   - La app se pausará cuando llegue al breakpoint

3. **Inspecciona Variables:**
   - En el panel inferior verás todas las variables locales
   - Expande `tareas` para ver el array completo
   - Haz clic en cada tarea para ver sus propiedades

4. **Usa el LLDB Console:**
   ```lldb
   po tareas
   po tareas.count
   po tareas[0].titulo
   po tareas.map { $0.titulo }
   ```

**Comandos LLDB Útiles:**
- `po variable` - Imprime descripción del objeto
- `p variable` - Imprime valor
- `frame variable` - Muestra todas las variables locales
- `expression variable = nuevoValor` - Modifica valores en runtime

---

### 4. **View Hierarchy Debugger** (Para UI)

Aunque no muestra los datos directamente, te ayuda a verificar que las vistas se están renderizando correctamente:

1. Ejecuta la app (⌘ + R)
2. Presiona el botón de View Hierarchy: **Debug → View Debugging → Capture View Hierarchy**
3. Verás una vista 3D de todas tus vistas
4. Puedes inspeccionar cada elemento y sus propiedades

---

### 5. **Exportar a JSON y Ver en Editor**

Tu app ya tiene funcionalidad de exportación integrada:

#### Pasos:
1. Ejecuta la app
2. Menú (≡) → **"Exportar a JSON"**
3. Los datos se guardan en el directorio Documents
4. En Xcode, ve a: **Window → Devices and Simulators**
5. Selecciona tu simulador
6. Encuentra tu app en la lista
7. Haz clic en el ícono de engranaje (⚙️) → **"Download Container..."**
8. Guarda el contenedor en tu Mac
9. Navega a: `AppData/Documents/`
10. Abre el archivo `.json` con cualquier editor de texto

**Estructura del JSON Exportado:**
```json
[
  {
    "id": "UUID-aquí",
    "titulo": "Título de la tarea",
    "descripcion": "Descripción...",
    "completada": false,
    "prioridad": 3,
    "fechaCreacion": "2025-11-11T10:30:00Z",
    "fechaVencimiento": "2025-11-15T10:30:00Z",
    "imagenData": "base64-encoded-data..."
  }
]
```

---

### 6. **Acceder al Archivo de Base de Datos Directamente**

SwiftData guarda los datos en un archivo SQLite que puedes inspeccionar:

#### Ubicación del Archivo:
```
~/Library/Developer/CoreSimulator/Devices/[DEVICE_ID]/data/Containers/Data/Application/[APP_ID]/Library/Application Support/default.store
```

#### Cómo Encontrarlo:
1. Ejecuta la app en el simulador
2. Agrega este código temporal en `Tema13SwiftApp.swift`:

```swift
init() {
    if let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
        print("🗄️ Base de datos SwiftData en: \(url)")
    }
}
```

3. Ejecuta la app y copia la ruta de la consola
4. Abre Terminal y navega a esa ubicación
5. Usa un visor SQLite como:
   - **DB Browser for SQLite** (gratuito): https://sqlitebrowser.org
   - **TablePlus** (gratuito para uso básico): https://tableplus.com
   - Comando terminal: `sqlite3 default.store`

#### Ver Datos con SQLite en Terminal:
```bash
cd [ruta-de-la-base-de-datos]
sqlite3 default.store

# Dentro de sqlite3:
.tables                    # Ver todas las tablas
.schema Tarea             # Ver estructura de la tabla
SELECT * FROM Tarea;      # Ver todos los registros
.quit                     # Salir
```

---

### 7. **Instruments (Para Profiling Avanzado)**

Para análisis de rendimiento y memoria:

1. En Xcode: **Product → Profile** (⌘ + I)
2. Selecciona el template **"Core Data"** o **"Allocations"**
3. Graba mientras usas la app
4. Analiza las operaciones de persistencia

---

## 🎯 Método Recomendado para Tu Proyecto

**Para desarrollo diario:** Usa la **Vista de Debug integrada** (DebugDataView) que ya está implementada. Es la forma más rápida y visual.

**Para debugging profundo:** Usa **breakpoints + LLDB** cuando necesites investigar problemas específicos.

**Para compartir datos:** Usa la **exportación a JSON** para enviar datos a otros desarrolladores o para backup.

---

## 🧪 Pruebas Rápidas con la Vista de Debug

### Cómo Probar que SwiftData Está Funcionando:

1. **Ejecuta la app** (⌘ + R)

2. **Agrega tareas de ejemplo:**
   - Menú (≡) → "Agregar Tareas de Ejemplo"
   - Esto creará 5 tareas de prueba

3. **Verifica los datos:**
   - Menú (≡) → "Ver Datos (Debug)"
   - Deberías ver "Total de tareas: 5"
   - Expande cada tarea para ver todos sus campos

4. **Prueba la persistencia:**
   - Cierra la app (⌘ + Q en el simulador)
   - Vuelve a ejecutar la app (⌘ + R)
   - Menú (≡) → "Ver Datos (Debug)"
   - Las 5 tareas deberían seguir ahí ✅

5. **Prueba CRUD:**
   - Crea una nueva tarea con el botón +
   - Verifica en Debug: debería haber 6 tareas
   - Elimina una tarea (swipe)
   - Verifica en Debug: debería haber 5 tareas
   - Edita una tarea y guarda cambios
   - Verifica en Debug: los cambios deberían estar guardados

---

## 🔍 Solución de Problemas Comunes

### Problema: "No veo ninguna tarea en la Vista de Debug"
**Solución:**
- Verifica que hayas agregado tareas primero
- Presiona el botón "Refrescar" en la vista de debug
- Revisa la consola de Xcode por errores

### Problema: "Las tareas desaparecen al reiniciar la app"
**Solución:**
- Asegúrate de que estás usando `.modelContainer(for: Tarea.self)` en el App
- No uses `inMemory: true` en producción (solo para testing)
- Verifica que llamas `modelContext.save()` después de modificar datos

### Problema: "Error al exportar a JSON"
**Solución:**
- Verifica permisos de escritura
- Revisa que las tareas tengan todos los campos requeridos
- Mira la consola de Xcode para detalles del error

### Problema: "La base de datos está corrupta"
**Solución:**
```bash
# En el simulador, borra la app y reinstala
# O usa el botón "Eliminar Todos los Datos" en DebugDataView
```

---

## 📚 Recursos Adicionales

- **Apple SwiftData Docs**: https://developer.apple.com/documentation/swiftdata
- **WWDC 2023 - SwiftData**: https://developer.apple.com/videos/play/wwdc2023/10187/
- **Hacking with Swift - SwiftData**: https://www.hackingwithswift.com/quick-start/swiftdata
- **SQLite Browser**: https://sqlitebrowser.org

---

## ✅ Checklist de Debug

- [ ] Vista de Debug muestra todas las tareas
- [ ] Total de tareas es correcto
- [ ] Todos los campos se muestran correctamente
- [ ] Las imágenes se cargan y visualizan
- [ ] Los datos persisten al reiniciar la app
- [ ] Export/Import JSON funciona correctamente
- [ ] No hay errores en la consola de Xcode
- [ ] El rendimiento es fluido (sin lag)

---

**¡Tu app ya tiene todo lo necesario para debuggear SwiftData fácilmente!** 🎉
