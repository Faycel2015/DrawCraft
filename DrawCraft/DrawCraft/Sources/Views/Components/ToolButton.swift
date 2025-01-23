//
//  ToolButton.swift
//  DrawCraft
//
//  Created by FayTek on 1/21/25.
//

import Foundation
import SwiftUI

struct ToolButton: View {
    @EnvironmentObject private var viewModel: DrawingViewModel
    let tool: DrawingTool
    
    var body: some View {
        Button(action: { viewModel.selectedTool = tool }) {
            Image(systemName: tool.icon)
                .font(.title2)
                .foregroundColor(viewModel.selectedTool == tool ? .accentColor : .gray)
                .frame(width: 44, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(viewModel.selectedTool == tool ? Color.accentColor.opacity(0.2) : Color.clear)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .help(tool.name)
    }
}
