# Tech Debt

The numbered register. Each entry names its Cost (what it costs today) and Discharge
(what makes it go away). Code references items as `// TODO(TD-n)`.

## TD-1 — The default `Logger` lives in Apple's namespace

`OSLogLoggingMiddleware.defaultLogger` uses `subsystem: "com.apple.swift-openapi"` /
`category: "logging-middleware"` — the values from Apple's example this package descends
from.

**Cost:** every consumer's log lines share Apple's subsystem, so `log stream` /
`log show` predicates cannot separate one app's lines from another's (or from anyone
else using the same example values). Consumers can pass their own `Logger`, but the
default is what most will keep.

**Discharge:** default the subsystem to the consumer's bundle identifier. That changes
what existing `log` filters match — a behaviour change for every current consumer — so
it waits for 2.0.

## TD-2 — Nothing asserts what reaches OSLog

The tests cover the policy classification and that bodies pass through `intercept`
intact. They do not observe the emitted log line — its format, level, or the `privacy:`
annotations on the body interpolation.

**Cost:** a regression that logs a body `.public` outside the `publicBodies` branch, or
mangles the line format, would ship unnoticed.

**Discharge:** a sink seam behind `Logger` (a 2.0 design item — `Logger` has no
injection point today), or a test that reads `OSLogStore` if that API proves stable
enough to test against.

## TD-3 — No in-repo gate against an undeclared import

The 1.1.0 defect — `import OpenAPIRuntime` with only `OpenAPIURLSession` declared —
passes `swift build`, `swift test` and
`swift build --explicit-target-dependency-import-check error` (the check accepts
transitively available modules). Only a consumer linking the product as a dynamic
framework fails.

**Cost:** the same manifest mistake can return unnoticed; CI here is green either way.

**Discharge:** a CI step that builds a fixture consumer as a dynamic package framework
(an `xcodebuild` of a two-target sample), or a SwiftPM/compiler check that covers
transitive imports once one exists. Until then `Salon1cApps` CI is the gate, one
repository removed.

## See Also

- <doc:Design>
- <doc:Roadmap>
