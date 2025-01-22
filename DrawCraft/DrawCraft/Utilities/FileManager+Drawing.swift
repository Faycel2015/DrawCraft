//
//  FileManager+Drawing.swift
//  DrawCraft
//
//  Created by FayTek on 1/21/25.
//

import Foundation

extension FileManager {
    static var drawingsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("Drawings")
    }
    
    static func saveDrawing(_ drawing: Drawing) throws {
        let url = drawingsDirectory.appendingPathComponent("\(drawing.id.uuidString).drawing")
        try FileManager.default.createDirectory(at: drawingsDirectory, withIntermediateDirectories: true)
        let data = try JSONEncoder().encode(drawing)
        try data.write(to: url)
    }
    
    static func loadDrawings() throws -> [Drawing] {
        let urls = try FileManager.default.contentsOfDirectory(
            at: drawingsDirectory,
            includingPropertiesForKeys: nil
        )
        return try urls.compactMap { url in
            guard url.pathExtension == "drawing" else { return nil }
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(Drawing.self, from: data)
        }
    }
}
