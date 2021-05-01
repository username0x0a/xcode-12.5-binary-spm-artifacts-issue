// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NicePackage2",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "NicePackage2", type: .dynamic, targets: ["NicePackage2"])
    ],
    targets: [
        .target(name: "NicePackage2")
    ]
)
