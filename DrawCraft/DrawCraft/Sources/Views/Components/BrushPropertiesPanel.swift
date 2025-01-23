//
//  BrushPropertiesPanel.swift
//  DrawCraft
//
//  Created by FayTek on 1/23/25.
//

import Foundation
import SwiftUI

struct BrushPropertiesPanel: View {
    @EnvironmentObject private var viewModel: DrawingViewModel
    @State private var properties: BrushStyle.Properties
    
    init(viewModel: DrawingViewModel) {
        _properties = State(initialValue: viewModel.selectedBrushStyle.defaultProperties)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Brush Properties")
                .font(.headline)
            
            Group {
                SliderRow(title: "Width", value: $properties.width, range: 1...50)
                SliderRow(title: "Opacity", value: $properties.opacity, range: 0...1)
                SliderRow(title: "Spacing", value: $properties.spacing, range: 0.1...3)
                SliderRow(title: "Smoothing", value: $properties.smoothing, range: 0...1)
                SliderRow(title: "Pressure Sensitivity", value: $properties.pressureSensitivity, range: 0...2)
                SliderRow(title: "Tilt Sensitivity", value: $properties.tiltSensitivity, range: 0...2)
                SliderRow(title: "Rotation Sensitivity", value: $properties.rotationSensitivity, range: 0...2)
            }
            
            HStack {
                Text("Blend Mode")
                Spacer()
                LayerBlendModePicker(blendMode: $properties.blendMode)
            }
            
            Button("Reset to Default") {
                properties = viewModel.selectedBrushStyle.defaultProperties
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .onChange(of: properties) { newValue in
            viewModel.updateBrushProperties(newValue)
        }
        .onChange(of: viewModel.selectedBrushStyle) { _ in
            properties = viewModel.selectedBrushStyle.defaultProperties
        }
    }
}

struct SliderRow: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
            HStack {
                Slider(value: $value, in: range)
                Text(String(format: "%.2f", value))
                    .font(.caption2)
                    .frame(width: 40)
            }
        }
    }
}
