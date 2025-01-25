//
//  BrushStyle.swift
//  DrawCraft
//
//  Created by FayTek on 1/23/25.
//

import Foundation
import SwiftUI
import PencilKit

enum BrushStyle: String, CaseIterable, Identifiable {
    case pen
    case marker
    case pencil
    case watercolor
    case calligraphy
    case airbrush
    case crayon
    case charcoal
    
    var id: String { rawValue }
    
    var name: String {
        rawValue.capitalized
    }
    
    // Enhanced brush properties
    struct Properties {
        var width: CGFloat
        var opacity: Double
        var spacing: CGFloat
        var smoothing: CGFloat
        var pressureSensitivity: Double
        var tiltSensitivity: Double
        var rotationSensitivity: Double
        var blendMode: BlendMode
        
        static let `default` = Properties(
            width: 5,
            opacity: 1.0,
            spacing: 1.0,
            smoothing: 0.5,
            pressureSensitivity: 1.0,
            tiltSensitivity: 1.0,
            rotationSensitivity: 1.0,
            blendMode: .normal
        )
    }
    
    var defaultProperties: Properties {
        switch self {
        case .pen:
            return Properties(
                width: 2,
                opacity: 1.0,
                spacing: 1.0,
                smoothing: 0.3,
                pressureSensitivity: 1.0,
                tiltSensitivity: 0.8,
                rotationSensitivity: 0.5,
                blendMode: .normal
            )
        case .marker:
            return Properties(
                width: 8,
                opacity: 0.8,
                spacing: 1.2,
                smoothing: 0.4,
                pressureSensitivity: 0.7,
                tiltSensitivity: 0.3,
                rotationSensitivity: 0.2,
                blendMode: .multiply
            )
        case .pencil:
            return Properties(
                width: 3,
                opacity: 0.9,
                spacing: 0.8,
                smoothing: 0.2,
                pressureSensitivity: 1.2,
                tiltSensitivity: 1.0,
                rotationSensitivity: 0.8,
                blendMode: .normal
            )
        case .watercolor:
            return Properties(
                width: 15,
                opacity: 0.6,
                spacing: 1.5,
                smoothing: 0.7,
                pressureSensitivity: 0.9,
                tiltSensitivity: 0.5,
                rotationSensitivity: 0.3,
                blendMode: .softLight
            )
        case .calligraphy:
            return Properties(
                width: 6,
                opacity: 1.0,
                spacing: 1.0,
                smoothing: 0.4,
                pressureSensitivity: 1.3,
                tiltSensitivity: 1.2,
                rotationSensitivity: 1.0,
                blendMode: .normal
            )
        case .airbrush:
            return Properties(
                width: 20,
                opacity: 0.4,
                spacing: 2.0,
                smoothing: 0.8,
                pressureSensitivity: 0.6,
                tiltSensitivity: 0.4,
                rotationSensitivity: 0.2,
                blendMode: .screen
            )
        case .crayon:
            return Properties(
                width: 10,
                opacity: 0.95,
                spacing: 0.7,
                smoothing: 0.2,
                pressureSensitivity: 1.1,
                tiltSensitivity: 0.9,
                rotationSensitivity: 0.6,
                blendMode: .multiply
            )
        case .charcoal:
            return Properties(
                width: 8,
                opacity: 0.85,
                spacing: 0.6,
                smoothing: 0.3,
                pressureSensitivity: 1.4,
                tiltSensitivity: 1.1,
                rotationSensitivity: 0.7,
                blendMode: .multiply
            )
        }
    }
    
    func createInk(color: UIColor, properties: Properties, pressure: Double = 1.0, tilt: Double = 0.0, rotation: Double = 0.0) -> PKInkingTool {
        let width = properties.width *
        (pressure * properties.pressureSensitivity) *
        (1 + tilt * properties.tiltSensitivity) *
        (1 + rotation * properties.rotationSensitivity)
        
        let inkType: PKInkingTool.InkType
        switch self {
        case .pen:
            inkType = .pen
        case .marker:
            inkType = .marker
        case .pencil:
            inkType = .pencil
        case .watercolor, .calligraphy, .airbrush, .crayon, .charcoal:
            // Map unsupported brush styles to .pen as a fallback
            inkType = .pen
        }
        return PKInkingTool(inkType, color: color, width: width)
    }
}
