//
//  TareaFormView.swift
//  Tema13Swift
//
//  Created by JESUS GARZA on 11/11/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct TareaFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var titulo = ""
    @State private var descripcion = ""
    @State private var prioridad = 2
    @State private var fechaVencimiento = Date()
    @State private var tieneFechaVencimiento = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var imagenData: Data?
    @State private var mostrarAlerta = false
    @State private var mensajeAlerta = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Información Básica") {
                    TextField("Título", text: $titulo)
                    TextField("Descripción", text: $descripcion, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Prioridad") {
                    Picker("Nivel de Prioridad", selection: $prioridad) {
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
                }
                
                Section("Fecha de Vencimiento") {
                    Toggle("Establecer fecha de vencimiento", isOn: $tieneFechaVencimiento)
                    
                    if tieneFechaVencimiento {
                        DatePicker("Fecha", selection: $fechaVencimiento, displayedComponents: [.date, .hourAndMinute])
                    }
                }
                
                Section("Imagen") {
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        Label("Seleccionar Foto", systemImage: "photo")
                    }
                    
                    if let imagenData = imagenData, let uiImage = UIImage(data: imagenData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                            .cornerRadius(8)
                        
                        Button(role: .destructive) {
                            self.imagenData = nil
                            self.selectedPhoto = nil
                        } label: {
                            Label("Eliminar Imagen", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Nueva Tarea")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Crear") {
                        crearTarea()
                    }
                    .disabled(titulo.isEmpty)
                }
            }
            .onChange(of: selectedPhoto) { oldValue, newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                        imagenData = data
                    }
                }
            }
            .alert("Error", isPresented: $mostrarAlerta) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(mensajeAlerta)
            }
        }
    }
    
    private func crearTarea() {
        guard !titulo.isEmpty else {
            mensajeAlerta = "El título es obligatorio"
            mostrarAlerta = true
            return
        }
        
        let nuevaTarea = Tarea(
            titulo: titulo,
            descripcion: descripcion,
            imagenData: imagenData,
            fechaVencimiento: tieneFechaVencimiento ? fechaVencimiento : nil,
            prioridad: prioridad
        )
        
        modelContext.insert(nuevaTarea)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            mensajeAlerta = "Error al guardar la tarea: \(error.localizedDescription)"
            mostrarAlerta = true
        }
    }
}

#Preview {
    TareaFormView()
        .modelContainer(for: Tarea.self, inMemory: true)
}
