//
//  CanvasState.swift
//  DrawCraft
//
//  Created by FayTek on 1/21/25.
//

import Foundation
import SwiftUI
import PencilKit

class CanvasState: ObservableObject {
    @Published var canvasView = PKCanvasView()
    @Published var drawingData: Data = Data()
    @Published var toolbarIsHidden = false
    @Published var showColorPicker = false
    @Published var showShareSheet = false
    @Published var showingGrid = false
    
    private var undoManager: UndoManager?
    
    init(undoManager: UndoManager? = nil) {
        self.undoManager = undoManager
        setupCanvas()
    }
    
    private func setupCanvas() {
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 5)
        #if os(iOS)
        canvasView.maximumZoomScale = 5.0
        canvasView.minimumZoomScale = 1.0
        #endif
    }
    
    func clearCanvas() {
        canvasView.drawing = PKDrawing()
    }
    
    func saveDrawing() {
        drawingData = canvasView.drawing.dataRepresentation()
    }
    
    func loadDrawing() {
        do {
            let drawing = try PKDrawing(data: drawingData)
            canvasView.drawing = drawing
        } catch {
            print("Failed to load drawing: \(error)")
        }
    }
    
    func exportDrawing() -> UIImage? {
        let bounds = canvasView.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        canvasView.drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func toggleGrid() {
        showingGrid.toggle()
        if showingGrid {
            addGrid()
        } else {
            removeGrid()
        }
    }
    
    private func addGrid() {
        // Implementation for adding grid overlay
    }
    
    private func removeGrid() {
        // Implementation for removing grid overlay
    }
}
