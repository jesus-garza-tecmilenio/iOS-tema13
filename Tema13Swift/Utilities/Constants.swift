//
//  Constants.swift
//  Tema13Swift
//
//  Created by JESUS GARZA on 11/11/25.
//

import Foundation

struct Constants {
    // UserDefaults Keys
    static let temaOscuroKey = "temaOscuro"
    static let ordenamientoKey = "ordenamiento"
    static let ultimoIDKey = "ultimoID"
    
    // Opciones de ordenamiento
    enum Ordenamiento: String, CaseIterable, Identifiable {
        case fechaCreacion = "Fecha de Creación"
        case fechaVencimiento = "Fecha de Vencimiento"
        case prioridad = "Prioridad"
        case alfabetico = "Alfabético"
        
        var id: String { self.rawValue }
    }
    
    // Filtros
    enum Filtro: String, CaseIterable, Identifiable {
        case todas = "Todas"
        case completadas = "Completadas"
        case pendientes = "Pendientes"
        case vencidas = "Vencidas"
        
        var id: String { self.rawValue }
    }
}
