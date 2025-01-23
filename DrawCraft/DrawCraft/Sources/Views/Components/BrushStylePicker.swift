//
//  BrushStylePicker.swift
//  DrawCraft
//
//  Created by FayTek on 1/23/25.
//

import Foundation
import SwiftUI

struct BrushStylePicker: View {
    @EnvironmentObject private var viewModel: DrawingViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Brush Style")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(BrushStyle.allCases) { style in
                        BrushStyleButton(style: style)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct BrushStyleButton: View {
    @EnvironmentObject private var viewModel: DrawingViewModel
    let style: BrushStyle
    
    var body: some View {
        Button(action: { viewModel.selectedBrushStyle = style }) {
            VStack {
                Circle()
                    .fill(Color.accentColor)
                    .frame(width: 30, height: 30)
                    .opacity(viewModel.selectedBrushStyle == style ? 1 : 0.5)
                
                Text(style.name)
                    .font(.caption)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
