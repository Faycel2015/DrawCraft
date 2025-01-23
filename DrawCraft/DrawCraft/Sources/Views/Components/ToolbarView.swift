//
//  ToolbarView.swift
//  DrawCraft
//
//  Created by FayTek on 1/22/25.
//

import Foundation
import SwiftUI

struct ToolbarView: View {
    @ObservedObject var viewModel: DrawingViewModel
    @ObservedObject var canvasState: CanvasState
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                HStack {
                    leadingToolbarItems
                    Spacer()
                    trailingToolbarItems
                }
            } else {
                VStack {
                    leadingToolbarItems
                    Spacer()
                    trailingToolbarItems
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
    
    private var leadingToolbarItems: some View {
        HStack(spacing: 20) {
            ForEach(viewModel.availableTools) { tool in
                Button(action: {
                    viewModel.selectedTool = tool
                }) {
                    Image(systemName: tool.icon)
                        .font(.title2)
                        .foregroundColor(viewModel.selectedTool == tool ? .blue : .gray)
                }
            }
            
            Button(action: {
                viewModel.toggleInspector()
            }) {
                Image(systemName: "slider.horizontal.3")
                    .font(.title2)
                    .foregroundColor(viewModel.isInspectorVisible ? .blue : .gray)
            }
        }
    }
    
    private var trailingToolbarItems: some View {
        HStack(spacing: 20) {
            Button(action: {
                canvasState.toggleGrid()
            }) {
                Image(systemName: "grid")
                    .font(.title2)
                    .foregroundColor(canvasState.showingGrid ? .blue : .gray)
            }
            
            Button(action: {
                canvasState.clearCanvas()
            }) {
                Image(systemName: "trash")
                    .font(.title2)
                    .foregroundColor(.red)
            }
            
            Button(action: {
                canvasState.showShareSheet = true
            }) {
                Image(systemName: "square.and.arrow.up")
                    .font(.title2)
            }
            
            Button(action: {
                canvasState.canvasView.undoManager?.undo()
            }) {
                Image(systemName: "arrow.uturn.backward")
                    .font(.title2)
                    .foregroundColor(viewModel.canUndo ? .blue : .gray)
            }
            .disabled(!viewModel.canUndo)
            
            Button(action: {
                canvasState.canvasView.undoManager?.redo()
            }) {
                Image(systemName: "arrow.uturn.forward")
                    .font(.title2)
                    .foregroundColor(viewModel.canRedo ? .blue : .gray)
            }
            .disabled(!viewModel.canRedo)
        }
    }
}
