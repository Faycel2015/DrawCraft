import SwiftUI
import PencilKit
import Combine

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
    
    // Apple Pencil Properties
    @Published var inkPressure: Double = 1.0
    @Published var inkTilt: Double = 0.0
    @Published var selectedBrushStyle: BrushStyle = .pen
    
    // Layer Management
    @Published var layers: [DrawingLayer] = [DrawingLayer(name: "Background")]
    @Published var selectedLayerIndex: Int = 0
    
    private let tools: [DrawingTool] = [.pen, .marker, .pencil, .eraser, .lasso, .ruler]
    
    var availableTools: [DrawingTool] { tools }
    var selectedLayer: DrawingLayer { layers[selectedLayerIndex] }
    
    @MainActor func updateTool(in canvasView: PKCanvasView) {
        switch selectedTool {
        case .pen, .marker, .pencil:
            let ink = selectedBrushStyle.createInk(
                color: UIColor(properties.color),
                width: properties.thickness,
                pressure: inkPressure,
                tilt: inkTilt
            )
            #if os(iOS)
            ink.azimuthUnitVector = CGVector(dx: cos(inkTilt), dy: sin(inkTilt))
            #endif
            canvasView.tool = ink
            
        case .eraser:
            canvasView.tool = PKEraserTool(.vector)
        case .lasso:
            canvasView.tool = PKLassoTool()
        case .ruler:
            properties.isRulerActive.toggle()
        }
    }
    
    // Layer Management
    func addLayer() {
        layers.append(DrawingLayer(name: "Layer \(layers.count + 1)"))
        selectedLayerIndex = layers.count - 1
    }
    
    func removeLayer(at index: Int) {
        guard layers.count > 1 && index < layers.count else { return }
        layers.remove(at: index)
        if selectedLayerIndex >= layers.count {
            selectedLayerIndex = layers.count - 1
        }
    }
    
    func moveLayer(from source: Int, to destination: Int) {
        layers.move(fromOffsets: IndexSet(integer: source), toOffset: destination)
    }
    
    func mergeVisibleLayers() -> PKDrawing {
        var mergedDrawing = PKDrawing()
        for layer in layers where layer.isVisible {
            mergedDrawing.append(layer.drawing)
        }
        return mergedDrawing
    }
    
    func updateInkProperties(pressure: Double, tilt: Double) {
        inkPressure = pressure
        inkTilt = tilt
        objectWillChange.send()
    }
    
    @MainActor func clearCanvas(canvasView: PKCanvasView) {
        layers[selectedLayerIndex].drawing = PKDrawing()
        updateCanvasDrawing(canvasView)
    }
    
    @MainActor func updateCanvasDrawing(_ canvasView: PKCanvasView) {
        canvasView.drawing = mergeVisibleLayers()
    }
    
    @MainActor func updateUndoState(canvasView: PKCanvasView) {
        canUndo = canvasView.undoManager?.canUndo ?? false
        canRedo = canvasView.undoManager?.canRedo ?? false
    }
    
    func toggleInspector() {
        isInspectorVisible.toggle()
    }
    
    @MainActor func exportAsImage(canvasView: PKCanvasView) -> PlatformImage? {
        let bounds = canvasView.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        canvasView.drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    @MainActor func exportAsPDF(canvasView: PKCanvasView) -> Data? {
        let drawing = canvasView.drawing
        return drawing.dataRepresentation()
    }
}

struct DrawingProperties {
    var color: Color = .black
    var thickness: CGFloat = 5.0
    var isRulerActive: Bool = false
}
