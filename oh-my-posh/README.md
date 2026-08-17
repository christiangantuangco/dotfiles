# Oh My Posh Setup

The theme (`hul10.tan.json`) uses Nerd Font glyphs, so install a Nerd Font and set it as your
terminal font first — otherwise segments render as boxes:

```
oh-my-posh font install
```

## Linux / macOS (zsh)

1. **Download Oh My Posh**
   ```bash
   curl -s https://ohmyposh.dev/install.sh | bash -s
   ```

2. **Edit your `.zshrc`**

   Add this line:
   ```bash
   eval "$(oh-my-posh init zsh --config ~/dotfiles/oh-my-posh/hul10.tan.json)"
   ```

   **Note:** Make sure to adjust the path if your dotfiles directory is located elsewhere.

3. **Reload your shell**
   ```bash
   exec zsh
   ```

## Windows (PowerShell `$PROFILE`)

`$PROFILE` is a PowerShell automatic variable holding the path to your startup script — the
PowerShell equivalent of `.zshrc`. It is per-user *and* per-host, so the path differs by edition:

| Edition | Path |
| --- | --- |
| Windows PowerShell 5.1 (`powershell.exe`) | `$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` |
| PowerShell 7+ (`pwsh.exe`) | `$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1` |

If OneDrive Known Folder Move is enabled, `Documents` lives under `$HOME\OneDrive\Documents`
instead. Don't hardcode either — just use `$PROFILE`, which always resolves to the right one for
the shell you're in. Run `$PROFILE | Format-List * -Force` to see all four profile paths.

1. **Install Oh My Posh**
   ```powershell
   winget install JanDeDobbeleer.OhMyPosh -s winget
   ```

   Restart the terminal afterwards so the new `PATH` entry is picked up.

2. **Create the profile if it doesn't exist**
   ```powershell
   if (-not (Test-Path $PROFILE)) { New-Item -ItemType File -Path $PROFILE -Force }
   ```

   `-Force` also creates the parent directory when it's missing.

3. **Edit the profile**
   ```powershell
   notepad $PROFILE
   ```

   Add:
   ```powershell
   # oh-my-posh theme
   oh-my-posh init pwsh --config ~/Projects/dotfiles/oh-my-posh/hul10.tan.json | Invoke-Expression
   ```

   **Note:** Adjust the path if your dotfiles repo is cloned elsewhere. `pwsh` is the correct
   shell argument for both Windows PowerShell 5.1 and PowerShell 7 — there is no `powershell`
   option.

4. **Reload the profile**
   ```powershell
   . $PROFILE
   ```

   If it errors with a script-execution message, allow local scripts once:
   ```powershell
   Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
   ```
