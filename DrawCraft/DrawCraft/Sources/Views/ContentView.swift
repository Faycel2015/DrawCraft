//
//  ContentView.swift
//  DrawCraft
//
//  Created by FayTek on 1/21/25.
//

import SwiftUI
import PencilKit

struct ContentView: View {
    @StateObject private var viewModel = DrawingViewModel()
    @EnvironmentObject private var canvasState: CanvasState
    #if os(iOS)
    @EnvironmentObject private var sceneManager: SceneManager
    #endif
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    var body: some View {
        NavigationStack {
            mainContent
                .navigationTitle("DrawCraft")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    toolbarContent
                }
            #if os(iOS)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            Menu {
                                Button(action: openInSplitView) {
                                    Label("Open in Split View", systemImage: "square.split.2x1")
                                }
                                Button(action: openInSlideOver) {
                                    Label("Open in Slide Over", systemImage: "square.split.1x2")
                                }
                            } label: {
                                Image(systemName: "rectangle.split.3x1")
                            }
                        }
                    }
                }
            #endif
        }
        .sheet(isPresented: $viewModel.showNewProjectSheet) {
            NewProjectView()
        }
        .sheet(isPresented: $viewModel.showSettings) {
            SettingsView()
        }
        #if os(iOS)
        .userActivity("com.drawcraft.drawing") { activity in
            activity.isEligibleForHandoff = true
            activity.title = "Drawing"
            if let drawing = canvasState.currentDrawing {
                activity.addUserInfoEntries(from: ["drawingId": drawing.id.uuidString])
            }
        }
        #endif
    }

    private var mainContent: some View {
        HStack(spacing: 0) {
            #if os(iOS)
            if horizontalSizeClass == .regular && !sceneManager.isInSlideOver {
                toolPalette
            }
            #else
            if horizontalSizeClass == .regular {
                toolPalette
            }
            #endif

            ZStack {
                CanvasView(canvasView: canvasState.canvasView)
                    .ignoresSafeArea()

                #if os(iOS)
                if horizontalSizeClass == .compact || sceneManager.isInSlideOver {
                    VStack {
                        Spacer()
                        toolPalette
                            .padding(.bottom)
                    }
                }
                #else
                if horizontalSizeClass == .compact {
                    VStack {
                        Spacer()
                        toolPalette
                            .padding(.bottom)
                    }
                }
                #endif

                if viewModel.isInspectorVisible {
                    GeometryReader { geometry in
                        HStack {
                            Spacer()
                            InspectorPanelView()
                                .frame(width: min(geometry.size.width * 0.3, 320))
                                .transition(.move(edge: .trailing))
                        }
                    }
                }
            }
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            Button(action: { viewModel.showNewProjectSheet = true }) {
                Image(systemName: "plus")
            }
            .help("New Project")

            Button(action: { canvasState.showShareSheet = true }) {
                Image(systemName: "square.and.arrow.up")
            }
            .help("Share")
        }

        ToolbarItemGroup(placement: .topBarTrailing) {
            Button(action: { viewModel.toggleInspector() }) {
                Image(systemName: "slider.horizontal.3")
            }
            .help("Show Inspector")

            Menu {
                Button("Export as PDF") {
                    if let pdfData = viewModel.exportAsPDF(canvasView: canvasState.canvasView) {
                        saveOrSharePDF(data: pdfData)
                    } else {
                        print("Failed to export as PDF")
                    }
                }
                Button("Export as Image") {
                    if let image = viewModel.exportAsImage(canvasView: canvasState.canvasView) {
                        saveOrShareImage(image: image)
                    } else {
                        print("Failed to export as image")
                    }
                }
                Divider()
                Button("Settings") { viewModel.showSettings = true }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
            .help("More Options")
        }
    }

    private var toolPalette: some View {
        VStack {
            ForEach(viewModel.availableTools) { tool in
                ToolButton(tool: tool)
            }

            Divider()
                .padding(.vertical)

            ColorPaletteView()

            Spacer()

            Button(action: { canvasState.clearCanvas() }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .help("Clear Canvas")
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(radius: 10)
        )
        .padding()
    }

    #if os(iOS)
    private func openInSplitView() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let userActivity = windowScene.userActivity {
            userActivity.addUserInfoEntries(from: ["requestedMode": "splitView"])
            UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil)
        }
    }

    private func openInSlideOver() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let userActivity = windowScene.userActivity {
            userActivity.addUserInfoEntries(from: ["requestedMode": "slideOver"])
            UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil)
        }
    }
    #endif
}

@MainActor private func saveOrSharePDF(data: Data) {
    #if os(iOS)
    let temporaryURL = FileManager.default.temporaryDirectory.appendingPathComponent("drawing.pdf")
    do {
        try data.write(to: temporaryURL)
        
        // Access the active window scene
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            let activityViewController = UIActivityViewController(activityItems: [temporaryURL], applicationActivities: nil)
            rootViewController.present(activityViewController, animated: true, completion: nil)
        } else {
            print("Failed to access window scene or root view controller")
        }
    } catch {
        print("Failed to save PDF: \(error)")
    }
    #elseif os(macOS)
    let savePanel = NSSavePanel()
    savePanel.nameFieldStringValue = "drawing.pdf"
    savePanel.allowedContentTypes = [.pdf]
    if savePanel.runModal() == .OK, let url = savePanel.url {
        do {
            try data.write(to: url)
        } catch {
            print("Failed to save PDF: \(error)")
        }
    }
    #endif
}

@MainActor private func saveOrShareImage(image: PlatformImage) {
    #if os(iOS)
    // Access the active window scene
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let rootViewController = windowScene.windows.first?.rootViewController {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        rootViewController.present(activityViewController, animated: true, completion: nil)
    } else {
        print("Failed to access window scene or root view controller")
    }
    #elseif os(macOS)
    let savePanel = NSSavePanel()
    savePanel.nameFieldStringValue = "drawing.png"
    savePanel.allowedContentTypes = [.png]
    if savePanel.runModal() == .OK, let url = savePanel.url {
        if let imageData = image.pngData() {
            do {
                try imageData.write(to: url)
            } catch {
                print("Failed to save image: \(error)")
            }
        }
    }
    #endif
}

struct NewProjectView: View {
    var body: some View {
        Text("New Project View")
            .padding()
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings View")
            .padding()
    }
}

#Preview {
    ContentView()
}
