# Claude Code Setup Instructions (Windows)

You are setting up Claude Code on a fresh Windows machine using the config from this dotfiles repo.
Follow these steps exactly. All commands are PowerShell.

## 1. Locate the dotfiles

The dotfiles repo should already be cloned. Confirm the `claude\` directory exists:

```
$HOME\dotfiles\claude\
```

If it's cloned elsewhere, adjust `$DOTFILES` in step 3 accordingly.

## 2. Create the required directories

```powershell
$d = "$env:USERPROFILE\.claude"
New-Item -ItemType Directory -Force -Path "$d\agents"              | Out-Null
New-Item -ItemType Directory -Force -Path "$d\rules"               | Out-Null
New-Item -ItemType Directory -Force -Path "$d\skills\analyze"      | Out-Null
New-Item -ItemType Directory -Force -Path "$d\skills\init-project" | Out-Null
New-Item -ItemType Directory -Force -Path "$d\skills\build-agent"  | Out-Null
```

## 3. Copy the config files

```powershell
$src = "$HOME\dotfiles\claude"
$dst = "$env:USERPROFILE\.claude"

Copy-Item "$src\CLAUDE.md"                           "$dst\CLAUDE.md"
Copy-Item "$src\settings.json"                       "$dst\settings.json"
Copy-Item "$src\statusline-command.sh"               "$dst\statusline-command.sh"
Copy-Item "$src\agent-background-blacklist.json"     "$dst\agent-background-blacklist.json"
Copy-Item "$src\agents\web-explorer.md"              "$dst\agents\web-explorer.md"
Copy-Item "$src\agents\rust-learning-journal.md"     "$dst\agents\rust-learning-journal.md"
Copy-Item "$src\agents\agent-builder.md"             "$dst\agents\agent-builder.md"
Copy-Item "$src\rules\dotnet.md"                     "$dst\rules\dotnet.md"
Copy-Item "$src\rules\rust.md"                       "$dst\rules\rust.md"
Copy-Item "$src\skills\analyze\SKILL.md"             "$dst\skills\analyze\SKILL.md"
Copy-Item "$src\skills\init-project\SKILL.md"        "$dst\skills\init-project\SKILL.md"
Copy-Item "$src\skills\build-agent\SKILL.md"         "$dst\skills\build-agent\SKILL.md"
```

## 4. Verify

Confirm all files are in place:

```powershell
$files = @(
    "$env:USERPROFILE\.claude\CLAUDE.md",
    "$env:USERPROFILE\.claude\settings.json",
    "$env:USERPROFILE\.claude\statusline-command.sh",
    "$env:USERPROFILE\.claude\agent-background-blacklist.json",
    "$env:USERPROFILE\.claude\agents\web-explorer.md",
    "$env:USERPROFILE\.claude\agents\rust-learning-journal.md",
    "$env:USERPROFILE\.claude\agents\agent-builder.md",
    "$env:USERPROFILE\.claude\rules\dotnet.md",
    "$env:USERPROFILE\.claude\rules\rust.md",
    "$env:USERPROFILE\.claude\skills\analyze\SKILL.md",
    "$env:USERPROFILE\.claude\skills\init-project\SKILL.md",
    "$env:USERPROFILE\.claude\skills\build-agent\SKILL.md"
)
foreach ($f in $files) {
    Write-Host "$(if (Test-Path $f) { 'OK     ' } else { 'MISSING' })  $f"
}
```

## Dependencies

- `jq` — required by `statusline-command.sh` and all hooks
  - Install via winget: `winget install jqlang.jq`
  - Or via Scoop: `scoop install jq`
  - Or via Chocolatey: `choco install jq`
- `dotnet format` — required by the C# format hook (included with .NET SDK)
- `rustfmt` — required by the Rust format hook (`rustup component add rustfmt`)
- `gofmt` — required by the Go format hook (included with the Go toolchain)

> **Note:** `statusline-command.sh` is a shell script. On Windows it runs via Git Bash or WSL.
> If you are not using Git Bash or WSL, the status line hook will not work unless you have a
> compatible shell available on your `PATH`.
