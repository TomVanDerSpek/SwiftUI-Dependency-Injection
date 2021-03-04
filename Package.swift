// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIDI",
    platforms: [
        .macOS(.v10_15), .iOS(.v11), .tvOS(.v13)
    ], products: [
        .library(
            name: "SwiftUIDI",
            targets: ["SwiftUIDI"]),
    ],
    targets: [
        .target(
            name: "SwiftUIDI",
            dependencies: []),
        .testTarget(
            name: "SwiftUIDITests",
            dependencies: ["SwiftUIDI"]),
    ]
)
