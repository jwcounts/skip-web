// swift-tools-version: 5.9
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import PackageDescription

let package = Package(
    name: "skip-web",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v14), .tvOS(.v17), .watchOS(.v10), .macCatalyst(.v17)],
    products: [
        .library(name: "SkipWeb", type: .dynamic, targets: ["SkipWeb"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "0.8.24"),
        .package(url: "https://source.skip.tools/skip-ui.git", from: "0.5.19")
    ],
    targets: [
        .target(name: "SkipWeb", dependencies: [.product(name: "SkipUI", package: "skip-ui")], /*resources: [.process("Resources")],*/ plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "SkipWebTests", dependencies: ["SkipWeb", .product(name: "SkipTest", package: "skip")], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)
