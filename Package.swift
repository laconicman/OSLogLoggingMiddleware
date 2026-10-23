// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "logging-middleware-oslog",
    platforms: [.macOS(.v11), .iOS(.v14), .tvOS(.v14), .watchOS(.v7), .visionOS(.v1)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "OSLogLoggingMiddleware",
            targets: ["OSLogLoggingMiddleware"]),
    ],
    dependencies: [
        // The middleware protocols and HTTPBody — the only OpenAPI module this package imports.
        // Transports (URLSession, AsyncHTTPClient, Hummingbird…) are the consumer's choice.
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-http-types", from: "1.0.2"),
        // Command plugin for `swift package generate-documentation`; deliberately not in any
        // target's `plugins:` (same shape as the Salon1c package).
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.4.3"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "OSLogLoggingMiddleware",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "HTTPTypes", package: "swift-http-types")
            ]),
        .testTarget(
            name: "OSLogLoggingMiddlewareTests",
            dependencies: [
                "OSLogLoggingMiddleware",
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "HTTPTypes", package: "swift-http-types"),
            ]
        ),
    ]
)
