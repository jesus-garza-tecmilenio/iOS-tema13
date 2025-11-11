//
//  Tarea.swift
//  Tema13Swift
//
//  Created by JESUS GARZA on 11/11/25.
//

import Foundation
import SwiftData

@Model
final class Tarea {
    var id: UUID
    var titulo: String
    var descripcion: String
    var completada: Bool
    var imagenData: Data?
    var fechaCreacion: Date
    var fechaVencimiento: Date?
    var prioridad: Int // 1 = baja, 2 = media, 3 = alta
    
    init(id: UUID = UUID(),
         titulo: String,
         descripcion: String,
         completada: Bool = false,
         imagenData: Data? = nil,
         fechaCreacion: Date = Date(),
         fechaVencimiento: Date? = nil,
         prioridad: Int = 2) {
        self.id = id
        self.titulo = titulo
        self.descripcion = descripcion
        self.completada = completada
        self.imagenData = imagenData
        self.fechaCreacion = fechaCreacion
        self.fechaVencimiento = fechaVencimiento
        self.prioridad = prioridad
    }
    
    // Para exportar a JSON
    var toDictionary: [String: Any] {
        var dict: [String: Any] = [
            "id": id.uuidString,
            "titulo": titulo,
            "descripcion": descripcion,
            "completada": completada,
            "fechaCreacion": ISO8601DateFormatter().string(from: fechaCreacion),
            "prioridad": prioridad
        ]
        
        if let fechaVencimiento = fechaVencimiento {
            dict["fechaVencimiento"] = ISO8601DateFormatter().string(from: fechaVencimiento)
        }
        
        if let imagenData = imagenData {
            dict["imagenData"] = imagenData.base64EncodedString()
        }
        
        return dict
    }
    
    // Para importar desde JSON
    static func fromDictionary(_ dict: [String: Any]) -> Tarea? {
        guard let idString = dict["id"] as? String,
              let id = UUID(uuidString: idString),
              let titulo = dict["titulo"] as? String,
              let descripcion = dict["descripcion"] as? String,
              let completada = dict["completada"] as? Bool,
              let fechaCreacionString = dict["fechaCreacion"] as? String,
              let fechaCreacion = ISO8601DateFormatter().date(from: fechaCreacionString),
              let prioridad = dict["prioridad"] as? Int else {
            return nil
        }
        
        var fechaVencimiento: Date? = nil
        if let fechaVencimientoString = dict["fechaVencimiento"] as? String {
            fechaVencimiento = ISO8601DateFormatter().date(from: fechaVencimientoString)
        }
        
        var imagenData: Data? = nil
        if let imagenBase64 = dict["imagenData"] as? String {
            imagenData = Data(base64Encoded: imagenBase64)
        }
        
        return Tarea(id: id,
                    titulo: titulo,
                    descripcion: descripcion,
                    completada: completada,
                    imagenData: imagenData,
                    fechaCreacion: fechaCreacion,
                    fechaVencimiento: fechaVencimiento,
                    prioridad: prioridad)
    }
    
    var estaVencida: Bool {
        guard let fechaVencimiento = fechaVencimiento else { return false }
        return fechaVencimiento < Date() && !completada
    }
}
