# Developer Profile
- Primary stack: ASP.NET Core (C#), Rust
- Secondary: TypeScript/Node.js (tooling scripts)
- OS: Debian, Fedora, Windows | Editor: Visual Studio, VS Code
- Package managers: dotnet CLI, cargo, npm/pnpm

# Code Style Preferences

## C#
- File-scoped namespaces, primary constructors where appropriate
- Prefer pattern matching, nullable reference types enabled
- XML doc comments with <param>, <returns>, <exception> on all public APIs
- Naming: PascalCase (public members), camelCase (private/local)
- Prefer explicit types over var when the type isn't obvious from context
- Max line length: 200 chars
- Indentation: 4 spaces

## Rust
- Follow official Rust style guide and API guidelines
- Use rustfmt defaults — do not override settings
- anyhow::Result and anyhow::Error for error handling
- No comments unless I specify — let the code speak for itself
- Naming: UpperCamelCase (types/traits), snake_case (functions/variables/modules), SCREAMING_SNAKE_CASE (constants)
- Use get_ prefix on getters, is_ prefix on boolean-returning methods
- Derive Debug on public types
- Prefer &str over String in function parameters when ownership isn't needed
- Max line length: 100 chars (rustfmt default)
- Indentation: 4 spaces
- Trailing commas on multi-line lists
- Run cargo clippy as baseline

## TypeScript
- camelCase (variables/functions), PascalCase (types/interfaces)
- Indentation: 2 spaces
- Max line length: 120 chars

# Code Change Protocol
When modifying code, always follow this sequence:
1. READ the file(s) being changed first — understand existing patterns
2. CHECK for related tests, usages, and dependencies before editing
3. MAKE the change
4. VERIFY:
   - C#: dotnet build, then dotnet test if tests exist
   - Rust: cargo check, cargo clippy, then cargo test if tests exist
   - TS: npm run build / tsc --noEmit, then npm test if tests exist
5. If the change affects a public API, check all callers
6. When the change involves protocol implementations, complex data structures, algorithms, design patterns, or performance-sensitive code — dispatch @web-explorer to verify the approach against official docs and established best practices before finalizing
7. COMMIT workflow:
   - After verified changes, stage the relevant files with git add
   - Read the last 10 commit messages with git log --oneline -10 to match the existing commit style
   - Draft a commit message following the same pattern/convention found in the history
   - Present the staged diff summary and proposed commit message to me for review
   - Wait for my approval before running git commit
   - Never git push without my explicit instruction

# Communication
- Be concise. Skip explanations I didn't ask for.
- When unsure between two approaches, present both briefly with tradeoffs.
- Don't repeat file contents back to me unless I ask.
