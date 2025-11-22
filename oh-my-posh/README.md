# Oh My Posh Setup

## Setup Instructions

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
