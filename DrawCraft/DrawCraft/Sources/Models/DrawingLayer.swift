//
//  DrawingLayer.swift
//  DrawCraft
//
//  Created by FayTek on 1/23/25.
//

import Foundation
import SwiftUI
import PencilKit

struct DrawingLayer: Identifiable {
    let id: UUID
    var name: String
    var drawing: PKDrawing
    var isVisible: Bool
    var opacity: Double
    var blendMode: BlendMode
    
    // Effects and mask properties
    var effects: [LayerEffect] = []
    var mask: LayerMask?
    
    init(
        id: UUID = UUID(),
        name: String = "Layer",
        drawing: PKDrawing = PKDrawing(),
        isVisible: Bool = true,
        opacity: Double = 1.0,
        blendMode: BlendMode = .normal,
        effects: [LayerEffect] = [],
        mask: LayerMask? = nil
    ) {
        self.id = id
        self.name = name
        self.drawing = drawing
        self.isVisible = isVisible
        self.opacity = opacity
        self.blendMode = blendMode
        self.effects = effects
        self.mask = mask
    }
    
    // Methods for managing effects
    mutating func addEffect(_ type: EffectType) {
        effects.append(LayerEffect(type: type))
    }
    
    mutating func removeEffect(at index: Int) {
        effects.remove(at: index)
    }
    
    // Methods for managing the mask
    mutating func createMask() {
        mask = LayerMask(isEnabled: true)
    }
    
    mutating func removeMask() {
        mask = nil
    }
}

extension DrawingLayer {
    var description: String {
        return "Layer \(name) with \(effects.count) effects and \(mask == nil ? "no mask" : "a mask")"
    }
}
