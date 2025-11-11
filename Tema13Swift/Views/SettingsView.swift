//
//  SettingsView.swift
//  Tema13Swift
//
//  Created by JESUS GARZA on 11/11/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TareaViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Apariencia") {
                    Toggle("Tema Oscuro", isOn: $viewModel.temaOscuro)
                }
                
                Section("Ordenamiento") {
                    Picker("Ordenar por", selection: $viewModel.ordenamiento) {
                        ForEach(Constants.Ordenamiento.allCases) { orden in
                            Text(orden.rawValue).tag(orden)
                        }
                    }
                }
                
                Section("Información") {
                    HStack {
                        Text("Versión")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Desarrollado por")
                        Spacer()
                        Text("Tema 13 Swift")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Configuración")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView(viewModel: TareaViewModel())
}
