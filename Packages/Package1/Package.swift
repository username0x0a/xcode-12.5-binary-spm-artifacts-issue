// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Package1",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "Package1", type: .dynamic, targets: ["Package1"])
    ],
    targets: [
        .target(name: "Package1")
    ]
)
