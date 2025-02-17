//
//  BrushTexture.swift
//  DrawCraft
//
//  Created by FayTek on 1/23/25.
//

import Foundation
import SwiftUI
import PencilKit

struct BrushTexture: Identifiable {
    let id: UUID
    var name: String
    var pattern: UIImage
    var scale: CGFloat
    var rotation: CGFloat
    var strength: CGFloat
    
    static let defaultTextures: [BrushTexture] = [
        BrushTexture(name: "Canvas", pattern: UIImage(named: "texture-canvas")!, scale: 1.0),
        BrushTexture(name: "Paper", pattern: UIImage(named: "texture-paper")!, scale: 1.0),
        BrushTexture(name: "Rough", pattern: UIImage(named: "texture-rough")!, scale: 1.0),
        BrushTexture(name: "Grain", pattern: UIImage(named: "texture-grain")!, scale: 1.0)
    ]
    
    init(
        id: UUID = UUID(),
        name: String,
        pattern: UIImage,
        scale: CGFloat = 1.0,
        rotation: CGFloat = 0.0,
        strength: CGFloat = 1.0
    ) {
        self.id = id
        self.name = name
        self.pattern = pattern
        self.scale = scale
        self.rotation = rotation
        self.strength = strength
    }
}

// Move the texture property to BrushStyle.Properties
extension BrushStyle.Properties {
    var texture: BrushTexture? {
        switch self.blendMode {
        case .normal:
            return nil
        case .multiply:
            return BrushTexture.defaultTextures[0]
        case .screen:
            return BrushTexture.defaultTextures[1]
        case .overlay:
            return BrushTexture.defaultTextures[2]
        case .hardLight:
            return BrushTexture.defaultTextures[3]
        default:
            return nil
        }
    }
}
