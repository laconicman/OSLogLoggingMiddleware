# ``OSLogLoggingMiddleware``

A request/response logging middleware for
[Swift OpenAPI Generator](https://github.com/apple/swift-openapi-generator) clients and
servers, backed by OSLog.

## Overview

Attach it to any OpenAPI `Client` or `Server` as middleware and it logs each request and
response through `os.Logger` — method, path, status — with bodies off by default.
Privacy is the default posture: `bodyLoggingConfiguration` starts at `.never`, bodies
that do get logged interpolate at `.auto` privacy (shown as `<private>` in
`log collect`) unless `publicBodies` is set, and lines emit at `.debug`, which is not
persisted on device.

The package is deliberately transport-free: it depends on `OpenAPIRuntime` and
`HTTPTypes` only, so server-side consumers are not forced to carry a client transport.

```swift
import OpenAPIURLSession
import OSLogLoggingMiddleware

guard let serverURL = URL(string: "https://api.example.com") else {
    fatalError("Configure a valid server URL")
}
let client = Client(
    serverURL: serverURL,
    transport: URLSessionTransport(),
    middlewares: [OSLogLoggingMiddleware()]
)
```

## Topics

### Project Direction

- <doc:Design>
- <doc:Roadmap>
- <doc:TechDebt>

### Essentials

- ``OSLogLoggingMiddleware/OSLogLoggingMiddleware``
- ``BodyLoggingPolicy``
