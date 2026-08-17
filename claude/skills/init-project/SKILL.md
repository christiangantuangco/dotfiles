---
name: init-project
description: "Initialize a project's CLAUDE.md using my standard template and central config location; accepts an optional description or spec file to seed empty projects"
disable-model-invocation: true
argument-hint: <project-name> [description | @file]
allowed-tools: Read, Glob, Grep, LS, Write, Bash(dotnet *), Bash(cargo *), Bash(mkdir *), Bash(cat *), Bash(find *)
---

Initialize project context for Claude Code. The project CLAUDE.md lives
centrally at ~/.claude/projects/<project-name>/CLAUDE.md and is referenced
from the project root via CLAUDE.local.md.

## Steps

### 1. Determine project name

- Use the argument if provided: $1
- Otherwise derive from the current directory name, converted to kebab-case

### 2. Resolve the project intent (second argument)

$2 is optional. When present it describes what the project is or is meant to become:

- If it starts with `@` or resolves to an existing path, read that file (spec, README,
  design doc, PRD, notes) and treat its contents as the intent source
- Otherwise treat the raw text as the intent description

This intent is authoritative for *purpose* and *direction*. Detected code is
authoritative for *current state*. When they conflict, document the code as it is and
record the intended direction under "Planned Direction".

If $2 is absent, derive everything from the codebase and docs alone.

### 3. Analyze the codebase

1. Read package files (*.csproj, *.sln, Cargo.toml, package.json)
2. Detect tech stack, framework versions, and key dependencies
3. Scan directory structure and identify architectural patterns
4. Find build/test/lint/run commands from config files, scripts, Makefiles
5. Read existing docs (README.md, docs/) for project purpose
6. Check for existing CLAUDE.local.md or ~/.claude/projects/<name>/ — if found, ask before overwriting

Then classify the project:

- **Existing codebase** — package files or source files found. Document what is there.
  Use the intent to fill gaps detection cannot answer (purpose, audience, roadmap).
- **Empty or near-empty** — no package files, or only scaffolding (.git, .gitignore,
  LICENSE, README). Build the CLAUDE.md from the intent instead of detection.

For an empty project, do not fabricate detected facts. Derive the stack from the intent
if it names one; if it does not, ask which stack to target rather than guessing. Mark
every section that describes something not yet built as `(planned)`, and use the standard
commands for the chosen stack (dotnet build/test, cargo check/clippy/test, go build/vet/test,
npm run build/test) rather than inventing project-specific ones.

Never scaffold source files, package manifests, or directories — this skill only writes
CLAUDE.md and CLAUDE.local.md.

### 4. Create the central CLAUDE.md

Create directory ~/.claude/projects/<project-name>/ and write CLAUDE.md using the template below.

Only include sections relevant to the detected stack. For example, omit "API Routes / Endpoints" if the project is a CLI tool, omit "Database" if there is no ORM or migration tool detected.

#### Template

```markdown
# Project: {project name}

## Overview
{One paragraph: what it does, who it's for — from the intent argument if given,
otherwise detected from README or code}

## Planned Direction
{Only if the intent argument describes work not yet present in the code:
what the project is meant to become, and which parts are not built yet.
Omit this section entirely for an established codebase that matches its intent.}

## Tech Stack
{Exact framework versions, key dependencies with versions}

## Architecture
{Detected patterns: Clean Architecture, Vertical Slices, CQRS, etc.}
{Key directories and their responsibilities}

## Project Structure
{Top-level directory map with brief purpose of each}

## Key Commands
- Build: {detected}
- Test: {detected}
- Lint/Format: {detected}
- Run: {detected}
- Migrate: {detected, if applicable}

## Patterns & Conventions
{Detected from existing code: naming, file organization, DI registration,
error handling, logging approach — only project-specific patterns,
do NOT duplicate anything from ~/.claude/CLAUDE.md or ~/.claude/rules/}

## API Routes / Endpoints
{If web API: list detected route prefixes and controllers/handlers}

## Database
{If applicable: ORM, migration tool, connection string config location}

## Environment
{Required env vars, config files, secrets location}

## Known Pitfalls
- TODO: Add known pitfalls as you encounter them
```

### 5. Create the project root pointer

Create CLAUDE.local.md in the current working directory with a single line:

```
@~/.claude/projects/<project-name>/CLAUDE.md
```

### 6. Confirm

Report:
- Central config path: ~/.claude/projects/<project-name>/CLAUDE.md
- Pointer file: ./CLAUDE.local.md
- Summary of what was detected, and what came from the intent argument instead

## Rules

- Keep output concise — no filler text
- Only include template sections relevant to the detected stack
- Do NOT duplicate conventions from ~/.claude/CLAUDE.md or ~/.claude/rules/
- Focus on project-specific details only
- If both C# and Rust are present in the project, document both
- Mark anything not yet built as `(planned)` — never describe intent as if it exists
- Do not create source files, manifests, or directories; CLAUDE.md and CLAUDE.local.md only

## Examples

```
/init-project my-api
/init-project my-api "Rust axum service exposing device telemetry to an internal dashboard"
/init-project my-api @docs/spec.md
```
