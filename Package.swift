// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CongregationKit",
    platforms: [
        .macOS(.v13),
        .iOS(.v15),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CongregationKit",
            targets: ["CongregationKit"]
        ),
        .library(
            name: "SalesforceClient",
            targets: ["SalesforceClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.20.0"),
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.4.5"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CongregationKit",
            dependencies: ["SalesforceClient"],
            path: "Sources/CongregationKit"
        ),
        .target(
            name: "SalesforceClient",
            dependencies: [
                .product(name: "AsyncHTTPClient", package: "async-http-client")
            ],
            path: "Sources/SalesforceClient"
        ),
        .testTarget(
            name: "CongregationKitTests",
            dependencies: [
                "CongregationKit",
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
            ]
        ),
    ]
)
