//
//  LayerMaskControls.swift
//  DrawCraft
//
//  Created by FayTek on 1/23/25.
//

import Foundation
import SwiftUI

struct LayerMaskControls: View {
    @Binding var layer: DrawingLayer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Layer Mask")
                    .font(.subheadline)
                
                Spacer()
                
                if layer.mask == nil {
                    Button("Add Mask") {
                        layer.createMask()
                    }
                } else {
                    Button("Remove Mask") {
                        layer.removeMask()
                    }
                    .foregroundColor(.red)
                }
            }
            
            if let mask = layer.mask {
                Toggle("Enable Mask", isOn: .init(
                    get: { mask.isEnabled },
                    set: { layer.mask?.isEnabled = $0 }
                ))
                
                Toggle("Invert Mask", isOn: .init(
                    get: { mask.inverted },
                    set: { layer.mask?.inverted = $0 }
                ))
            }
        }
        .padding(.vertical, 4)
    }
}
