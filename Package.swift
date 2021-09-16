// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "tuist-up",
    dependencies: [
        .package(url: "https://github.com/apple/swift-tools-support-core.git", .upToNextMinor(from: "0.2.0")),
        .package(url: "https://github.com/mtynior/ColorizeSwift.git", from: "1.5.0")
    ],
    targets: [
        .target(
            name: "tuist-up",
            dependencies: [
                .product(name: "ColorizeSwift", package: "ColorizeSwift"),
                .product(name: "SwiftToolsSupport-auto", package: "swift-tools-support-core")
            ]),
        .testTarget(
            name: "tuist-upTests",
            dependencies: ["tuist-up"]),
    ]
)
