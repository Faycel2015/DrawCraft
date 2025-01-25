//
//  BrushPropertiesPanel.swift
//  DrawCraft
//
//  Created by FayTek on 1/23/25.
//

import SwiftUI

struct BrushPropertiesPanel: View {
    @EnvironmentObject private var viewModel: DrawingViewModel
//    @State private var properties: BrushStyle.Properties
//    
//    init() {
//        _properties = State(initialValue: BrushStyle.Properties.default)
//    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Brush Properties")
                .font(.headline)
            
            Group {
                SliderRow(title: "Width", value: $viewModel.properties.width, range: 1...50)
                SliderRow(title: "Opacity", value: $viewModel.properties.opacity, range: 0...1)
                SliderRow(title: "Spacing", value: $viewModel.properties.spacing, range: 0.1...3)
                SliderRow(title: "Smoothing", value: $viewModel.properties.smoothing, range: 0...1)
                SliderRow(title: "Pressure Sensitivity", value: $viewModel.properties.pressureSensitivity, range: 0...2)
                SliderRow(title: "Tilt Sensitivity", value: $viewModel.properties.tiltSensitivity, range: 0...2)
                SliderRow(title: "Rotation Sensitivity", value: $viewModel.properties.rotationSensitivity, range: 0...2)
            }
            
            HStack {
                Text("Blend Mode")
                Spacer()
                LayerBlendModePicker(blendMode: $viewModel.properties.blendMode)
            }
            
            Button("Reset to Default") {
                viewModel.properties = viewModel.selectedBrushStyle.defaultProperties // Use defaultProperties
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
//                .onChange(of: properties) { newValue in
//                    // Update the ViewModel when properties change
//                    viewModel.selectedBrushStyle.properties = newValue
//                }
//                .onChange(of: viewModel.selectedBrushStyle) { _ in
//                    // Reset properties when the brush style changes
//                    properties = viewModel.selectedBrushStyle.properties
//                }
    }
}

struct LayerBlendModePicker: View {
    @Binding var blendMode: BlendMode
    
    var body: some View {
        Picker("Blend Mode", selection: $blendMode) {
            ForEach(BlendMode.drawingModes, id: \.self) { mode in
                Text(mode.name).tag(mode)
            }
        }
        .pickerStyle(MenuPickerStyle())
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
