//
//  LayerEffect.swift
//  DrawCraft
//
//  Created by FayTek on 1/23/25.
//

import Foundation
import SwiftUI

struct LayerEffect: Identifiable {
    let id: UUID
    var type: EffectType
    var isEnabled: Bool
    var parameters: EffectParameters
    
    init(
        id: UUID = UUID(),
        type: EffectType,
        isEnabled: Bool = true,
        parameters: EffectParameters = .default
    ) {
        self.id = id
        self.type = type
        self.isEnabled = isEnabled
        self.parameters = parameters
    }
}

enum EffectType: String, CaseIterable {
    case shadow
    case innerShadow
    case glow
    case innerGlow
    case bevel
    case stroke
    
    var name: String { rawValue.capitalized }
}

struct EffectParameters {
    var color: Color
    var opacity: Double
    var radius: Double
    var spread: Double
    var distance: Double
    var angle: Double
    
    static let `default` = EffectParameters(
        color: .black,
        opacity: 0.5,
        radius: 10,
        spread: 0,
        distance: 5,
        angle: 45
    )
}

extension DrawingLayer {
    var effects: [LayerEffect] = []
    
    mutating func addEffect(_ type: EffectType) {
        effects.append(LayerEffect(type: type))
    }
    
    mutating func removeEffect(at index: Int) {
        effects.remove(at: index)
    }
}
