# LoggingMiddleware

[![Swift Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Flaconicman%2FOSLogLoggingMiddleware%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/laconicman/OSLogLoggingMiddleware)
[![Platform Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Flaconicman%2FOSLogLoggingMiddleware%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/laconicman/OSLogLoggingMiddleware)

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
    .package(url: "https://github.com/laconicman/OSLogLoggingMiddleware.git", from: "1.0.0")
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

## Usage

### Basic Setup

```swift
import OSLogLoggingMiddleware
import OpenAPIRuntime

let client = Client(
    serverURL: URL(string: "https://api.example.com")!,
    middleware: [
        OSLogLoggingMiddleware()
    ]
)
```

## Contributing

Contributions are welcome!

## This is helper package for the following 

- [swift-openapi-generator](https://github.com/apple/swift-openapi-generator) - The main Swift OpenAPI Generator project
- [swift-openapi-runtime](https://github.com/apple/swift-openapi-runtime) - Runtime library for Swift OpenAPI Generator

## License

This project is licensed under the Apache License 2.0.
