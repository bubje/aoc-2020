// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift2b",
    products: [
        .executable(name: "swift2b", targets: ["swift2b"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1")
    ],
    targets: [
        .target(name: "swift2b", dependencies: ["ArgumentParser"]),
        .testTarget(name: "swift2bTests", dependencies: ["swift2b"]),
    ]
)
