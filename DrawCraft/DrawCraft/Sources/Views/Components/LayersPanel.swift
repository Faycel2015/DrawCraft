//
//  LayersPanel.swift
//  DrawCraft
//
//  Created by FayTek on 1/23/25.
//

import Foundation
import SwiftUI

struct LayersPanel: View {
    @EnvironmentObject private var viewModel: DrawingViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Layers")
                    .font(.headline)
                Spacer()
                Button(action: { viewModel.addLayer() }) {
                    Image(systemName: "plus")
                }
            }
            .padding(.horizontal)
            
            List {
                ForEach(viewModel.layers.indices, id: \.self) { index in
                    LayerRow(layer: $viewModel.layers[index], isSelected: viewModel.selectedLayerIndex == index)
                        .onTapGesture {
                            viewModel.selectedLayerIndex = index
                        }
                }
                .onMove { source, destination in
                    viewModel.moveLayer(from: source.first!, to: destination)
                }
                .onDelete { indexSet in
                    indexSet.forEach { viewModel.removeLayer(at: $0) }
                }
            }
        }
        .frame(width: 250)
    }
}

struct LayerRow: View {
    @Binding var layer: DrawingLayer
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Toggle(isOn: $layer.isVisible) {
                Image(systemName: layer.isVisible ? "eye" : "eye.slash")
            }
            .labelsHidden()
            
            TextField("Layer Name", text: $layer.name)
                .textFieldStyle(.roundedBorder)
            
            Slider(value: $layer.opacity, in: 0...1)
                .frame(width: 60)
        }
        .padding(.vertical, 4)
        .background(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
        .cornerRadius(6)
    }
}
