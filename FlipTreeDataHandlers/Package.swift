// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FlipTreeDataHandlers",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FlipTreeDataHandlers",
            targets: ["FlipTreeDataHandlers"]),
    ],
    dependencies: [
        Package.Dependency.package(name: "FlipTreeFoundation", path: "../FlipTreeFoundation"),
        Package.Dependency.package(name: "FlipTreeModels", path: "../FlipTreeModels")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FlipTreeDataHandlers",
            dependencies: ["FlipTreeFoundation", "FlipTreeModels"]
            ),
        .testTarget(
            name: "FlipTreeDataHandlersTests",
            dependencies: ["FlipTreeDataHandlers", "FlipTreeFoundation", "FlipTreeModels"]),
    ]
)
