// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftConcurrency",
    platforms: [.iOS(.v14), .macOS(.v13)],
    targets: [
        .executableTarget(
            name: "SwiftConcurrency"
        )
    ]
)
