//
//  InspectorPanelView.swift
//  DrawCraft
//
//  Created by FayTek on 1/21/25.
//

import SwiftUI

struct InspectorPanelView: View {
    @EnvironmentObject private var viewModel: DrawingViewModel

    var body: some View {
        VStack(spacing: 20) {
            ColorPicker("Color", selection: $viewModel.properties.color) // Use properties.color
                .labelsHidden()

            VStack(alignment: .leading) {
                Text("Thickness")
                    .font(.caption)
                Slider(value: $viewModel.properties.width, in: 1...50) { // Use properties.width
                    Text("Thickness")
                } minimumValueLabel: {
                    Text("1")
                } maximumValueLabel: {
                    Text("50")
                }
            }

            VStack(alignment: .leading) {
                Text("Opacity")
                    .font(.caption)
                Slider(value: $viewModel.properties.opacity, in: 0...1) { // Use properties.opacity
                    Text("Opacity")
                } minimumValueLabel: {
                    Text("0%")
                } maximumValueLabel: {
                    Text("100%")
                }
            }

            if viewModel.selectedTool == .ruler {
                Toggle("Show Grid", isOn: $viewModel.properties.isRulerActive) // Use properties.isRulerActive
            }

            Spacer()
        }
        .padding()
        .frame(width: 250)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}
