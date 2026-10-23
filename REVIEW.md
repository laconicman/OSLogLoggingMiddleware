# Review Guidelines

Review-specific guidance. `CLAUDE.md` carries the standing rules and is ingested
alongside this file — nothing here restates it. These are the diff-level cues and the
noise filters.

## Critical Areas

- Flag any transport product appearing in `Package.swift` (`OpenAPIURLSession`,
  `AsyncHTTPClientTransport`, a Hummingbird transport…). The module is transport-free
  by design; the 1.0–1.1 manifest carried `swift-openapi-urlsession` and hid an
  undeclared `import OpenAPIRuntime` behind it.
- Flag any removal of the `OpenAPIRuntime` product dependency, or any new `import` in
  `Sources/` without a matching declared target dependency.
- Flag a default moving off `bodyLoggingConfiguration: .never`, `publicBodies: false`,
  or `level: .debug` in
  `Sources/OSLogLoggingMiddleware/OSLogLoggingMiddleware.swift` — that is a major
  version (see `Sources/OSLogLoggingMiddleware/OSLogLoggingMiddleware.docc/Design.md`),
  never a silent diff.
- Flag `privacy: .public` on a body interpolation outside the `publicBodies` branch —
  bodies carry client names, phones, credentials.
- Flag any removal or weakening of the `#if canImport(Darwin)` guard.
- Flag any `@available` annotation in `Sources/` — the floor is `os.Logger`'s
  availability; raising it needs a Design entry.
- Flag a logged header value — request/response headers are not part of the log line
  and may carry credentials.

## Conventions

- Swift Testing only in `Tests/` — reject new `XCTestCase`/`XCTAssert`.
- A new `// TODO` in `Sources/` must carry a `TD-n` register number.
- A status flip of a `TD-n` entry in
  `Sources/OSLogLoggingMiddleware/OSLogLoggingMiddleware.docc/TechDebt.md` must name
  what discharged it.

## Ignore

- Badge churn in `readme.md`.
- `Package.resolved` — git-ignored; flag its *appearance* in a diff.
