//
//  DrawingService.swift
//  DrawCraft
//
//  Created by FayTek on 1/21/25.
//

import Foundation
import PencilKit
#if os(iOS)
import UIKit
#else
import AppKit
#endif

class DrawingService {
    static let shared = DrawingService()
    
    private init() {}
    
    func saveDrawing(_ drawing: Drawing) throws {
        try FileManager.saveDrawing(drawing)
    }
    
    func loadDrawings() throws -> [Drawing] {
        try FileManager.loadDrawings()
    }
    
    func exportAsImage(_ canvasView: PKCanvasView) -> PlatformImage? {
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
    
    func exportAsPDF(_ canvasView: PKCanvasView) -> Data? {
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
