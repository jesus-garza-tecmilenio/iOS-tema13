//
//  FileManager+Extensions.swift
//  Tema13Swift
//
//  Created by JESUS GARZA on 11/11/25.
//

import Foundation

extension FileManager {
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    static func exportarTareasAJSON(tareas: [Tarea]) throws -> URL {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fileName = "tareas_export_\(dateFormatter.string(from: Date())).json"
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        
        let tareasDict = tareas.map { $0.toDictionary }
        let jsonData = try JSONSerialization.data(withJSONObject: tareasDict, options: .prettyPrinted)
        
        try jsonData.write(to: fileURL)
        return fileURL
    }
    
    static func importarTareasDesdeJSON(fileURL: URL) throws -> [[String: Any]] {
        let data = try Data(contentsOf: fileURL)
        guard let tareasDict = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            throw NSError(domain: "FileManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Formato de JSON inválido"])
        }
        return tareasDict
    }
    
    static func listarArchivosJSON() -> [URL] {
        let documentsURL = getDocumentsDirectory()
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            return fileURLs.filter { $0.pathExtension == "json" && $0.lastPathComponent.hasPrefix("tareas_export_") }
        } catch {
            print("Error al listar archivos: \(error)")
            return []
        }
    }
}
