//
//  TareaViewModel.swift
//  Tema13Swift
//
//  Created by JESUS GARZA on 11/11/25.
//

import Foundation
import SwiftUI
import Combine

class TareaViewModel: ObservableObject {
    @Published var ordenamiento: Constants.Ordenamiento {
        didSet {
            UserDefaults.standard.set(ordenamiento.rawValue, forKey: Constants.ordenamientoKey)
        }
    }
    
    @Published var temaOscuro: Bool {
        didSet {
            UserDefaults.standard.set(temaOscuro, forKey: Constants.temaOscuroKey)
        }
    }
    
    init() {
        // Cargar preferencias de UserDefaults
        if let ordenamientoString = UserDefaults.standard.string(forKey: Constants.ordenamientoKey),
           let ordenamiento = Constants.Ordenamiento(rawValue: ordenamientoString) {
            self.ordenamiento = ordenamiento
        } else {
            self.ordenamiento = .fechaCreacion
        }
        
        self.temaOscuro = UserDefaults.standard.bool(forKey: Constants.temaOscuroKey)
    }
    
    func ordenarTareas(_ tareas: [Tarea]) -> [Tarea] {
        switch ordenamiento {
        case .fechaCreacion:
            return tareas.sorted { $0.fechaCreacion > $1.fechaCreacion }
        case .fechaVencimiento:
            return tareas.sorted { tarea1, tarea2 in
                if let fecha1 = tarea1.fechaVencimiento, let fecha2 = tarea2.fechaVencimiento {
                    return fecha1 < fecha2
                } else if tarea1.fechaVencimiento != nil {
                    return true
                } else {
                    return false
                }
            }
        case .prioridad:
            return tareas.sorted { $0.prioridad > $1.prioridad }
        case .alfabetico:
            return tareas.sorted { $0.titulo.lowercased() < $1.titulo.lowercased() }
        }
    }
    
    func filtrarTareas(_ tareas: [Tarea], filtro: Constants.Filtro) -> [Tarea] {
        switch filtro {
        case .todas:
            return tareas
        case .completadas:
            return tareas.filter { $0.completada }
        case .pendientes:
            return tareas.filter { !$0.completada }
        case .vencidas:
            return tareas.filter { $0.estaVencida }
        }
    }
    
    func buscarTareas(_ tareas: [Tarea], busqueda: String) -> [Tarea] {
        if busqueda.isEmpty {
            return tareas
        }
        return tareas.filter {
            $0.titulo.lowercased().contains(busqueda.lowercased()) ||
            $0.descripcion.lowercased().contains(busqueda.lowercased())
        }
    }
}
