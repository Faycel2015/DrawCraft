//
//  BlendMode+Drawing.swift
//  DrawCraft
//
//  Created by FayTek on 1/23/25.
//

import Foundation
import SwiftUI

extension BlendMode {
    static let drawingModes: [BlendMode] = [
        .normal, .multiply, .screen, .overlay, .darken, .lighten,
        .colorDodge, .colorBurn, .softLight, .hardLight,
        .difference, .exclusion, .hue, .saturation, .color, .luminosity
    ]

    private static let modeNames: [BlendMode: String] = [
        .normal: "Normal",
        .multiply: "Multiply",
        .screen: "Screen",
        .overlay: "Overlay",
        .darken: "Darken",
        .lighten: "Lighten",
        .colorDodge: "Color Dodge",
        .colorBurn: "Color Burn",
        .softLight: "Soft Light",
        .hardLight: "Hard Light",
        .difference: "Difference",
        .exclusion: "Exclusion",
        .hue: "Hue",
        .saturation: "Saturation",
        .color: "Color",
        .luminosity: "Luminosity"
    ]

    var name: String {
        return Self.modeNames[self] ?? "Normal"
    }
}
