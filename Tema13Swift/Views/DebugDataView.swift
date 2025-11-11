//
//  DebugDataView.swift
//  Tema13Swift
//
//  Created by JESUS GARZA on 11/11/25.
//

import SwiftUI
import SwiftData

struct DebugDataView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var todasLasTareas: [Tarea]
    
    @State private var mostrarAlerta = false
    @State private var mensajeAlerta = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Estadísticas") {
                    HStack {
                        Text("Total de Tareas:")
                        Spacer()
                        Text("\(todasLasTareas.count)")
                            .bold()
                    }
                    
                    HStack {
                        Text("Completadas:")
                        Spacer()
                        Text("\(tareas(completadas: true).count)")
                            .foregroundStyle(.green)
                            .bold()
                    }
                    
                    HStack {
                        Text("Pendientes:")
                        Spacer()
                        Text("\(tareas(completadas: false).count)")
                            .foregroundStyle(.orange)
                            .bold()
                    }
                    
                    HStack {
                        Text("Con Imagen:")
                        Spacer()
                        Text("\(tareasConImagen().count)")
                            .bold()
                    }
                    
                    HStack {
                        Text("Vencidas:")
                        Spacer()
                        Text("\(tareasVencidas().count)")
                            .foregroundStyle(.red)
                            .bold()
                    }
                }
                
                Section("Datos Detallados") {
                    ForEach(todasLasTareas) { tarea in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(tarea.titulo)
                                .font(.headline)
                            
                            Group {
                                HStack {
                                    Text("ID:")
                                        .foregroundStyle(.secondary)
                                    Text(tarea.id.uuidString)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                HStack {
                                    Text("Estado:")
                                        .foregroundStyle(.secondary)
                                    Text(tarea.completada ? "✅ Completada" : "⏳ Pendiente")
                                        .font(.caption)
                                }
                                
                                HStack {
                                    Text("Prioridad:")
                                        .foregroundStyle(.secondary)
                                    Text(prioridadTexto(tarea.prioridad))
                                        .font(.caption)
                                }
                                
                                HStack {
                                    Text("Fecha Creación:")
                                        .foregroundStyle(.secondary)
                                    Text(tarea.fechaCreacion, style: .date)
                                        .font(.caption)
                                }
                                
                                if let fechaVencimiento = tarea.fechaVencimiento {
                                    HStack {
                                        Text("Fecha Vencimiento:")
                                            .foregroundStyle(.secondary)
                                        Text(fechaVencimiento, style: .date)
                                            .font(.caption)
                                            .foregroundStyle(tarea.estaVencida ? .red : .primary)
                                    }
                                }
                                
                                HStack {
                                    Text("Tiene Imagen:")
                                        .foregroundStyle(.secondary)
                                    Text(tarea.imagenData != nil ? "Sí" : "No")
                                        .font(.caption)
                                }
                                
                                if let imagenData = tarea.imagenData {
                                    HStack {
                                        Text("Tamaño Imagen:")
                                            .foregroundStyle(.secondary)
                                        Text(ByteCountFormatter.string(fromByteCount: Int64(imagenData.count), countStyle: .file))
                                            .font(.caption)
                                    }
                                }
                            }
                            .font(.caption)
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Section("Acciones de Debug") {
                    Button {
                        imprimirTareasEnConsola()
                    } label: {
                        Label("Imprimir en Consola", systemImage: "terminal")
                    }
                    
                    Button {
                        exportarParaInspeccion()
                    } label: {
                        Label("Exportar para Inspección", systemImage: "doc.text")
                    }
                    
                    Button(role: .destructive) {
                        eliminarTodasLasTareas()
                    } label: {
                        Label("Eliminar Todas las Tareas", systemImage: "trash.fill")
                    }
                }
            }
            .navigationTitle("Debug SwiftData")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        // Refrescar datos
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
        }
    }
    
    private func tareas(completadas: Bool) -> [Tarea] {
        todasLasTareas.filter { $0.completada == completadas }
    }
    
    private func tareasConImagen() -> [Tarea] {
        todasLasTareas.filter { $0.imagenData != nil }
    }
    
    private func tareasVencidas() -> [Tarea] {
        todasLasTareas.filter { $0.estaVencida }
    }
    
    private func prioridadTexto(_ prioridad: Int) -> String {
        switch prioridad {
        case 1: return "🟢 Baja"
        case 2: return "🟡 Media"
        case 3: return "🔴 Alta"
        default: return "⚪️ Desconocida"
        }
    }
    
    private func imprimirTareasEnConsola() {
        print("\n========== DUMP DE SWIFTDATA ==========")
        print("Total de tareas: \(todasLasTareas.count)")
        print("========================================\n")
        
        for (index, tarea) in todasLasTareas.enumerated() {
            print("[\(index + 1)] 📋 \(tarea.titulo)")
            print("   ID: \(tarea.id)")
            print("   Descripción: \(tarea.descripcion)")
            print("   Estado: \(tarea.completada ? "✅ Completada" : "⏳ Pendiente")")
            print("   Prioridad: \(prioridadTexto(tarea.prioridad))")
            print("   Fecha Creación: \(tarea.fechaCreacion)")
            if let fechaVencimiento = tarea.fechaVencimiento {
                print("   Fecha Vencimiento: \(fechaVencimiento) \(tarea.estaVencida ? "(⚠️ VENCIDA)" : "")")
            }
            print("   Tiene Imagen: \(tarea.imagenData != nil ? "Sí" : "No")")
            if let imagenData = tarea.imagenData {
                print("   Tamaño Imagen: \(ByteCountFormatter.string(fromByteCount: Int64(imagenData.count), countStyle: .file))")
            }
            print("   ---")
        }
        
        print("========== FIN DEL DUMP ==========\n")
        
        mensajeAlerta = "Datos impresos en la consola de Xcode"
        mostrarAlerta = true
    }
    
    private func exportarParaInspeccion() {
        do {
            let url = try FileManager.exportarTareasAJSON(tareas: todasLasTareas)
            mensajeAlerta = "Datos exportados a:\n\(url.path)"
            mostrarAlerta = true
            
            // También imprimir la ruta en consola
            print("\n📁 Archivo exportado en:")
            print(url.path)
            print("\nPara ver el archivo, ejecuta en Terminal:")
            print("open \"\(url.path)\"")
            print("")
        } catch {
            mensajeAlerta = "Error al exportar: \(error.localizedDescription)"
            mostrarAlerta = true
        }
    }
    
    private func eliminarTodasLasTareas() {
        let count = todasLasTareas.count
        
        for tarea in todasLasTareas {
            modelContext.delete(tarea)
        }
        
        do {
            try modelContext.save()
            mensajeAlerta = "Se eliminaron \(count) tareas"
            mostrarAlerta = true
            
            print("\n🗑️ Se eliminaron \(count) tareas de SwiftData")
        } catch {
            mensajeAlerta = "Error al eliminar: \(error.localizedDescription)"
            mostrarAlerta = true
        }
    }
}

#Preview {
    DebugDataView()
        .modelContainer(for: Tarea.self, inMemory: true)
}
