//
//  ShareSheet.swift
//  DrawCraft
//
//  Created by FayTek on 1/21/25.
//

import Foundation
import SwiftUI

#if os(iOS)
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
#else
struct ShareSheet: View {
    let items: [Any]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("Share")
                .font(.title)
                .padding()
            
            HStack(spacing: 20) {
                if let image = items.first as? NSImage {
                    Button("Save to Photos") {
                        NSWorkspace.shared.open(URL(fileURLWithPath: "/System/Applications/Photos.app"))
                        // Implement save to Photos
                        dismiss()
                    }
                    
                    Button("Copy to Clipboard") {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.writeObjects([image])
                        dismiss()
                    }
                }
            }
            .padding()
            
            Button("Cancel") {
                dismiss()
            }
            .padding()
        }
        .frame(width: 300, height: 200)
    }
}
#endif
