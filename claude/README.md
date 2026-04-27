# Claude Code Setup

## What's here

| Path | Maps to | Purpose |
|------|---------|---------|
| `CLAUDE.md` | `~/.claude/CLAUDE.md` | Global instructions, code style, commit workflow |
| `settings.json` | `~/.claude/settings.json` | Permissions, hooks, status line, env vars |
| `statusline-command.sh` | `~/.claude/statusline-command.sh` | Custom status line (user@host, git branch, model, context %) |
| `agent-background-blacklist.json` | `~/.claude/agent-background-blacklist.json` | Agents excluded from auto-backgrounding (empty = all agents may be backgrounded) |
| `agents/web-explorer.md` | `~/.claude/agents/web-explorer.md` | Research agent for verifying technical approaches |
| `agents/rust-learning-journal.md` | `~/.claude/agents/rust-learning-journal.md` | Appends structured entries to a Rust learning journal when understanding is confirmed |
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

### PreToolUse

- **Agent auto-backgrounder** — automatically sets `run_in_background: true` on all `Agent` tool calls, unless the agent type is listed in `agent-background-blacklist.json`

### PostToolUse

Three hooks run automatically after every file edit:

- **C# formatter** — runs `dotnet format --include <file>` on `.cs` files
- **Rust formatter** — runs `rustfmt` on `.rs` files
- **Go formatter** — runs `gofmt -w` on `.go` files

All are fire-and-forget (`|| true`) so they never block Claude on format errors.

## Agent background blacklist

`agent-background-blacklist.json` is a JSON array of agent type strings that should **not** be auto-backgrounded. It starts empty (all agents may be backgrounded). To pin an agent to the foreground, add its `subagent_type` value:

```json
["rust-learning-journal", "statusline-setup"]
```

The file is read at hook execution time, so changes take effect immediately without restarting Claude.

## Status line

Displays two lines:

```
user@host /current/dir (git-branch)
Model Name [████████░░░░░░░░] 42%
```

Requires `jq` to be installed.
