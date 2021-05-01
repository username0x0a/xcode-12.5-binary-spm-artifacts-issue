// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import class Foundation.ProcessInfo

//////////////////////////////////
// MARK: - Package definition
//////////////////////////////////

let package = Package(
    name: "ExternalDependencies",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "ExternalDependencies", targets: ["ExternalDependencies"])
    ]
)

struct ExternalDependency {
    let name: String
    let version: String
    let url: String
    let products: [ExternalProduct]
}

struct ExternalProduct {
    let name: String
    let spmName: String?
    let shaSum: String
    init (_ name: String, _ spmName: String?, _ shaSum: String) {
        self.name = name
        self.spmName = spmName
        self.shaSum = shaSum
    }
}

//////////////////////////////////
// MARK: - Dependencies declaration
//////////////////////////////////

// swiftlint:disable line_length

let dependencies = [

//    ExternalDependency(name: "Facebook", version: "9.2.0", url: "https://github.com/facebook/facebook-ios-sdk", products: [
//        ExternalProduct("FBSDKCoreKit", "FacebookCore", "5daa1b708556c40ab82d65e787ec3b16e4927d617c8e27136e08c5aa0636707b"),
//    ]),

    ExternalDependency(name: "Firebase", version: "7.11.0", url: "https://github.com/firebase/firebase-ios-sdk", products: [
//        ExternalProduct("FirebaseCrashlytics", "FirebaseCrashlytics", "6afbc53ac474165125f1f24280d9c7905ddc7bb26b282d9af2ad3f7d9b347175"),
//        ExternalProduct("FirebaseRemoteConfig", "FirebaseRemoteConfig", "6e41bd89a7eb112230ef6556ce1a41c34657ff9c9353f893e48101c7b3323da2"),
//        ExternalProduct("FirebaseDynamicLinks", "FirebaseDynamicLinks", "f0e33f2a50e7674f9d35b98eb0929be5a2cbae9fde5a08c5a3b0981907ce0521"),
//        ExternalProduct("FirebaseAnalytics", "FirebaseAnalytics", "66cc01edd9564fc25229ca742da67228bcc0fdb70faec156a4de9997e9607692"),
        ExternalProduct("FirebaseABTesting", nil, "7bf790f64cadf3b0983cd653bd139a146dab6faebf9c8fed8d36afa618701f9f"),
//        ExternalProduct("FirebaseCore", nil, "dc45cc4ce7a9b2b7e975285619cd00eff1a5a4881937a9108b51559ae3cbe345"),
//        ExternalProduct("FirebaseCoreDiagnostics", nil, "47ff7267e1bc3dc6600a4244ae6c19cd57415ae3727180343843610dae99a7d3"),
//        ExternalProduct("FirebaseInstallations", nil, "432a4d60056d6387ee81d1158279b6b4fb78144d4f19c796203a738c19c91cf8"),
//        ExternalProduct("GoogleAppMeasurement", nil, "f9bcc850b817dd2c17ecf8cb7cadfe78844d95d1108c86acd44153a42cd6b73d"),
//        ExternalProduct("GoogleDataTransport", nil, "4cf9bc861f0ad39336602811595981a6e775cbe2eeec19a3a58232c1f9e4e75e"),
//        ExternalProduct("GoogleUtilities", nil, "0ee1e90a1b72f7f4cfd06b31a8df6062ba1ec35eab99ba4b53b4cff6f4a7af2d"),
//        ExternalProduct("PromisesObjC", nil, "01b1d8f93b2b9d608615e4c5506fac6cd19c77e6cc250f9d43999d226e479b9c"),
//        ExternalProduct("nanopb", nil, "6da3caa210e4ad75ef2af3ceb58e2d6504ef804d9ad6d37cb401e05d587913c3"),
    ]),

]

// swiftlint:enable line_length

//////////////////////////////////
// MARK: - Build flow toggling flag
//////////////////////////////////

let shouldBuildFromSource = false

//////////////////////////////////
// MARK: - Building from source
//////////////////////////////////

if shouldBuildFromSource || ProcessInfo.processInfo.environment["BUILD_FROM_SOURCE"] != nil {

    package.dependencies = dependencies.map {
        .package(name: $0.name, url: $0.url, from: Version(stringLiteral: $0.version))
    }

    package.targets += [
        .target(
            name: "ExternalDependencies",
            dependencies: dependencies.map { dependency in
                dependency.products.compactMap(\.spmName).map {
                    .product(name: $0, package: dependency.name)
                }
            }.flatMap { $0 }
        )
    ]

} else {

    //////////////////////////////////
    // MARK: - Using precompiled binaries
    //////////////////////////////////

    let depsPath = "https://github.com/username0x0a/xcode-12.5-binary-spm-artifacts-issue/releases/download/v1"

    package.products = [
        .library(
            name: "ExternalDependencies",
            targets: dependencies.map { $0.products.map(\.name) }.flatMap { $0 }
        )
    ]

    package.targets = dependencies.map { dependency in
        dependency.products.map {
            let basename = $0.name + ".xcframework.zip"
            let urlString = [
                depsPath,
                basename,
            ].joined(separator: "/")
            return .binaryTarget(name: $0.name, url: urlString, checksum: $0.shaSum)
        }
    }.flatMap { $0 }

}
