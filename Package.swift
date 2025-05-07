// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AsyncResizableImage",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "AsyncResizableImage",
            targets: ["AsyncResizableImage"]
        ),
    ],
    targets: [
        .target(
            name: "AsyncResizableImage",
            dependencies: []
        ),
        .testTarget(
            name: "AsyncResizableImageTests",
            dependencies: ["AsyncResizableImage"]
        ),
    ]
)
