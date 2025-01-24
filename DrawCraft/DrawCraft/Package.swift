//
//  Package.swift
//  DrawCraft
//
//  Created by FayTek on 1/22/25.
//

// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "DrawCraft",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(name: "DrawCraft", targets: ["DrawCraft"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-collections.git",
            .upToNextMajor(from: "1.0.4")
        ),
        .package(
            url: "https://github.com/piknotech/SFSafeSymbols.git",
            .upToNextMajor(from: "4.2.0")
        )
    ],
    targets: [
        .target(
            name: "DrawCraft",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
                "SFSafeSymbols"
            ],
            path: "Sources",
            exclude: [
                ".git",
                ".build",
                "hooks",
                "info",
                "Package.swift"  // Explicit exclusion
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "DrawCraftTests",
            dependencies: ["DrawCraft"],
            path: "Tests"
        )
    ]
)
