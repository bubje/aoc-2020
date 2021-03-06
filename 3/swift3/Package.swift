// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift3",
    products: [
        .executable(name: "swift3", targets: ["swift3"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1")
    ],
    targets: [
        .target(name: "swift3", dependencies: ["ArgumentParser"]),
        .testTarget(name: "swift3Tests", dependencies: ["swift3"]),
    ]
)
