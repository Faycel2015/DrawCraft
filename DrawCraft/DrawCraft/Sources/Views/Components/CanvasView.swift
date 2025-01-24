//
//  CanvasView.swift
//  DrawCraft
//
//  Created by FayTek on 1/21/25.
//

import SwiftUI
import PencilKit
import UniformTypeIdentifiers

struct CanvasView: PlatformViewRepresentable {
    let canvasView: PKCanvasView
    @EnvironmentObject private var viewModel: DrawingViewModel
    
    #if os(iOS)
    func makeUIView(context: Context) -> PKCanvasView {
        setupCanvas(canvasView, coordinator: context.coordinator)
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        updateCanvas(uiView)
    }
    #else
    func makeNSView(context: Context) -> PKCanvasView {
        setupCanvas(canvasView, coordinator: context.coordinator)
        return canvasView
    }
    
    func updateNSView(_ nsView: PKCanvasView, context: Context) {
        updateCanvas(nsView)
    }
    #endif
    
    private func setupCanvas(_ canvas: PKCanvasView, coordinator: Coordinator) {
        canvas.delegate = coordinator
        canvas.drawingPolicy = .anyInput
        
        #if os(iOS)
        // Enhanced Apple Pencil Support
        canvas.drawingPolicy = .pencilOnly
        canvas.maximumZoomScale = 5.0
        canvas.minimumZoomScale = 1.0
        
        // Configure tool picker
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let toolPicker = PKToolPicker.shared(for: windowScene) {
            toolPicker.setVisible(true, forFirstResponder: canvas)
            toolPicker.addObserver(canvas)
            canvas.becomeFirstResponder()
        }
        
        // Drag and Drop Support
        canvas.isUserInteractionEnabled = true
        canvas.addInteraction(UIDragInteraction(delegate: coordinator))
        canvas.addInteraction(UIDropInteraction(delegate: coordinator))
        
        // Gestures
        let pinchGesture = UIPinchGestureRecognizer(target: coordinator, action: #selector(Coordinator.handlePinch(_:)))
        let rotationGesture = UIRotationGestureRecognizer(target: coordinator, action: #selector(Coordinator.handleRotation(_:)))
        let panGesture = UIPanGestureRecognizer(target: coordinator, action: #selector(Coordinator.handlePan(_:)))
        
        canvas.addGestureRecognizer(pinchGesture)
        canvas.addGestureRecognizer(rotationGesture)
        canvas.addGestureRecognizer(panGesture)
        #endif
        
        updateCanvas(canvas)
    }
    
    private func updateCanvas(_ canvas: PKCanvasView) {
        viewModel.updateTool(in: canvas)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        let parent: CanvasView
        private var scale: CGFloat = 1.0
        private var rotation: CGFloat = 0.0
        
        init(_ parent: CanvasView) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            parent.viewModel.updateUndoState(canvasView: canvasView)
        }
        
        #if os(iOS)
        // Apple Pencil pressure and tilt handling
        func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
            if let tool = canvasView.tool as? PKInkingTool {
                // Adjust ink based on pressure and tilt
                let pressure = 1.0 // Replace with actual pressure value
                let tilt = 0.0 // Replace with actual tilt value
                
                parent.viewModel.updateInkProperties(pressure: pressure, tilt: tilt)
            }
        }
        
        // Gesture Handlers
        @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
            guard let view = gesture.view else { return }
            
            switch gesture.state {
            case .changed:
                scale *= gesture.scale
                view.transform = CGAffineTransform(scaleX: scale, y: scale)
                gesture.scale = 1.0
            default:
                break
            }
        }
        
        @objc func handleRotation(_ gesture: UIRotationGestureRecognizer) {
            guard let view = gesture.view else { return }
            
            switch gesture.state {
            case .changed:
                rotation += gesture.rotation
                view.transform = view.transform.rotated(by: gesture.rotation)
                gesture.rotation = 0
            default:
                break
            }
        }
        
        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            guard let view = gesture.view else { return }
            
            switch gesture.state {
            case .changed:
                let translation = gesture.translation(in: view)
                view.center = CGPoint(
                    x: view.center.x + translation.x,
                    y: view.center.y + translation.y
                )
                gesture.setTranslation(.zero, in: view)
            default:
                break
            }
        }
        #endif
    }
}

#if os(iOS)
// Drag and Drop Support
extension CanvasView.Coordinator: UIDragInteractionDelegate, UIDropInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        guard let image = parent.canvasView.drawing.image(from: parent.canvasView.bounds, scale: 1.0) else {
            return []
        }
        
        let provider = NSItemProvider(object: image)
        let item = UIDragItem(itemProvider: provider)
        return [item]
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: UIImage.self) { items in
            guard let image = items.first as? UIImage else { return }
            
            DispatchQueue.main.async {
                // Handle dropped image
                let drawing = PKDrawing()
                // Convert image to PKDrawing and merge with current drawing
                self.parent.canvasView.drawing.append(drawing)
            }
        }
    }
}
#endif
