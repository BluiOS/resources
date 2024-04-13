// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WrappingCLibs",
    dependencies: [],
    targets: [
        .executableTarget(
            name: "WrappingCLibsExec",
            dependencies: [
                "Ccmark",
            ]
        ),
        .systemLibrary(
            name: "Ccmark",
            pkgConfig: "libcmark",
            providers: [
                .brew(["cmark"]),
                .apt(["cmark"])
            ]
        )
    ]
)
