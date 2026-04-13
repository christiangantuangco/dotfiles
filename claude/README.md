# Claude Code Setup

## What's here

| Path | Maps to | Purpose |
|------|---------|---------|
| `CLAUDE.md` | `~/.claude/CLAUDE.md` | Global instructions, code style, commit workflow |
| `settings.json` | `~/.claude/settings.json` | Permissions, hooks, status line, env vars |
| `statusline-command.sh` | `~/.claude/statusline-command.sh` | Custom status line (user@host, git branch, model, context %) |
| `agents/web-explorer.md` | `~/.claude/agents/web-explorer.md` | Research agent for verifying technical approaches |
| `rules/dotnet.md` | `~/.claude/rules/dotnet.md` | C# conventions, auto-applied to *.cs / *.csproj / *.sln |
| `rules/rust.md` | `~/.claude/rules/rust.md` | Rust conventions, auto-applied to *.rs / Cargo.toml |
| `skills/analyze/SKILL.md` | `~/.claude/skills/analyze/SKILL.md` | Pre/post change analysis skill |
| `skills/init-project/SKILL.md` | `~/.claude/skills/init-project/SKILL.md` | Project CLAUDE.md bootstrapper skill |

## Fresh machine setup

1. Install Claude Code: `npm install -g @anthropic-ai/claude-code`
2. Open Claude Code in the `~/dotfiles` directory
3. Tell Claude: **"Read `claude/setup-claude.md` and follow the instructions to set yourself up"**

Claude will copy all config files into `~/.claude/` for you.

## Hooks

Two `PostToolUse` hooks run automatically after every file edit:

- **C# formatter** — runs `dotnet format --include <file>` on `.cs` files
- **Rust formatter** — runs `rustfmt` on `.rs` files

Both are fire-and-forget (`|| true`) so they never block Claude on format errors.

## Status line

Displays two lines:

```
user@host /current/dir (git-branch)
Model Name [████████░░░░░░░░] 42%
```

Requires `jq` to be installed.
