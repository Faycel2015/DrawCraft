//
//  Drawing.swift
//  DrawCraft
//
//  Created by FayTek on 1/21/25.
//

import Foundation
import PencilKit
import SwiftUI

struct Drawing: Identifiable, Codable {
    var id = UUID()
    var name: String
    var createdAt: Date
    var modifiedAt: Date
    var drawingData: Data
    var sceneConfiguration: SceneConfiguration?

    init(id: UUID = UUID(), name: String = "Untitled", drawingData: Data) {
        self.id = id
        self.name = name
        createdAt = Date()
        modifiedAt = Date()
        self.drawingData = drawingData
    }
}

struct DrawingStyle: Equatable {
    var color: Color
    var width: CGFloat
    var opacity: Double

    static let `default` = DrawingStyle(
        color: .black,
        width: 5,
        opacity: 1.0
    )
}

struct SceneConfiguration: Codable {
    var displayMode: DisplayMode
    var position: CGPoint
    var size: CGSize

    enum DisplayMode: String, Codable {
        case fullScreen
        case splitView
        case slideOver
    }
}

#if os(iOS)
    extension Drawing {
        var activityType: String {
            "com.drawcraft.drawing"
        }

        func createUserActivity() -> NSUserActivity {
            let activity = NSUserActivity(activityType: activityType)
            activity.title = name
            activity.addUserInfoEntries(from: ["drawingId": id.uuidString])
            activity.isEligibleForHandoff = true
            return activity
        }
    }
#endif
