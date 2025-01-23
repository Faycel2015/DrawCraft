//
//  BlendMode+Drawing.swift
//  DrawCraft
//
//  Created by FayTek on 1/23/25.
//

import Foundation
import SwiftUI

extension BlendMode {
    static var drawingModes: [BlendMode] = [
        .normal,
        .multiply,
        .screen,
        .overlay,
        .darken,
        .lighten,
        .colorDodge,
        .colorBurn,
        .softLight,
        .hardLight,
        .difference,
        .exclusion,
        .hue,
        .saturation,
        .color,
        .luminosity
    ]
    
    var name: String {
        switch self {
        case .normal: return "Normal"
        case .multiply: return "Multiply"
        case .screen: return "Screen"
        case .overlay: return "Overlay"
        case .darken: return "Darken"
        case .lighten: return "Lighten"
        case .colorDodge: return "Color Dodge"
        case .colorBurn: return "Color Burn"
        case .softLight: return "Soft Light"
        case .hardLight: return "Hard Light"
        case .difference: return "Difference"
        case .exclusion: return "Exclusion"
        case .hue: return "Hue"
        case .saturation: return "Saturation"
        case .color: return "Color"
        case .luminosity: return "Luminosity"
        default: return "Normal"
        }
    }
}
