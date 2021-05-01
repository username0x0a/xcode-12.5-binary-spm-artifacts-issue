// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SuperPackage3",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "SuperPackage3", type: .dynamic, targets: ["SuperPackage3"])
    ],
    dependencies: [
        .package(name: "Package1", path: "../Package1")
    ],
    targets: [
        .target(name: "SuperPackage3", dependencies: ["Package1"])
    ]
)
