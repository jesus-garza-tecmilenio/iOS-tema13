//
//  ContentView.swift
//  Tema13Swift
//
//  Created by JESUS GARZA on 11/11/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var todasLasTareas: [Tarea]
    
    @StateObject private var viewModel = TareaViewModel()
    @State private var busqueda = ""
    @State private var filtroSeleccionado: Constants.Filtro = .todas
    @State private var mostrarFormulario = false
    @State private var mostrarConfiguracion = false
    @State private var mostrarMenuExportar = false
    @State private var mostrarAlerta = false
    @State private var mensajeAlerta = ""
    @State private var tituloAlerta = "Información"
    @State private var mostrarImportador = false
    @State private var mostrarShareSheet = false
    @State private var urlParaCompartir: URL?
    @State private var mostrarDebug = false
    
    private var tareasFiltradas: [Tarea] {
        let buscadas = viewModel.buscarTareas(todasLasTareas, busqueda: busqueda)
        let filtradas = viewModel.filtrarTareas(buscadas, filtro: filtroSeleccionado)
        return viewModel.ordenarTareas(filtradas)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filtros
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Constants.Filtro.allCases) { filtro in
                            Button {
                                withAnimation {
                                    filtroSeleccionado = filtro
                                }
                            } label: {
                                Text(filtro.rawValue)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(filtroSeleccionado == filtro ? Color.accentColor : Color.secondary.opacity(0.2))
                                    .foregroundStyle(filtroSeleccionado == filtro ? .white : .primary)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                .background(Color(uiColor: .systemBackground))
                
                Divider()
                
                // Lista de tareas
                if tareasFiltradas.isEmpty {
                    ContentUnavailableView {
                        Label("No hay tareas", systemImage: "checklist")
                    } description: {
                        if busqueda.isEmpty {
                            Text("Crea una nueva tarea usando el botón +")
                        } else {
                            Text("No se encontraron tareas que coincidan con '\(busqueda)'")
                        }
                    }
                } else {
                    List {
                        ForEach(tareasFiltradas) { tarea in
                            NavigationLink(destination: TareaDetailView(tarea: tarea)) {
                                TareaRowView(tarea: tarea)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    eliminarTarea(tarea)
                                } label: {
                                    Label("Eliminar", systemImage: "trash")
                                }
                                
                                Button {
                                    compartirTarea(tarea)
                                } label: {
                                    Label("Compartir", systemImage: "square.and.arrow.up")
                                }
                                .tint(.blue)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    toggleCompletada(tarea)
                                } label: {
                                    Label(tarea.completada ? "Pendiente" : "Completar",
                                          systemImage: tarea.completada ? "circle" : "checkmark.circle.fill")
                                }
                                .tint(tarea.completada ? .orange : .green)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Gestor de Tareas")
            .searchable(text: $busqueda, prompt: "Buscar tareas...")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button {
                            mostrarConfiguracion = true
                        } label: {
                            Label("Configuración", systemImage: "gear")
                        }
                        
                        Divider()
                        
                        Menu {
                            ForEach(Constants.Ordenamiento.allCases) { orden in
                                Button {
                                    viewModel.ordenamiento = orden
                                } label: {
                                    HStack {
                                        Text(orden.rawValue)
                                        if viewModel.ordenamiento == orden {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            Label("Ordenar por", systemImage: "arrow.up.arrow.down")
                        }
                        
                        Divider()
                        
                        Button {
                            exportarTareas()
                        } label: {
                            Label("Exportar a JSON", systemImage: "square.and.arrow.up.on.square")
                        }
                        
                        Button {
                            mostrarImportador = true
                        } label: {
                            Label("Importar desde JSON", systemImage: "square.and.arrow.down.on.square")
                        }
                        
                        Divider()
                        
                        Button {
                            agregarTareasDeEjemplo()
                        } label: {
                            Label("Agregar Tareas de Ejemplo", systemImage: "doc.badge.plus")
                        }
                        
                        Divider()
                        
                        Button {
                            mostrarDebug = true
                        } label: {
                            Label("Ver Datos (Debug)", systemImage: "ladybug")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        mostrarFormulario = true
                    } label: {
                        Label("Nueva Tarea", systemImage: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $mostrarFormulario) {
                TareaFormView()
            }
            .sheet(isPresented: $mostrarConfiguracion) {
                SettingsView(viewModel: viewModel)
            }
            .sheet(isPresented: $mostrarImportador) {
                ImportadorView(modelContext: modelContext)
            }
            .sheet(isPresented: $mostrarShareSheet) {
                if let url = urlParaCompartir {
                    ShareSheet(activityItems: [url])
                }
            }
            .sheet(isPresented: $mostrarDebug) {
                DebugDataView()
            }
            .alert(tituloAlerta, isPresented: $mostrarAlerta) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(mensajeAlerta)
            }
        }
        .preferredColorScheme(viewModel.temaOscuro ? .dark : .light)
    }
    
    private func toggleCompletada(_ tarea: Tarea) {
        withAnimation {
            tarea.completada.toggle()
            try? modelContext.save()
        }
    }
    
    private func eliminarTarea(_ tarea: Tarea) {
        withAnimation {
            modelContext.delete(tarea)
            try? modelContext.save()
        }
    }
    
    private func compartirTarea(_ tarea: Tarea) {
        let texto = """
        📋 \(tarea.titulo)
        
        \(tarea.descripcion)
        
        Prioridad: \(prioridadTexto(tarea.prioridad))
        Estado: \(tarea.completada ? "✅ Completada" : "⏳ Pendiente")
        """
        
        var items: [Any] = [texto]
        if let imagenData = tarea.imagenData, let uiImage = UIImage(data: imagenData) {
            items.append(uiImage)
        }
        
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
    
    private func prioridadTexto(_ prioridad: Int) -> String {
        switch prioridad {
        case 1: return "Baja"
        case 2: return "Media"
        case 3: return "Alta"
        default: return "Desconocida"
        }
    }
    
    private func exportarTareas() {
        do {
            let url = try FileManager.exportarTareasAJSON(tareas: todasLasTareas)
            urlParaCompartir = url
            mostrarShareSheet = true
            tituloAlerta = "Éxito"
            mensajeAlerta = "Tareas exportadas correctamente a: \(url.lastPathComponent)"
            mostrarAlerta = true
        } catch {
            tituloAlerta = "Error"
            mensajeAlerta = "Error al exportar tareas: \(error.localizedDescription)"
            mostrarAlerta = true
        }
    }
    
    private func agregarTareasDeEjemplo() {
        let ejemplos = [
            Tarea(titulo: "Completar proyecto de iOS", descripcion: "Implementar todas las funcionalidades del gestor de tareas", prioridad: 3),
            Tarea(titulo: "Estudiar SwiftData", descripcion: "Repasar la documentación oficial de Apple", fechaVencimiento: Calendar.current.date(byAdding: .day, value: 3, to: Date()), prioridad: 2),
            Tarea(titulo: "Hacer ejercicio", descripcion: "30 minutos de cardio", completada: true, fechaVencimiento: Date(), prioridad: 1),
            Tarea(titulo: "Revisar código", descripcion: "Hacer code review del proyecto", fechaVencimiento: Calendar.current.date(byAdding: .day, value: -1, to: Date()), prioridad: 3),
            Tarea(titulo: "Preparar presentación", descripcion: "Crear slides para la reunión del viernes", prioridad: 2)
        ]
        
        for ejemplo in ejemplos {
            modelContext.insert(ejemplo)
        }
        
        try? modelContext.save()
        
        tituloAlerta = "Éxito"
        mensajeAlerta = "Se agregaron \(ejemplos.count) tareas de ejemplo"
        mostrarAlerta = true
    }
}

// MARK: - TareaRowView
struct TareaRowView: View {
    let tarea: Tarea
    
    var body: some View {
        HStack(spacing: 12) {
            // Checkbox
            Image(systemName: tarea.completada ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundStyle(tarea.completada ? .green : .gray)
            
            // Thumbnail de imagen
            if let imagenData = tarea.imagenData, let uiImage = UIImage(data: imagenData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
                    .clipped()
            }
            
            // Contenido
            VStack(alignment: .leading, spacing: 4) {
                Text(tarea.titulo)
                    .font(.headline)
                    .strikethrough(tarea.completada)
                    .foregroundStyle(tarea.completada ? .secondary : .primary)
                
                Text(tarea.descripcion)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                HStack(spacing: 8) {
                    // Prioridad
                    prioridadBadge(prioridad: tarea.prioridad)
                    
                    // Fecha de vencimiento
                    if let fechaVencimiento = tarea.fechaVencimiento {
                        Text(fechaVencimiento, format: .dateTime.day().month().year())
                            .font(.caption)
                            .foregroundStyle(tarea.estaVencida ? .red : .secondary)
                    }
                    
                    // Indicador de vencida
                    if tarea.estaVencida {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private func prioridadBadge(prioridad: Int) -> some View {
        let (color, _) = prioridadInfo(prioridad: prioridad)
        return Image(systemName: "circle.fill")
            .font(.caption)
            .foregroundStyle(color)
    }
    
    private func prioridadInfo(prioridad: Int) -> (Color, String) {
        switch prioridad {
        case 1: return (.green, "Baja")
        case 2: return (.yellow, "Media")
        case 3: return (.red, "Alta")
        default: return (.gray, "Desconocida")
        }
    }
}

// MARK: - ImportadorView
struct ImportadorView: View {
    @Environment(\.dismiss) private var dismiss
    let modelContext: ModelContext
    
    @State private var archivosDisponibles: [URL] = []
    @State private var mostrarAlerta = false
    @State private var mensajeAlerta = ""
    
    var body: some View {
        NavigationStack {
            List {
                if archivosDisponibles.isEmpty {
                    ContentUnavailableView {
                        Label("No hay archivos", systemImage: "doc.badge.arrow.up")
                    } description: {
                        Text("No se encontraron archivos JSON para importar")
                    }
                } else {
                    ForEach(archivosDisponibles, id: \.self) { url in
                        Button {
                            importarDesdeArchivo(url)
                        } label: {
                            HStack {
                                Image(systemName: "doc.text")
                                VStack(alignment: .leading) {
                                    Text(url.lastPathComponent)
                                        .font(.headline)
                                    if let attrs = try? FileManager.default.attributesOfItem(atPath: url.path),
                                       let fecha = attrs[.modificationDate] as? Date {
                                        Text(fecha, style: .date)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                Spacer()
                                Image(systemName: "arrow.down.circle")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Importar Tareas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        cargarArchivos()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .alert("Resultado", isPresented: $mostrarAlerta) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(mensajeAlerta)
            }
            .onAppear {
                cargarArchivos()
            }
        }
    }
    
    private func cargarArchivos() {
        archivosDisponibles = FileManager.listarArchivosJSON()
    }
    
    private func importarDesdeArchivo(_ url: URL) {
        do {
            let tareasDict = try FileManager.importarTareasDesdeJSON(fileURL: url)
            var tareasImportadas = 0
            
            for dict in tareasDict {
                if let tarea = Tarea.fromDictionary(dict) {
                    modelContext.insert(tarea)
                    tareasImportadas += 1
                }
            }
            
            try modelContext.save()
            mensajeAlerta = "Se importaron \(tareasImportadas) tareas exitosamente"
            mostrarAlerta = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                dismiss()
            }
        } catch {
            mensajeAlerta = "Error al importar: \(error.localizedDescription)"
            mostrarAlerta = true
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Tarea.self, inMemory: true)
}
