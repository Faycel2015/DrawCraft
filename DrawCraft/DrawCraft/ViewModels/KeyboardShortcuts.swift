//
//  KeyboardShortcuts.swift
//  DrawCraft
//
//  Created by FayTek on 1/21/25.
//

import Foundation
import SwiftUI

struct KeyboardShortcuts {
    static let shortcuts: [KeyboardShortcut] = [
        // File operations
        .init(name: "New Drawing", key: "n", modifiers: [.command]),
        .init(name: "Save", key: "s", modifiers: [.command]),
        .init(name: "Export", key: "e", modifiers: [.command]),
        
        // Edit operations
        .init(name: "Undo", key: "z", modifiers: [.command]),
        .init(name: "Redo", key: "z", modifiers: [.command, .shift]),
        .init(name: "Cut", key: "x", modifiers: [.command]),
        .init(name: "Copy", key: "c", modifiers: [.command]),
        .init(name: "Paste", key: "v", modifiers: [.command]),
        .init(name: "Select All", key: "a", modifiers: [.command]),
        
        // Tools
        .init(name: "Pen Tool", key: "p", modifiers: [.command]),
        .init(name: "Eraser", key: "e", modifiers: [.command]),
        .init(name: "Lasso", key: "l", modifiers: [.command]),
        .init(name: "Ruler", key: "r", modifiers: [.command]),
        
        // View
        .init(name: "Toggle Inspector", key: "i", modifiers: [.command]),
        .init(name: "Toggle Grid", key: "g", modifiers: [.command]),
        .init(name: "Zoom In", key: "+", modifiers: [.command]),
        .init(name: "Zoom Out", key: "-", modifiers: [.command]),
        .init(name: "Actual Size", key: "0", modifiers: [.command]),
        
        // iPad specific
        #if os(iOS)
        .init(name: "Show/Hide Toolbar", key: "t", modifiers: [.command]),
        .init(name: "Quick Note", key: "q", modifiers: [.command]),
        #endif
        
        // macOS specific
        #if os(macOS)
        .init(name: "Preferences", key: ",", modifiers: [.command]),
        .init(name: "Hide DrawCraft", key: "h", modifiers: [.command]),
        .init(name: "Quit DrawCraft", key: "q", modifiers: [.command])
        #endif
    ]
}

struct KeyboardShortcut: Identifiable {
    let id = UUID()
    let name: String
    let key: String
    let modifiers: EventModifiers
}
