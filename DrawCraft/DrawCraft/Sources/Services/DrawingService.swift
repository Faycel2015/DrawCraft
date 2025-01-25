//
//  DrawingService.swift
//  DrawCraft
//
//  Created by FayTek on 1/21/25.
//

import Foundation
import SwiftUI
import PencilKit

//#if os(iOS)
//import UIKit
////typealias PlatformImage = UIImage
//#else
//import AppKit
//typealias PlatformImage = NSImage
//#endif

// MARK: - FileManager Extension
extension FileManager {
    static func saveDrawing(_ drawing: Drawing) throws {
        let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentsDirectory.appendingPathComponent("\(drawing.id.uuidString).drawing")
        let data = try JSONEncoder().encode(drawing)
        try data.write(to: fileURL)
    }
    
    static func loadDrawings() throws -> [Drawing] {
        let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
        
        var drawings: [Drawing] = []
        for fileURL in fileURLs where fileURL.pathExtension == "drawing" {
            let data = try Data(contentsOf: fileURL)
            let drawing = try JSONDecoder().decode(Drawing.self, from: data)
            drawings.append(drawing)
        }
        return drawings
    }
}

// MARK: - DrawingService
class DrawingService {
    @MainActor static let shared = DrawingService()
    
    private init() {}
    
    func saveDrawing(_ drawing: Drawing) throws {
        try FileManager.saveDrawing(drawing)
    }
    
    func loadDrawings() throws -> [Drawing] {
        try FileManager.loadDrawings()
    }
    
    @MainActor func exportAsImage(_ canvasView: PKCanvasView) -> PlatformImage? {
        let bounds = canvasView.bounds
        
        #if os(iOS)
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        canvasView.drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
        #else
        let image = NSImage(size: bounds.size)
        image.lockFocus()
        if let context = NSGraphicsContext.current {
            canvasView.draw(bounds, in: context)
        }
        image.unlockFocus()
        return image
        #endif
    }
    
    @MainActor func exportAsPDF(_ canvasView: PKCanvasView) -> Data? {
        let bounds = canvasView.bounds
        let pdfData = NSMutableData()
        
        #if os(iOS)
        UIGraphicsBeginPDFContextToData(pdfData, bounds, nil)
        UIGraphicsBeginPDFPage()
        canvasView.drawHierarchy(in: bounds, afterScreenUpdates: true)
        UIGraphicsEndPDFContext()
        #else
        if let context = CGContext(consumer: CGDataConsumer(data: pdfData as CFMutableData)!,
                                 mediaBox: &CGRect(bounds),
                                 nil) {
            context.beginPDFPage(nil)
            canvasView.draw(bounds, in: NSGraphicsContext(cgContext: context, flipped: false)!)
            context.endPDFPage()
            context.closePDF()
        }
        #endif
        
        return pdfData as Data
    }
}

// MARK: - Test Save & Load Drawings
extension DrawingService {
    @MainActor static func testSaveAndLoadDrawings() {
        let drawingService = DrawingService.shared
        
        // Create a sample drawing
        let drawingData = Data() // Replace with actual PKDrawing data
        let drawing = Drawing(name: "Test Drawing", drawingData: drawingData)
        
        do {
            // Save the drawing
            try drawingService.saveDrawing(drawing)
            print("Drawing saved successfully.")
            
            // Load the drawings
            let loadedDrawings = try drawingService.loadDrawings()
            print("Loaded drawings: \(loadedDrawings)")
        } catch {
            print("Failed to save or load drawings: \(error)")
        }
    }
}
