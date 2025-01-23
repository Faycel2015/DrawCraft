//
//  Package.swift
//  DrawCraft
//
//  Created by FayTek on 1/22/25.
//

// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "DrawCraft",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(name: "DrawCraft", targets: ["DrawCraft"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.0"),
        .package(url: "https://github.com/piknotech/SFSafeSymbols.git", from: "4.1.1")
    ],
    targets: [
        .target(
            name: "DrawCraft",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
                "SFSafeSymbols"
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "DrawCraftTests",
            dependencies: ["DrawCraft"],
            path: "Tests"
        )
    ]
)
