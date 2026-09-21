---
paths:
  - "**/*.cs"
  - "**/*.csproj"
  - "**/*.fsproj"
  - "**/*.vbproj"
  - "**/*.sln"
  - "**/*.slnx"
  - "**/*.props"
  - "**/*.targets"
  - "**/*.razor"
  - "**/*.cshtml"
  - "**/appsettings*.json"
  - "**/Directory.Build.*"
  - "**/global.json"
  - "**/nuget.config"
---
# C# Conventions

## Working Mode — Advise Only, Whole Project
- **Scope is the project, not the file type.** If the working directory contains any `.sln`, `.slnx`, `.csproj`, `.fsproj`, or `.vbproj`, this rule governs EVERY file in it — not just the ones matched by `paths:` above. That includes `.gitignore`, `.gitattributes`, `.dockerignore`, `Dockerfile`, `appsettings*.json`, YAML, Markdown, and shell/PowerShell scripts.
- Do NOT create, edit, or delete any file in a .NET project. I write all of it myself.
- Do NOT run commands that change project or repo state: `git init`, `git add`, `git commit`, `git restore`, `dotnet new`, scaffolding, generators, code formatters, `sed -i`, or shell redirects that write files.
- Default deliverable is guidance in chat: what to add, exactly where it goes, and why — as copyable snippets plus the exact commands for me to run, not applied edits.
- Point at locations as `file:line` and name the specific members/lines to change.
- A question — "how do I…", "what do I add to…", "can you set up…" — is a request for instructions. It is never authorization to perform the steps.
- This overrides step 3 (MAKE the change) of the Code Change Protocol in CLAUDE.md. Steps 1, 2, 5, and 6 (read, check usages, check callers, verify approach) still apply — they inform the advice.
- Read-only inspection is always fine: Read/Grep/Glob, `git status` / `git log` / `git diff`, and `dotnet build` / `dotnet test` when I ask, after I have made the change myself.
- `.cs`, `.csproj`, `.fsproj`, `.vbproj`, `.sln`, `.slnx` — no exceptions, ever. This holds even if I say "apply it", "make the change", "write it for me", or "go ahead" — and regardless of permission mode (bypass and auto-accept included). Give me the code to paste instead and remind me this rule is on; do not ask whether to override it.
- Every other file in the project — edit only when I explicitly name that file and tell you to change it in that same message. Inferred intent, adjacent requests, and an earlier "go ahead" do not carry over.
- The block covers Edit, Write, and any equivalent via shell.

## Structure & Patterns
- File-scoped namespaces
- One type per file, filename matches type name
- Prefer records for DTOs and value objects
- Repository pattern for data access
- Use IOptions<T> pattern for configuration
- Use MediatR/CQRS pattern if already present in the project — don't introduce it otherwise
- Prefer dependency injection over static helpers

## Null Handling
- Nullable reference types enabled (<Nullable>enable</Nullable>)
- Always check for null using pattern matching (is null / is not null)
- Never use == null or != null
- Use required keyword on properties that must be set

## Async
- Use CancellationToken in async methods that do I/O
- Suffix async methods with Async
- Never use .Result or .Wait() — always await
- Prefer ValueTask over Task for hot paths that often complete synchronously

## Documentation
- XML doc comments on ALL public types, methods, and properties
- Always include <summary>, <param>, <returns>, and <exception> tags where applicable
- Document parameter constraints and valid ranges in <param> tags

## Formatting
- Max line length: 200 chars
- Indentation: 4 spaces
- Primary constructors where appropriate
- Prefer pattern matching (switch expressions, is patterns)
- Prefer explicit types over var when the type isn't obvious
- Use collection expressions ([]) where supported

## Error Handling
- Use Result pattern or throw specific exceptions — never throw bare Exception
- Use guard clauses (ArgumentNullException.ThrowIfNull) at method entry
- Log exceptions with structured logging (ILogger), not Console.Write
