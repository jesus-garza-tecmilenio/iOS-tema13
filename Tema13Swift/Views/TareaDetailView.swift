//
//  TareaDetailView.swift
//  Tema13Swift
//
//  Created by JESUS GARZA on 11/11/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct TareaDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var tarea: Tarea
    
    @State private var modoEdicion = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var mostrarShareSheet = false
    @State private var mostrarAlertaEliminar = false
    @State private var mostrarAlerta = false
    @State private var mensajeAlerta = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Imagen
                if let imagenData = tarea.imagenData, let uiImage = UIImage(data: imagenData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                
                // Información de la tarea
                VStack(alignment: .leading, spacing: 16) {
                    // Título
                    if modoEdicion {
                        TextField("Título", text: $tarea.titulo)
                            .font(.title2)
                            .fontWeight(.bold)
                            .textFieldStyle(.roundedBorder)
                    } else {
                        Text(tarea.titulo)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    // Estado de completitud
                    HStack {
                        Image(systemName: tarea.completada ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(tarea.completada ? .green : .gray)
                        Text(tarea.completada ? "Completada" : "Pendiente")
                            .font(.subheadline)
                        Spacer()
                        if tarea.estaVencida {
                            Label("Vencida", systemImage: "exclamationmark.triangle.fill")
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                    
                    Divider()
                    
                    // Descripción
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Descripción")
                            .font(.headline)
                        
                        if modoEdicion {
                            TextField("Descripción", text: $tarea.descripcion, axis: .vertical)
                                .lineLimit(3...10)
                                .textFieldStyle(.roundedBorder)
                        } else {
                            Text(tarea.descripcion)
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Divider()
                    
                    // Prioridad
                    HStack {
                        Text("Prioridad:")
                            .font(.headline)
                        
                        if modoEdicion {
                            Picker("Prioridad", selection: $tarea.prioridad) {
                                HStack {
                                    Image(systemName: "circle.fill")
                                        .foregroundStyle(.green)
                                    Text("Baja")
                                }.tag(1)
                                HStack {
                                    Image(systemName: "circle.fill")
                                        .foregroundStyle(.yellow)
                                    Text("Media")
                                }.tag(2)
                                HStack {
                                    Image(systemName: "circle.fill")
                                        .foregroundStyle(.red)
                                    Text("Alta")
                                }.tag(3)
                            }
                            .pickerStyle(.segmented)
                        } else {
                            prioridadBadge(prioridad: tarea.prioridad)
                        }
                    }
                    
                    Divider()
                    
                    // Fechas
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "calendar")
                            Text("Fecha de creación:")
                                .font(.headline)
                            Spacer()
                            Text(tarea.fechaCreacion, style: .date)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        if let fechaVencimiento = tarea.fechaVencimiento {
                            HStack {
                                Image(systemName: "calendar.badge.clock")
                                Text("Vence:")
                                    .font(.headline)
                                Spacer()
                                Text(fechaVencimiento, style: .date)
                                    .font(.subheadline)
                                    .foregroundStyle(tarea.estaVencida ? .red : .secondary)
                            }
                        }
                    }
                    
                    // Selector de foto en modo edición
                    if modoEdicion {
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Imagen")
                                .font(.headline)
                            
                            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                Label(tarea.imagenData == nil ? "Agregar Foto" : "Cambiar Foto", systemImage: "photo")
                            }
                            .buttonStyle(.bordered)
                            
                            if tarea.imagenData != nil {
                                Button(role: .destructive) {
                                    tarea.imagenData = nil
                                } label: {
                                    Label("Eliminar Imagen", systemImage: "trash")
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Detalle de Tarea")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        modoEdicion.toggle()
                    } label: {
                        Label(modoEdicion ? "Finalizar Edición" : "Editar", systemImage: modoEdicion ? "checkmark" : "pencil")
                    }
                    
                    Button {
                        tarea.completada.toggle()
                        guardarCambios()
                    } label: {
                        Label(tarea.completada ? "Marcar como Pendiente" : "Marcar como Completada", 
                              systemImage: tarea.completada ? "circle" : "checkmark.circle")
                    }
                    
                    Button {
                        mostrarShareSheet = true
                    } label: {
                        Label("Compartir", systemImage: "square.and.arrow.up")
                    }
                    
                    Divider()
                    
                    Button(role: .destructive) {
                        mostrarAlertaEliminar = true
                    } label: {
                        Label("Eliminar", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .onChange(of: selectedPhoto) { oldValue, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    tarea.imagenData = data
                }
            }
        }
        .onChange(of: modoEdicion) { oldValue, newValue in
            if !newValue && oldValue {
                guardarCambios()
            }
        }
        .sheet(isPresented: $mostrarShareSheet) {
            ShareSheet(activityItems: compartirTarea())
        }
        .alert("Eliminar Tarea", isPresented: $mostrarAlertaEliminar) {
            Button("Cancelar", role: .cancel) { }
            Button("Eliminar", role: .destructive) {
                eliminarTarea()
            }
        } message: {
            Text("¿Estás seguro de que deseas eliminar esta tarea?")
        }
        .alert("Información", isPresented: $mostrarAlerta) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(mensajeAlerta)
        }
    }
    
    private func prioridadBadge(prioridad: Int) -> some View {
        let (color, texto) = prioridadInfo(prioridad: prioridad)
        return HStack {
            Image(systemName: "circle.fill")
                .foregroundStyle(color)
            Text(texto)
                .font(.subheadline)
        }
    }
    
    private func prioridadInfo(prioridad: Int) -> (Color, String) {
        switch prioridad {
        case 1: return (.green, "Baja")
        case 2: return (.yellow, "Media")
        case 3: return (.red, "Alta")
        default: return (.gray, "Desconocida")
        }
    }
    
    private func guardarCambios() {
        do {
            try modelContext.save()
        } catch {
            mensajeAlerta = "Error al guardar cambios: \(error.localizedDescription)"
            mostrarAlerta = true
        }
    }
    
    private func compartirTarea() -> [Any] {
        var items: [Any] = []
        
        let texto = """
        📋 \(tarea.titulo)
        
        \(tarea.descripcion)
        
        Prioridad: \(prioridadInfo(prioridad: tarea.prioridad).1)
        Estado: \(tarea.completada ? "✅ Completada" : "⏳ Pendiente")
        \(tarea.fechaVencimiento != nil ? "Vence: \(tarea.fechaVencimiento!.formatted(date: .long, time: .shortened))" : "")
        """
        
        items.append(texto)
        
        if let imagenData = tarea.imagenData, let uiImage = UIImage(data: imagenData) {
            items.append(uiImage)
        }
        
        return items
    }
    
    private func eliminarTarea() {
        modelContext.delete(tarea)
        do {
            try modelContext.save()
            dismiss()
        } catch {
            mensajeAlerta = "Error al eliminar la tarea: \(error.localizedDescription)"
            mostrarAlerta = true
        }
    }
}

#Preview {
    NavigationStack {
        TareaDetailView(tarea: Tarea(
            titulo: "Tarea de Ejemplo",
            descripcion: "Esta es una descripción de ejemplo para la tarea",
            prioridad: 3
        ))
    }
    .modelContainer(for: Tarea.self, inMemory: true)
}
