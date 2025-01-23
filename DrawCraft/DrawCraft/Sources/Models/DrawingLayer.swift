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
    
    init(
        id: UUID = UUID(),
        name: String = "Layer",
        drawing: PKDrawing = PKDrawing(),
        isVisible: Bool = true,
        opacity: Double = 1.0,
        blendMode: BlendMode = .normal
    ) {
        self.id = id
        self.name = name
        self.drawing = drawing
        self.isVisible = isVisible
        self.opacity = opacity
        self.blendMode = blendMode
    }
}
