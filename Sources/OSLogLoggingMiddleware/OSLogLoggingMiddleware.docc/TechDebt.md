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

## See Also

- <doc:Design>
- <doc:Roadmap>
