//
//  CanvasState.swift
//  DrawCraft
//
//  Created by FayTek on 1/21/25.
//

import Foundation
import PencilKit

@MainActor
class CanvasState: ObservableObject {
    @Published var canvasView = PKCanvasView()
    @Published var currentDrawing: Drawing? // Add this property
    @Published var drawingData: Data = Data()
    @Published var toolbarIsHidden = false
    @Published var showColorPicker = false
    @Published var showShareSheet = false
    @Published var showingGrid = false
    
    private var undoManager: UndoManager?
    private var gridView: UIView? // To hold the grid overlay
    
    @MainActor
    init(undoManager: UndoManager? = nil) {
        self.undoManager = undoManager
        setupCanvas()
    }
    
    @MainActor private func setupCanvas() {
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 5)
        #if os(iOS)
        canvasView.maximumZoomScale = 5.0
        canvasView.minimumZoomScale = 1.0
        #endif
    }
    
    @MainActor func clearCanvas() {
        canvasView.drawing = PKDrawing()
    }
    
    @MainActor func saveDrawing() {
        drawingData = canvasView.drawing.dataRepresentation()
    }
    
    @MainActor func loadDrawing() {
        do {
            let drawing = try PKDrawing(data: drawingData)
            canvasView.drawing = drawing
        } catch {
            print("Failed to load drawing: \(error)")
        }
    }
    
    @MainActor func exportDrawing() -> UIImage? {
        let bounds = canvasView.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        canvasView.drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    @MainActor func toggleGrid() {
        showingGrid.toggle()
        if showingGrid {
            addGrid()
        } else {
            removeGrid()
        }
    }
    
    @MainActor private func addGrid() {
        guard gridView == nil else { return } // Ensure grid is not already added
        
        // Create a grid overlay
        let gridSize: CGFloat = 20.0 // Adjust grid size as needed
        let gridColor = UIColor.gray.withAlphaComponent(0.5) // Adjust grid color and opacity
        
        let gridLayer = CAShapeLayer()
        gridLayer.strokeColor = gridColor.cgColor
        gridLayer.lineWidth = 1.0
        
        let path = UIBezierPath()
        
        // Draw vertical lines
        var x: CGFloat = 0
        while x < canvasView.bounds.width {
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: canvasView.bounds.height))
            x += gridSize
        }
        
        // Draw horizontal lines
        var y: CGFloat = 0
        while y < canvasView.bounds.height {
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: canvasView.bounds.width, y: y))
            y += gridSize
        }
        
        gridLayer.path = path.cgPath
        
        // Create a UIView to hold the grid layer
        let gridView = UIView(frame: canvasView.bounds)
        gridView.layer.addSublayer(gridLayer)
        gridView.isUserInteractionEnabled = false // Ensure the grid doesn't interfere with drawing
        
        // Add the grid view as a subview to the canvas
        canvasView.addSubview(gridView)
        self.gridView = gridView // Store the grid view for later removal
    }
    
    @MainActor private func removeGrid() {
        guard let gridView = gridView else { return } // Ensure grid exists
        
        // Remove the grid view from the canvas
        gridView.removeFromSuperview()
        self.gridView = nil // Clear the reference
    }
}
