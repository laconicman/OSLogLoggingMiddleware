# OSLogLoggingMiddleware

[![Swift Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Flaconicman%2FOSLogLoggingMiddleware%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/laconicman/OSLogLoggingMiddleware)
[![Platform Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Flaconicman%2FOSLogLoggingMiddleware%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/laconicman/OSLogLoggingMiddleware)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/laconicman/OSLogLoggingMiddleware)

A logging middleware package for [Swift OpenAPI Generator/Runtime](https://github.com/apple/swift-openapi-generator) that provides detailed request and response logging capabilities. Uses system OSLog.
The library is nothing special, just simple reusable package, that you can easily add to a project and remove from it once no longer needed. Or just turn logging off.

## Features

- 📝 Comprehensive request and response logging
- ⚡️ Pretty printed
- 🔧 Configurable logging levels and formats
- 🎯 Non-intrusive middleware design

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/laconicman/OSLogLoggingMiddleware.git", from: "1.1.1")
]
```

Then add the dependency to your target:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "OSLogLoggingMiddleware", package: "OSLogLoggingMiddleware")
        ]
    )
]
```

## Requirements

Apple platforms only (macOS 11+, iOS 14+, tvOS 14+, watchOS 7+, visionOS 1+) — the
package is OSLog-backed, and compiles to an empty module elsewhere. It depends on
`OpenAPIRuntime` and `HTTPTypes` only: **bring your own transport** (URLSession,
AsyncHTTPClient, Hummingbird…), which also makes it usable server-side.

## Usage

### Basic Setup

```swift
import OSLogLoggingMiddleware
import OpenAPIURLSession

guard let serverURL = URL(string: "https://api.example.com") else {
    fatalError("Configure a valid server URL")
}
let client = Client(
    serverURL: serverURL,
    transport: URLSessionTransport(),
    middlewares: [OSLogLoggingMiddleware()]
)
```

The design decisions behind this package — transport-free dependency set, privacy
defaults, platform floor — are documented and authoritative in the rendered
[Design](https://swiftpackageindex.com/laconicman/OSLogLoggingMiddleware/documentation/oslogloggingmiddleware/design)
article (`Sources/OSLogLoggingMiddleware/OSLogLoggingMiddleware.docc/Design.md`).

## Contributing

Contributions are welcome!

## This is helper package for the following 

- [swift-openapi-generator](https://github.com/apple/swift-openapi-generator) - The main Swift OpenAPI Generator project
- [swift-openapi-runtime](https://github.com/apple/swift-openapi-runtime) - Runtime library for Swift OpenAPI Generator

## License

This project is licensed under the Apache License 2.0.
