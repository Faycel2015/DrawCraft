//
//  PlatformTypes.swift
//  DrawCraft
//
//  Created by FayTek on 1/21/25.
//

import Foundation
import SwiftUI

#if os(iOS)
import UIKit
typealias PlatformImage = UIImage
typealias PlatformColor = UIColor
typealias PlatformViewRepresentable = UIViewRepresentable
#elseif os(macOS)
import AppKit
typealias PlatformImage = NSImage
typealias PlatformColor = NSColor
typealias PlatformViewRepresentable = NSViewRepresentable
#endif

// Platform-agnostic color conversion
extension Color {
    var platformColor: PlatformColor {
        #if os(iOS)
        return UIColor(self)
        #else
        return NSColor(self)
        #endif
    }
}

// Platform-agnostic image conversion
extension PlatformImage {
    var swiftUIImage: Image {
        #if os(iOS)
        return Image(uiImage: self)
        #else
        return Image(nsImage: self)
        #endif
    }
}
