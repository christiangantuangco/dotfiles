# Claude Code Setup Instructions (Linux)

You are setting up Claude Code on a fresh machine using the config from this dotfiles repo.
Follow these steps exactly.

## 1. Locate the dotfiles

The dotfiles repo should already be cloned. Confirm the `claude/` directory exists:

```
~/dotfiles/claude/
```

If it's cloned elsewhere, adjust the path accordingly.

## 2. Create the required directories

```bash
mkdir -p ~/.claude/agents
mkdir -p ~/.claude/rules
mkdir -p ~/.claude/skills/analyze
mkdir -p ~/.claude/skills/init-project
mkdir -p ~/.claude/skills/build-agent
```

## 3. Copy the config files

```bash
DOTFILES=~/dotfiles/claude

cp "$DOTFILES/CLAUDE.md"                            ~/.claude/CLAUDE.md
cp "$DOTFILES/settings.json"                        ~/.claude/settings.json
cp "$DOTFILES/statusline-command.sh"                ~/.claude/statusline-command.sh
cp "$DOTFILES/agent-background-blacklist.json"      ~/.claude/agent-background-blacklist.json
cp "$DOTFILES/agents/web-explorer.md"               ~/.claude/agents/web-explorer.md
cp "$DOTFILES/agents/rust-learning-journal.md"      ~/.claude/agents/rust-learning-journal.md
cp "$DOTFILES/agents/agent-builder.md"              ~/.claude/agents/agent-builder.md
cp "$DOTFILES/rules/dotnet.md"                      ~/.claude/rules/dotnet.md
cp "$DOTFILES/rules/rust.md"                        ~/.claude/rules/rust.md
cp "$DOTFILES/skills/analyze/SKILL.md"              ~/.claude/skills/analyze/SKILL.md
cp "$DOTFILES/skills/init-project/SKILL.md"         ~/.claude/skills/init-project/SKILL.md
cp "$DOTFILES/skills/build-agent/SKILL.md"          ~/.claude/skills/build-agent/SKILL.md
```

## 4. Make the status line script executable

```bash
chmod +x ~/.claude/statusline-command.sh
```

## 5. Verify

Confirm all files are in place:

```bash
ls ~/.claude/CLAUDE.md ~/.claude/settings.json ~/.claude/statusline-command.sh ~/.claude/agent-background-blacklist.json
ls ~/.claude/agents/web-explorer.md ~/.claude/agents/rust-learning-journal.md ~/.claude/agents/agent-builder.md
ls ~/.claude/rules/dotnet.md ~/.claude/rules/rust.md
ls ~/.claude/skills/analyze/SKILL.md ~/.claude/skills/init-project/SKILL.md ~/.claude/skills/build-agent/SKILL.md
```

## Dependencies

- `jq` — required by `statusline-command.sh` and all hooks (`sudo apt install jq` / `sudo dnf install jq`)
- `dotnet format` — required by the C# format hook (included with .NET SDK)
- `rustfmt` — required by the Rust format hook (`rustup component add rustfmt`)
- `gofmt` — required by the Go format hook (included with the Go toolchain)
