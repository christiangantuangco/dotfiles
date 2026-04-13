---
name: init-project
description: "Initialize a new project's CLAUDE.md using my standard template and central config location"
disable-model-invocation: true
argument-hint: <project-name>
allowed-tools: Read, Glob, Grep, LS, Write, Bash(dotnet *), Bash(cargo *), Bash(mkdir *), Bash(cat *), Bash(find *)
---

Initialize project context for Claude Code. The project CLAUDE.md lives
centrally at ~/.claude/projects/<project-name>/CLAUDE.md and is referenced
from the project root via CLAUDE.local.md.

## Steps

### 1. Determine project name

- Use the argument if provided: $1
- Otherwise derive from the current directory name, converted to kebab-case

### 2. Analyze the codebase

1. Read package files (*.csproj, *.sln, Cargo.toml, package.json)
2. Detect tech stack, framework versions, and key dependencies
3. Scan directory structure and identify architectural patterns
4. Find build/test/lint/run commands from config files, scripts, Makefiles
5. Read existing docs (README.md, docs/) for project purpose
6. Check for existing CLAUDE.local.md or ~/.claude/projects/<name>/ — if found, ask before overwriting

### 3. Create the central CLAUDE.md

Create directory ~/.claude/projects/<project-name>/ and write CLAUDE.md using the template below.

Only include sections relevant to the detected stack. For example, omit "API Routes / Endpoints" if the project is a CLI tool, omit "Database" if there is no ORM or migration tool detected.

#### Template

```markdown
# Project: {project name}

## Overview
{One paragraph: what it does, who it's for — detected from README or code}

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

### 4. Create the project root pointer

Create CLAUDE.local.md in the current working directory with a single line:

```
@~/.claude/projects/<project-name>/CLAUDE.md
```

### 5. Confirm

Report:
- Central config path: ~/.claude/projects/<project-name>/CLAUDE.md
- Pointer file: ./CLAUDE.local.md
- Summary of what was detected

## Rules

- Keep output concise — no filler text
- Only include template sections relevant to the detected stack
- Do NOT duplicate conventions from ~/.claude/CLAUDE.md or ~/.claude/rules/
- Focus on project-specific details only
- If both C# and Rust are present in the project, document both
