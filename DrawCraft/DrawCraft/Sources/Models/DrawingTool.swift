//
//  DrawingTool.swift
//  DrawCraft
//
//  Created by FayTek on 1/21/25.
//

import Foundation
import SwiftUI
import PencilKit

enum DrawingTool: Identifiable {
    case pen
    case marker
    case pencil
    case eraser
    case lasso
    case ruler
    
    var id: String { icon }
    
    var toolType: PKInkingTool.InkType {
        switch self {
        case .pen: return .pen
        case .marker: return .marker
        case .pencil: return .pencil
        case .eraser, .lasso, .ruler: return .pen
        }
    }
    
    var icon: String {
        switch self {
        case .pen: return "pencil.tip"
        case .marker: return "highlighter"
        case .pencil: return "pencil.line"
        case .eraser: return "eraser"
        case .lasso: return "lasso"
        case .ruler: return "ruler"
        }
    }
    
    var name: String {
        switch self {
        case .pen: return "Pen"
        case .marker: return "Marker"
        case .pencil: return "Pencil"
        case .eraser: return "Eraser"
        case .lasso: return "Lasso"
        case .ruler: return "Ruler"
        }
    }
}
