// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "SharedUI",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "SharedUI",
            targets: ["SharedUI"]
        )
    ],
    targets: [
        .target(
            name: "SharedUI"
        ),
        .testTarget(
            name: "SharedUITests",
            dependencies: ["SharedUI"]
        )
    ]
)
