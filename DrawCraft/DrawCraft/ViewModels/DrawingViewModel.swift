//
//  DrawingViewModel.swift
//  DrawCraft
//
//  Created by FayTek on 1/21/25.
//

import Foundation
import SwiftUI
import PencilKit

class DrawingViewModel: ObservableObject {
    @Published var selectedTool: DrawingTool = .pen
    @Published var properties = DrawingProperties()
    @Published var canUndo = false
    @Published var canRedo = false
    @Published var showingToolOptions = false
    @Published var showingColorPicker = false
    @Published var isInspectorVisible = false
    @Published var showNewProjectSheet = false
    @Published var showSettings = false
    
    private let drawingService = DrawingService.shared
    private let tools: [DrawingTool] = [.pen, .marker, .pencil, .eraser, .lasso, .ruler]
    
    var availableTools: [DrawingTool] { tools }
    
    func updateTool(in canvasView: PKCanvasView) {
        switch selectedTool {
        case .pen, .marker, .pencil:
            canvasView.tool = PKInkingTool(
                selectedTool.toolType,
                color: UIColor(properties.color),
                width: properties.thickness
            )
        case .eraser:
            canvasView.tool = PKEraserTool(.vector)
        case .lasso:
            canvasView.tool = PKLassoTool()
        case .ruler:
            properties.isRulerActive.toggle()
        }
    }
    
    func clearCanvas(canvasView: PKCanvasView) {
        canvasView.drawing = PKDrawing()
    }
    
    func updateUndoState(canvasView: PKCanvasView) {
        canUndo = canvasView.undoManager?.canUndo ?? false
        canRedo = canvasView.undoManager?.canRedo ?? false
    }
    
    func toggleInspector() {
        isInspectorVisible.toggle()
    }
    
    func exportAsImage() {
        // Implementation using DrawingService
    }
    
    func exportAsPDF() {
        // Implementation using DrawingService
    }
}
