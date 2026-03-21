// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "LayoutExamplesFeature",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "LayoutExamplesFeature",
            targets: ["LayoutExamplesFeature"]
        )
    ],
    dependencies: [
        .package(path: "../SharedUI")
    ],
    targets: [
        .target(
            name: "LayoutExamplesFeature",
            dependencies: [
                "SharedUI"
            ]
        ),
        .testTarget(
            name: "LayoutExamplesFeatureTests",
            dependencies: ["LayoutExamplesFeature"]
        )
    ]
)
