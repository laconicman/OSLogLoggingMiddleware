# OSLogLoggingMiddleware

A request/response logging middleware for Swift OpenAPI Generator clients and servers,
backed by OSLog — a sibling of `Salon1cAPI`'s dependency set and a descendant of Apple's
[`logging-middleware-oslog-example`](https://github.com/apple/swift-openapi-generator/tree/main/Examples/logging-middleware-oslog-example).

## Direction docs are authoritative

Read these before proposing architecture, and update them when a decision changes. When
they and this file disagree, believe them.

| Article | Answers |
|---|---|
| [Design](Sources/OSLogLoggingMiddleware/OSLogLoggingMiddleware.docc/Design.md) | Every load-bearing decision, with the alternative that was rejected |
| [Tech Debt](Sources/OSLogLoggingMiddleware/OSLogLoggingMiddleware.docc/TechDebt.md) | Numbered register (`TD-n`), each with Cost and Discharge |
| [Roadmap](Sources/OSLogLoggingMiddleware/OSLogLoggingMiddleware.docc/Roadmap.md) | Planned work, priority order |

Render: `swift package generate-documentation --target OSLogLoggingMiddleware`

## Rules specific to this repository

1. **Dependencies are `OpenAPIRuntime` + `HTTPTypes` — never a transport.** The module
   conforms to both `ClientMiddleware` and `ServerMiddleware`; a transport dependency
   would force it on server-side consumers. The 1.0–1.1 manifest hid an undeclared
   `import OpenAPIRuntime` behind `swift-openapi-urlsession`'s transitive copy — it
   linked statically and failed under Xcode's dynamic package-framework build.
   There is no in-repo compiler gate: SwiftPM's
   `--explicit-target-dependency-import-check` accepts any module in the target's
   *recursive* dependency closure, so it passed the 1.1.0 manifest unchanged
   (verified 2026-10-23). The gate is a consumer that builds the product as a
   dynamic package framework — `Salon1cApps` CI does — plus review
   (`REVIEW.md`); see TD-3.
2. **Platform floor is macOS 11 / iOS 14 / tvOS 14 / watchOS 7 / visionOS 1** —
   `os.Logger`'s availability (D4). No `@available` annotation may raise it without a
   Design entry.
3. **The `#if canImport(Darwin)` guard stays.** The module compiles to nothing off
   Darwin rather than failing — no swift-log fallback (D2).
4. **Privacy defaults are load-bearing** (D3): `bodyLoggingConfiguration: .never`,
   `publicBodies: false`, `level: .debug`. Flipping one is a major version, not a fix.
5. **Swift Testing, not XCTest.** `#expect` by default, `#require` when later lines
   depend on the value.
6. **Everything lands via PR.** `main` is protected; Devin Review runs on push and
   `REVIEW.md` steers it. No AI attribution in commit messages or PR descriptions.
   Before merging, `contrib in laconicman/OSLogLoggingMiddleware --pr N` must read
   owed 0 / to re-read 0.
7. **Semver per D5:** dependency/manifest-only change → patch; additive API → minor;
   a privacy-default flip → major. Reference a debt item from code as `// TODO(TD-n)`.

## Author's standing preferences

Clarity over brevity. Prefer a vetted SPM over hand-rolling when the dependency is
smaller than the problem — and say so explicitly when it is *not*. Cite sources in
prose and in code comments. DRY, separation of concerns, low coupling / high cohesion
are the three that get checked first.

## Related skills

`apple-swift-openapi-generator` · `swift-package-manager` · `swift-testing-expert` ·
`software-development-principles` · `repo-init` · `atomic-commits` · `git-branching`
