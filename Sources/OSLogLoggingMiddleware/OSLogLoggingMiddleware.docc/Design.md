# Design

Every load-bearing decision in `OSLogLoggingMiddleware`, with the alternative that was
rejected.

The package descends from Apple's
[`logging-middleware-oslog-example`](https://github.com/apple/swift-openapi-generator/tree/main/Examples/logging-middleware-oslog-example)
in swift-openapi-generator; the example's structure (policy enum, `process` splitting a
body into one half to log and one half to hand on, per-line `privacy:` interpolation)
survives intact.

## Middleware only — a transport is the consumer's choice

The module depends on `OpenAPIRuntime` (the `ClientMiddleware`/`ServerMiddleware`
protocols, `HTTPBody`, `ServerRequestMetadata`) and `HTTPTypes` — nothing else. It
conforms to *both* middleware protocols, so the same type serves clients and servers.

**Rejected:** the 1.0–1.1 manifest, which declared `swift-openapi-urlsession` instead of
the runtime. Nothing in the module imports `OpenAPIURLSession`; the runtime only arrived
transitively through the transport. That forced a client transport on every consumer —
including server-side ones — and hid the undeclared `import OpenAPIRuntime`: it links
statically, but fails when Xcode builds the product as a dynamic package framework.
No in-repo build gate catches this class of defect:
`swift build --explicit-target-dependency-import-check error` only flags imports
outside the target's *recursive* dependency closure, so it passed the 1.1.0 manifest
unchanged (verified 2026-10-23, Swift 6.2 toolchain). The regression gate is therefore
a consumer that builds the product as a dynamic package framework — `Salon1cApps` CI,
once its SA-8 workarounds are gone — plus review. Registered as <doc:TechDebt> TD-3.

## Darwin-only, compiling to nothing elsewhere

The whole module sits inside `#if canImport(Darwin)`. On Linux or Windows the target
builds as an empty module rather than failing resolution.

**Rejected:** a swift-log fallback backend. The package's name promises OSLog; a
cross-platform logging middleware with different privacy semantics would be a different
package wearing this one's name.

## Privacy defaults are the product

`bodyLoggingConfiguration: .never` — request and response bodies are classified
`.redacted` and never read for logging. `publicBodies: false` — bodies that *are*
logged interpolate at `.auto`, surfacing as `<private>` in `log collect`. `level:
.debug` — lines are not persisted on device; field capture opts in with a higher level
and an explicit `Logger`.

Bodies on the wire carry client names, phone numbers, credentials — a default that logs
them readable is a default that leaks. **Changing any of these defaults is a major
version.**

## Platform floor is `os.Logger`'s availability

macOS 11 / iOS 14 / tvOS 14 / watchOS 7 / visionOS 1 — the availability of `os.Logger`,
the type at the package's core. The floor stays until a consumer needs something newer;
no `@available` annotation may raise it per-API without an entry here.

## Semver is a consumer contract

Consumers pin `from: 1.x`, so the granularity matters:

- Dependency/manifest-only change → **patch** (this fix ships as 1.1.1).
- Additive API → **minor**.
- A privacy-default flip → **major**.

## How a body reaches the log

`BodyLoggingPolicy.process` decides on `HTTPBody.length` — `known` vs `unknown`, per the
runtime's `HTTPBody.Length` — *before* consuming anything, so an over-limit body is
reported (`tooManyBytesToLog`) without being read, and an unknown-length body is never
collected. Only a body the policy accepts is collected, and the collected bytes are
re-wrapped into a fresh `HTTPBody` for `next` — the stream is consumed once, never
dropped.

## See Also

- <doc:Roadmap>
- <doc:TechDebt>
