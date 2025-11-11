# Guía de Configuración de Permisos - Tema13Swift

## Configurar Permisos de Galería de Fotos

Para que la aplicación pueda acceder a la galería de fotos del dispositivo, debes agregar una descripción de uso en la configuración del proyecto.

## Método 1: Configuración en Xcode (Recomendado)

### Paso 1: Abrir el Proyecto
1. Abre **Tema13Swift.xcodeproj** en Xcode
2. En el navegador de proyectos (panel izquierdo), selecciona el proyecto **Tema13Swift** (ícono azul)

### Paso 2: Seleccionar el Target
1. En el panel central, asegúrate de estar en la pestaña **"Tema13Swift"** (target)
2. Ve a la pestaña **"Info"**

### Paso 3: Agregar la Clave de Privacidad
1. Busca la sección **"Custom iOS Target Properties"**
2. Haz clic en el botón **"+"** para agregar una nueva entrada
3. En el desplegable, busca y selecciona:
   - **Privacy - Photo Library Usage Description**
   - O escribe: `NSPhotoLibraryUsageDescription`
4. En el campo **"Value"**, escribe:
   ```
   Necesitamos acceso a tus fotos para adjuntar imágenes a las tareas
   ```
5. Presiona **Enter** para guardar

### Resultado Esperado
Deberías ver algo como esto en la lista:

| Key | Type | Value |
|-----|------|-------|
| Privacy - Photo Library Usage Description | String | Necesitamos acceso a tus fotos para adjuntar imágenes a las tareas |

## Método 2: Editar Info.plist Manualmente (Alternativo)

Si tu proyecto tiene un archivo **Info.plist** visible en el navegador:

1. Localiza el archivo **Info.plist** en el navegador de proyectos
2. Haz clic derecho → **Open As** → **Source Code**
3. Agrega las siguientes líneas dentro del tag `<dict>`:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Necesitamos acceso a tus fotos para adjuntar imágenes a las tareas</string>
```

4. Guarda el archivo (⌘ + S)

## Verificación

### 1. Compilar sin Errores
```bash
⌘ + B  # Build
```
No deberías ver errores de compilación.

### 2. Ejecutar en Simulador
```bash
⌘ + R  # Run
```

### 3. Probar el Selector de Fotos
1. Toca el botón **"+"** para crear una nueva tarea
2. Toca **"Seleccionar Foto"**
3. **Primera vez**: Deberías ver un diálogo de permiso con el mensaje que configuraste
4. **Seleccionar**: "Allow Access to All Photos" o "Select Photos..."

### 4. Verificar en Configuración del Simulador
1. Abre la app **Configuración** en el simulador
2. Ve a **Tema13Swift**
3. Ve a **Fotos**
4. Deberías ver las opciones de acceso

## Permisos Adicionales (Opcionales)

Si en el futuro quieres agregar más funcionalidades, aquí hay otros permisos útiles:

### Cámara (para tomar fotos)
```xml
<key>NSCameraUsageDescription</key>
<string>Necesitamos acceso a la cámara para tomar fotos de tus tareas</string>
```

### Notificaciones (para recordatorios)
```xml
<key>NSUserNotificationsUsageDescription</key>
<string>Queremos enviarte recordatorios sobre tus tareas pendientes</string>
```

### Ubicación (para tareas basadas en ubicación)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Usamos tu ubicación para organizar tareas por lugar</string>
```

## Solución de Problemas

### ❌ Error: "This app has crashed because it attempted to access privacy-sensitive data..."

**Causa**: No se configuró la descripción de uso de la galería de fotos.

**Solución**: 
1. Asegúrate de haber agregado `NSPhotoLibraryUsageDescription`
2. Limpia el proyecto (⌘ + Shift + K)
3. Elimina la app del simulador
4. Vuelve a compilar y ejecutar

### ❌ El diálogo de permiso no aparece

**Solución**:
1. Elimina la app del simulador
2. Resetea los permisos del simulador:
   - **Device** → **Erase All Content and Settings...**
3. Vuelve a ejecutar la app

### ❌ No puedo encontrar la pestaña "Info"

**Solución**:
1. Asegúrate de haber seleccionado el **proyecto** (ícono azul), no una carpeta
2. Asegúrate de estar viendo el **target** "Tema13Swift", no el proyecto
3. Las pestañas deberían ser: General, Signing & Capabilities, Resource Tags, **Info**, Build Settings, Build Phases, Build Rules

## Configuración para Distribución

Cuando estés listo para publicar en el App Store:

### 1. App Privacy
En **App Store Connect**, deberás declarar:
- **Photo Library**: Selecciona "Para permitir a los usuarios adjuntar fotos a sus tareas"
- **User Content**: Especifica que almacenas fotos del usuario

### 2. Privacy Manifest (iOS 17+)
Considera agregar un **PrivacyInfo.xcprivacy** para mayor transparencia:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>NSPrivacyAccessedAPITypes</key>
    <array>
        <dict>
            <key>NSPrivacyAccessedAPIType</key>
            <string>NSPrivacyAccessedAPICategoryPhotoLibrary</string>
            <key>NSPrivacyAccessedAPITypeReasons</key>
            <array>
                <string>Para adjuntar imágenes a tareas</string>
            </array>
        </dict>
    </array>
</dict>
</plist>
```

## Resumen de Pasos Rápidos

```
1. Abrir proyecto en Xcode
2. Seleccionar proyecto → Target → Info
3. Agregar: Privacy - Photo Library Usage Description
4. Valor: "Necesitamos acceso a tus fotos para adjuntar imágenes a las tareas"
5. Build & Run (⌘ + R)
6. ✅ ¡Listo para usar!
```

---

**Nota**: Estos permisos son obligatorios en iOS. Si no los configuras, la app se cerrará inmediatamente al intentar acceder a la galería de fotos.
