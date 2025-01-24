//
//  DrawCraftApp.swift
//  DrawCraft
//
//  Created by FayTek on 1/21/25.
//

import SwiftUI

@main
struct DrawCraftApp: App {
    @StateObject private var sceneManager = SceneManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(DrawingViewModel())
                .environmentObject(CanvasState())
                .environmentObject(sceneManager)
                .frame(minWidth: 800, minHeight: 600)
                #if os(iOS)
                .onReceive(NotificationCenter.default.publisher(for: UIScene.didActivateNotification)) { _ in
                    sceneManager.updateActiveScenes()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIScene.didDisconnectNotification)) { _ in
                    sceneManager.updateActiveScenes()
                }
                #endif
        }
        #if os(macOS)
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Drawing") {
                    NotificationCenter.default.post(
                        name: Notification.Name("NewDrawing"),
                        object: nil
                    )
                }
                .keyboardShortcut("n")
            }
            
            CommandGroup(replacing: .saveItem) {
                Button("Save Drawing") {
                    NotificationCenter.default.post(
                        name: Notification.Name("SaveDrawing"),
                        object: nil
                    )
                }
                .keyboardShortcut("s")
            }
        }
        #endif
    }
}

#if os(iOS)
class SceneManager: ObservableObject {
    @Published var isInSplitView = false
    @Published var isInSlideOver = false
    @Published var isPresentedAsPopover = false
    
    @MainActor func updateActiveScenes() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        if let userActivity = windowScene.userActivity {
            isInSplitView = userActivity.activityType == "com.apple.UIKit.activity.SplitView"
            isInSlideOver = userActivity.activityType == "com.apple.UIKit.activity.SlideOver"
        }
        
        if let window = windowScene.windows.first {
            isPresentedAsPopover = window.traitCollection.horizontalSizeClass == .compact
        }
    }
}
#endif
