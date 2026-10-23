# Roadmap

Planned work, in priority order.

## Now — `1.1.1`

- **Declare the runtime dependency** — `swift-openapi-runtime` replaces the
  `swift-openapi-urlsession` manifest entry, so the target declares what it imports and
  no consumer is forced onto a transport (<doc:Design>).
- Direction docs, Swift Testing suite, CI.

## Next — `1.2.0` (additive)

- **Include `operationID` in the request/response lines.** Both `intercept` overloads
  already receive the parameter and discard it today; adding it to the line is an
  additive change that makes `log stream` output attributable per operation.

## Later — `2.0`

- **TD-1** — default `Logger` subsystem follows the consumer's bundle identifier.
- **TD-2** — a sink seam behind `Logger` so the emitted line is testable.
- **TD-3** — an in-repo dynamic-framework consumer build in CI.

## See Also

- <doc:Design>
- <doc:TechDebt>
