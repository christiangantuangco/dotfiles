---
name: analyze
description: "Analyze code before and after changes — impact analysis, pattern consistency, performance, correctness. Triggers automatically when modifying code."
allowed-tools: Read, Glob, Grep, LS, Bash(dotnet *), Bash(cargo *), Bash(git *)
---

## Pre-Change Analysis

Before making any code modification, perform these checks:

### 1. Read & Understand
- Read the target file(s) completely
- Identify the function/type being changed and its purpose
- Note the current patterns: naming, error handling, DI, logging style

### 2. Impact Analysis
- Grep for all usages of the types/methods being changed
- Identify callers, implementors, and dependents
- Check if the change crosses module/project boundaries
- For public APIs: list every caller and assess breakage risk

### 3. Related Context
- Find related test files (naming conventions: *Tests.cs, *_test.rs, *.test.ts)
- Check for related configuration (DI registration, Cargo.toml features, middleware)
- Note any interfaces/traits the type implements

### 4. Pre-Change Summary
Before proceeding, state concisely:
- "Changing [what] in [where]"
- "Used by [callers/dependents]"
- "Tests in [location]"
- "Risk: [low/medium/high] — [reason]"

---

## Post-Change Analysis

After making the modification:

### 5. Pattern Consistency
- Does the change follow the same patterns as surrounding code?
- Naming: does it match existing conventions in the file/module?
- Error handling: consistent with how the rest of the project handles errors?
- Logging/DI/middleware: follows the established approach?
- If the change introduces a new pattern, flag it explicitly

### 6. Correctness
- Null/None handling: are all paths covered?
- Edge cases: empty collections, zero values, boundary conditions
- Async: no blocking calls in async context (.Result, .Wait() in C#)
- Ownership in Rust: unnecessary clones, missing borrows, lifetime issues
- Thread safety: shared mutable state properly guarded?

### 7. Performance
- C#: N+1 queries, unnecessary allocations, LINQ over large collections
- Rust: unnecessary allocations, excessive cloning, missing &str parameters
- Both: operations inside loops that could be hoisted, redundant work

### 8. Verify
- Run the stack-appropriate build and test commands per the Code Change Protocol
- If any test fails, fix before reporting success
- If no tests cover the changed code, mention it

### 9. Post-Change Summary
After verification passes, state concisely:
- What changed and why
- What was verified (build, tests, clippy/format)
- Any risks, gaps in test coverage, or follow-up items
