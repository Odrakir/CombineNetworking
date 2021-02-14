// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CombineNetworking",
    platforms: [.macOS(.v10_15), .iOS(.v13)],
    products: [
        .library(
            name: "CombineNetworking",
            targets: ["CombineNetworking"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "CombineNetworking",
            dependencies: []),
        .testTarget(
            name: "CombineNetworkingTests",
            dependencies: ["CombineNetworking"]),
    ]
)
