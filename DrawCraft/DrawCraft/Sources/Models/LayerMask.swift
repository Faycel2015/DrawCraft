//
//  LayerMask.swift
//  DrawCraft
//
//  Created by FayTek on 1/23/25.
//

import Foundation
import SwiftUI
import PencilKit

struct LayerMask: Identifiable {
    let id: UUID
    var drawing: PKDrawing
    var isEnabled: Bool
    var inverted: Bool
    
    init(
        id: UUID = UUID(),
        drawing: PKDrawing = PKDrawing(),
        isEnabled: Bool = false,
        inverted: Bool = false
    ) {
        self.id = id
        self.drawing = drawing
        self.isEnabled = isEnabled
        self.inverted = inverted
    }
}
