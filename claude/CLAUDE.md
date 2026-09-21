# Session Startup

At the start of every session, run:
```bash
~/.claude/statusline-command.sh
```

# Developer Profile
- Primary stack: ASP.NET Core (C#), Rust, Go
- Secondary: TypeScript/Node.js (tooling scripts)
- OS: Debian, Fedora, Windows, macOS | Editor: Visual Studio, VS Code
- Package managers: dotnet CLI, cargo, go, npm/pnpm

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
- Match existing dependency versions from sibling workspace projects — use the same pinned version, do not independently pick current stable
- Never introduce a new persistence or architecture pattern when one already exists in the codebase — mirror what's there
- Registry credentials live in user-global `~/.cargo/config.toml`, never in the repo; never echo or commit tokens or secrets
- Never `git push` under any circumstances, even on bypass / auto-accept mode. Local commits only — the user controls remote pushes.

## Go
- Follow effective Go and standard Go style guide
- Use `gofmt` defaults — do not override formatting
- Error handling: return errors with `fmt.Errorf("context: %w", err)`; no panic in library code
- Naming: MixedCaps (exported), mixedCaps (unexported), acronyms all-caps (e.g. `HTTPServer`)
- Use `is` prefix on boolean-returning functions, no `get_` prefix on getters (idiomatic Go uses bare name)
- Interfaces defined at point of use (consumer side), kept small (1–2 methods preferred)
- Indentation: tabs (gofmt default)
- Max line length: 100 chars
- Run `go vet ./...` as baseline after `go build ./...`

## TypeScript
- camelCase (variables/functions), PascalCase (types/interfaces)
- Indentation: 2 spaces
- Max line length: 120 chars

# Dependency Policy
- Default to not adding a new external dependency (crate/package/module). Before reaching for one,
  check: does the standard library already cover this? Does something already in the project
  provide it, even indirectly?
- If a dependency still seems necessary, weigh implementing it myself first: for something simple
  and well-understood (a small parser, basic formatting, a short algorithm), write it directly
  rather than pulling in a package. Reach for a dependency when the functionality is genuinely
  complex or easy to get subtly wrong — crypto, TLS, date/timezone handling, protocol/format
  parsing — since a hand-rolled version there is a bigger real risk than a well-vetted dependency.
- Before adding any new dependency, check its license and tell me what it is — don't add it
  silently. License stakes vary by project (check a project's own CLAUDE.local.md/CLAUDE.md for
  specifics, e.g. redistribution constraints), but flagging the license is the default habit
  everywhere.

# Code Change Protocol

## .NET projects — advise-only, whole project
If the working directory contains any `.sln`, `.slnx`, `.csproj`, `.fsproj`, or `.vbproj`, I am working in a .NET project. Then:
- **Do not create, edit, or delete ANY file in it** — not just the C#/.NET ones. `.gitignore`, `.gitattributes`, `.dockerignore`, `Dockerfile`, `appsettings*.json`, YAML, Markdown, scripts — all of it. I write every file myself.
- **Do not run state-changing commands**: `git init`, `git add`, `git commit`, `dotnet new`, scaffolding, generators, formatters, `sed -i`, or shell redirects that write files.
- The deliverable is guidance in chat: copyable snippets plus the exact commands for me to run, with `file:line` pointers.
- A question ("how do I…", "what do I add…", "can you set up…") is a request for instructions, not authorization to do it.
- `.cs` / `.csproj` / `.fsproj` / `.vbproj` / `.sln` / `.slnx` stay off-limits unconditionally, even when I directly ask for the edit. Any other file in the project needs me to explicitly name it and ask for the change in that same message.
- Read-only work is always fine: reading files, `git status` / `log` / `diff`, and `dotnet build` / `dotnet test` when I ask.

See `~/.claude/rules/dotnet.md`. The sequence below applies to Rust, Go, and TypeScript.

When modifying code, always follow this sequence:
1. READ the file(s) being changed first — understand existing patterns
2. CHECK for related tests, usages, and dependencies before editing
3. MAKE the change
4. VERIFY:
   - C#: dotnet build, then dotnet test if tests exist
   - Rust: cargo check, cargo clippy, then cargo test if tests exist
   - Go: go build ./..., go vet ./..., then go test ./... if tests exist
   - TS: npm run build / tsc --noEmit, then npm test if tests exist
5. FORMAT ONLY THE FILES I TOUCHED — never a whole crate, package, module or repo.
   Formatters reformat every file they are pointed at, including files with pre-existing
   drift that I did not ask to be changed. That silently inflates the diff with unrelated
   churn and buries the real change. Pass explicit file paths:
   - Rust: `rustfmt --edition <ed> <file>...` — **NOT `cargo fmt`**, which is always
     crate-scoped and ignores file arguments even after `--`
   - Go: `gofmt -w <file>...` — not `gofmt -w ./...`
   - C#: `dotnet format --include <file>...` — not bare `dotnet format`
   - TS: `prettier --write <file>...` / `eslint --fix <file>...` — not a glob over src/
   If a formatter has already touched files outside the change, revert exactly those
   (`git checkout -- <file>`) before continuing, and tell me — unrelated formatting is a
   separate commit, never a silent passenger on mine.
6. If the change affects a public API, check all callers
7. When the change involves protocol implementations, complex data structures, algorithms, design patterns, or performance-sensitive code — dispatch @web-explorer to verify the approach against official docs and established best practices before finalizing
8. COMMIT workflow:
   - Never commit directly to the default branch — create a branch first, named `type/scope` using the same type and primary scope as the commit itself: `feat/claude`, `refactor/vs-code`, `chore/oh-my-posh`
   - One scope per branch name even when the commit lists several — use the primary one
   - NEVER stage and push .gitignore - this will be done manually
   - After verified changes, stage the relevant files with git add
   - Draft a commit message — subject line only, no body/description
   - Format: `type(scope): message` — if multiple scopes, comma-separate them: `feat(vnc-server, mm-server): ...`
   - Flutter changes use `flutter` as the scope (e.g. `fix(flutter): ...` or `fix(flutter, vnc-server): ...`)
   - Present the staged diff summary and proposed commit message to me for review
   - ALWAYS wait for explicit approval ("yes", "go ahead", etc.) before running git commit — never commit immediately after drafting the message
   - Never git push under any circumstances — not in bypass mode, not in auto-accept mode. Local commits only; the user controls all remote pushes.

# Testing
Do not write tests proactively. Only add test code when the user explicitly asks for tests. This applies to unit tests, integration tests, doctests, and `#[ignore]`-flagged stubs alike. If you would normally add a test as part of implementing a feature, skip it — the user will tell you when tests are wanted.

# Communication
- Be concise. Skip explanations I didn't ask for.
- When unsure between two approaches, present both briefly with tradeoffs.
- Don't repeat file contents back to me unless I ask.
- Always explain technical terms when first used — especially OS-specific or environment-specific ones (systemd directives, kernel features, shell built-ins, distro paths, etc.). State what it is, where it applies, and what it does NOT apply to. Briefly is fine; never assume I know the term.

# Documentation Writing
- When writing a design/implementation/planning doc, present the current, final state as the
  authoritative plan — never narrate my own drafting process as if earlier turns in our
  conversation were prior official versions being revised. Phrases like "this changes the design
  from X to Y," "superseded," "revised after internal review," or "(renamed during planning)" all
  imply a real prior official state existed outside this chat — if it only ever existed as earlier
  messages in the same session, saying so is fabricated history, not real history.
- If a design point needs justifying against an alternative, frame it as "option A vs option B,
  chose B because..." — a normal design-rationale comparison — never as "we used to do A, now we
  do B."
- Comparing against a genuine external artifact (a real document someone else wrote, an
  already-shipped API, existing code) is fine and useful — write that as a factual comparison
  ("this differs from the external proposal because..."), not as a revision log of my own internal
  iteration.
- When a doc has a rendered/HTML companion built from the same source, apply this to both.

# Accuracy — No Guessing
- Never guess when reading or writing files and code. If you don't know a path, filename, value, API, config key, or behavior, verify it (read the file, grep the code, check the docs) before stating or using it.
- If something cannot be verified, say so explicitly and label it as an assumption/placeholder — do not present a guess as fact.
- This applies to file paths, config values, function/field names, log locations, system behavior, and OS/environment specifics.
