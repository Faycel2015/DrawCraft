//
//  LayerEffectsPanel.swift
//  DrawCraft
//
//  Created by FayTek on 1/23/25.
//

import Foundation
import SwiftUI

struct LayerEffectsPanel: View {
    @Binding var layer: DrawingLayer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Layer Effects")
                    .font(.headline)
                
                Spacer()
                
                Menu {
                    ForEach(EffectType.allCases, id: \.self) { type in
                        Button(type.name) {
                            layer.addEffect(type)
                        }
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
            
            if !layer.effects.isEmpty {
                List {
                    ForEach(layer.effects.indices, id: \.self) { index in
                        EffectRow(effect: $layer.effects[index])
                    }
                    .onDelete { indices in
                        indices.forEach { layer.removeEffect(at: $0) }
                    }
                }
            }
        }
        .padding()
    }
}

struct EffectRow: View {
    @Binding var effect: LayerEffect
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(effect.type.name)
                    .font(.subheadline)
                
                Spacer()
                
                Toggle("", isOn: $effect.isEnabled)
                    .labelsHidden()
            }
            
            if effect.isEnabled {
                ColorPicker("Color", selection: $effect.parameters.color)
                SliderRow(title: "Opacity", value: $effect.parameters.opacity, range: 0...1)
                SliderRow(title: "Radius", value: $effect.parameters.radius, range: 0...100)
                SliderRow(title: "Spread", value: $effect.parameters.spread, range: 0...100)
                SliderRow(title: "Distance", value: $effect.parameters.distance, range: 0...100)
                SliderRow(title: "Angle", value: $effect.parameters.angle, range: 0...360)
            }
        }
        .padding(.vertical, 4)
    }
}
