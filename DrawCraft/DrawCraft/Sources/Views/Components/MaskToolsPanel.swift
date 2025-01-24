//
//  MaskToolsPanel.swift
//  DrawCraft
//
//  Created by FayTek on 1/23/25.
//

import Foundation
import SwiftUI
import PencilKit

struct MaskToolsPanel: View {
    @Binding var layer: DrawingLayer
    @State private var maskOpacity: Double = 1.0
    @State private var maskBlendMode: BlendMode = .normal
    @State private var featherRadius: Double = 0.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mask Tools")
                .font(.headline)
            
            if layer.mask != nil {
                Group {
                    SliderRow(title: "Opacity", value: $maskOpacity, range: 0...1)
                    SliderRow(title: "Feather", value: $featherRadius, range: 0...50)
                    
                    HStack {
                        Text("Blend Mode")
                        Spacer()
                        LayerBlendModePicker(blendMode: $maskBlendMode)
                    }
                    
                    HStack {
                        Button("Fill") {
                            fillMask()
                        }
                        Button("Clear") {
                            clearMask()
                        }
                        Button("Invert") {
                            invertMask()
                        }
                    }
                    .buttonStyle(.bordered)
                }
                .onChange(of: maskOpacity) { _ in updateMask() }
                .onChange(of: maskBlendMode) { _ in updateMask() }
                .onChange(of: featherRadius) { _ in updateMask() }
            }
        }
        .padding()
    }
    
    private func fillMask() {
        guard var mask = layer.mask else { return }
        mask.drawing = PKDrawing(strokes: []) // Fill the mask with a clear drawing
        layer.mask = mask
    }
    
    private func clearMask() {
        layer.mask = nil
    }
    
    private func invertMask() {
        guard var mask = layer.mask else { return }
        mask.inverted.toggle()
        layer.mask = mask
    }
    
    private func updateMask() {
        guard var mask = layer.mask else { return }
        mask.isEnabled = true // Update mask properties as needed
        layer.mask = mask
    }
}
