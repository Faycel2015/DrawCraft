//
//  ColorPaletteView.swift
//  DrawCraft
//
//  Created by FayTek on 1/21/25.
//

import Foundation
import SwiftUI

struct ColorPaletteView: View {
    @EnvironmentObject private var viewModel: DrawingViewModel
    
    private let colors: [Color] = [
        .black, .gray,
        .red, .orange,
        .yellow, .green,
        .blue, .purple,
        .pink
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(colors, id: \.self) { color in
                ColorButton(color: color)
            }
            
            ColorPicker("", selection: $viewModel.properties.color)
                .labelsHidden()
        }
    }
}

struct ColorButton: View {
    @EnvironmentObject private var viewModel: DrawingViewModel
    let color: Color
    
    var body: some View {
        Button(action: { viewModel.properties.color = color }) {
            Circle()
                .fill(color)
                .frame(width: 30, height: 30)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                        .opacity(viewModel.properties.color == color ? 1 : 0)
                )
        }
    }
}
