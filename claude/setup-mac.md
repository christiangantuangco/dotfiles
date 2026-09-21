# Claude Code Setup Instructions (macOS)

You are setting up Claude Code on a fresh Mac using the config from this dotfiles repo.
Follow these steps exactly. All commands are zsh/bash.

## 1. Locate the dotfiles

The dotfiles repo should already be cloned. Confirm the `claude/` directory exists:

```
~/dotfiles/claude/
```

If it's cloned elsewhere (e.g. `~/Projects/dotfiles`), adjust `DOTFILES` in step 3 accordingly.

## 2. Create the required directories

```bash
mkdir -p ~/.claude/agents
mkdir -p ~/.claude/rules
mkdir -p ~/.claude/skills/analyze
mkdir -p ~/.claude/skills/init-project
mkdir -p ~/.claude/skills/build-agent
mkdir -p ~/.claude/skills/mr-analyzer
```

## 3. Copy the config files

```bash
DOTFILES=~/dotfiles/claude

cp "$DOTFILES/CLAUDE.md"                            ~/.claude/CLAUDE.md
cp "$DOTFILES/statusline-command.sh"                ~/.claude/statusline-command.sh
cp "$DOTFILES/agent-background-blacklist.json"      ~/.claude/agent-background-blacklist.json
cp "$DOTFILES"/agents/*.md                          ~/.claude/agents/
cp "$DOTFILES"/rules/*.md                           ~/.claude/rules/
cp "$DOTFILES/skills/analyze/SKILL.md"              ~/.claude/skills/analyze/SKILL.md
cp "$DOTFILES/skills/init-project/SKILL.md"         ~/.claude/skills/init-project/SKILL.md
cp "$DOTFILES/skills/build-agent/SKILL.md"          ~/.claude/skills/build-agent/SKILL.md
cp "$DOTFILES/skills/mr-analyzer/SKILL.md"          ~/.claude/skills/mr-analyzer/SKILL.md
```

## 4. Install settings.json

Claude Code creates `~/.claude/settings.json` on first run, so it usually already exists. Do not overwrite it — merge, letting the repo win on conflicts and keeping keys that only exist locally:

```bash
DOTFILES=~/dotfiles/claude

if [ -f ~/.claude/settings.json ]; then
  cp ~/.claude/settings.json ~/.claude/settings.json.pre-dotfiles.bak
  jq -s '.[0] * .[1]' ~/.claude/settings.json.pre-dotfiles.bak "$DOTFILES/settings.json" > ~/.claude/settings.json.new \
    && mv ~/.claude/settings.json.new ~/.claude/settings.json
else
  cp "$DOTFILES/settings.json" ~/.claude/settings.json
fi
```

The merge replaces nested objects key by key but replaces arrays whole (`permissions.allow`, `hooks.*`), so the repo's lists win outright.

## 5. Make the status line script executable

```bash
chmod +x ~/.claude/statusline-command.sh
```

## 6. Verify

Confirm every repo file is installed and identical:

```bash
cd ~/dotfiles/claude

for f in CLAUDE.md statusline-command.sh agent-background-blacklist.json \
         agents/*.md rules/*.md skills/*/SKILL.md; do
  cmp -s "$f" ~/.claude/"$f" && echo "OK       $f" || echo "MISSING  $f"
done
```

Then restart Claude Code so it picks up the new config.

## Dependencies

- `jq` — required by `statusline-command.sh`, all hooks, and step 4
  - Ships with recent macOS at `/usr/bin/jq`; check with `command -v jq`
  - Otherwise: `brew install jq`
- `dotnet format` — required by the C# format hook (included with .NET SDK)
- `rustfmt` — required by the Rust format hook (`rustup component add rustfmt`)
- `gofmt` — required by the Go format hook (included with the Go toolchain)

The format hooks only fire on `.cs` / `.rs` / `.go` files and are fire-and-forget (`|| true`), so a missing toolchain is harmless — that language's files just won't be auto-formatted.

> **Note:** `statusline-command.sh` runs on the stock macOS `/bin/bash` (3.2). It avoids `seq` because BSD `seq 1 0` counts down (`1 0`) instead of printing nothing like GNU `seq`.
