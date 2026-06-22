---
paths:
  - "**/*.go"
  - "**/go.mod"
  - "**/go.sum"
---
# Go Conventions

## Guiding Principle
- Always follow idiomatic Go: prefer the simplest solution that reads clearly over clever abstraction.
- Apply common Go practices, architecture, and design patterns the community actually uses — not patterns ported from C#/Java/Rust.
- Favor composition over inheritance (Go has no inheritance); embed types and small interfaces instead.
- "A little copying is better than a little dependency" — don't over-abstract to avoid minor duplication.
- "Clear is better than clever"; "Make the zero value useful"; "The bigger the interface, the weaker the abstraction" (Go proverbs).
- Standard project layout when structure is needed: cmd/ for binaries, internal/ for private packages, pkg/ only when sharing externally; avoid premature package splitting.
- Concurrency: "Share memory by communicating" — prefer channels/goroutines with clear ownership; use sync primitives for simple shared state; always define how goroutines exit (context cancellation).
- When unsure, defer to Effective Go, the Go Code Review Comments wiki, and the standard library as the reference for idiom.

## Learning Mode (active)
- I am still learning Go. Do NOT write or edit Go code for me.
- Explain the idea, approach, or concept and point me to the relevant API/pattern — then let me write the code myself.
- When I ask "how do I do X", respond with the concept, the idiomatic option(s), and tradeoffs — not a finished implementation.
- Small illustrative snippets to demonstrate a concept are fine; full solutions, file edits, and "here, I did it for you" are not.
- Always explain Go-specific terms the first time they appear (e.g. receiver, zero value, exported identifier, goroutine, channel).
- Remove this section once I ask to lift learning mode.

## Style
- Follow Effective Go and the standard Go style guide
- Use gofmt defaults — never override formatting
- Indentation: tabs (gofmt default)
- Max line length: 100 chars

## Naming
- MixedCaps for exported identifiers, mixedCaps for unexported (capitalization controls visibility — there is no public/private keyword)
- Acronyms stay all-caps: HTTPServer, ID, URL
- Use is prefix on boolean-returning functions
- No get_ prefix on getters — idiomatic Go uses the bare field/name
- Package names: short, lowercase, no underscores or mixedCaps

## Error Handling
- Return errors; wrap with context using fmt.Errorf("context: %w", err)
- Never panic in library code — panic is acceptable only in main() or tests
- Check errors at the call site — do not discard with _ unless intentional and obvious
- Sentinel errors via errors.Is, typed errors via errors.As

## Types & Structure
- Interfaces defined at the point of use (consumer side), kept small (1–2 methods preferred)
- Accept interfaces, return concrete types
- Constructor convention: func New(...) for the primary type of a package
- Value vs pointer receivers: be consistent per type; use pointer receivers when mutating or for large structs
- Group imports: standard library, then external, then internal (separated by blank lines)

## Tooling Baseline
- Run go build ./... first
- Then go vet ./...
- Then go test ./... if tests exist

## Testing
- Table-driven tests with subtests via t.Run
- Test files named _test.go alongside the code
- Test function names: TestXxx describing the scenario
- Prefer the standard testing package; reach for a helper library only if the project already uses one
