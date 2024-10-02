// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Linkly",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Linkly",
            targets: ["Linkly"]),
    ],
    dependencies: [
        .package(url: "https://github.com/NirmitDagly/Network", from: "1.0.0"),
        .package(url: "https://github.com/NirmitDagly/Logger", from: "1.0.0"),
        .package(url: "https://github.com/NirmitDagly/DesignSystem", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Linkly",
            dependencies: [
                .product(name: "Network", package: "Network"),
                .product(name:"Logger", package: "Logger"),
                .product(name:"DesignSystem", package: "DesignSystem")
            ]),
        .testTarget(
            name: "LinklyTests",
            dependencies: ["Linkly"]),
    ]
)
