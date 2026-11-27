# dot 
Welcome to my silly dotfiles

### Repo layout
Up-to-date as of 11/27/2026
```
dot/
├── dotfiles/
│   ├── ghostty/       # Terminal appearance, keybindings, and GLSL shaders
│   ├── tmux/          # Sessions, pane navigation, and status bar
│   ├── nvim/          # Neovim configuration and plugins
│   ├── zsh/           # Shell configuration and modular scripts
│   ├── bash/          # Arch, Windows, and WSL shell configurations
│   ├── git/           # Git configuration and hooks
│   ├── ssh/           # SSH configuration
│   ├── gnupg/         # GnuPG configuration files
│   ├── kitty/         # Alternative terminal configuration
│   ├── hypr/          # Hyprland and wallpapers
│   ├── opencode/      # OpenCode settings and commands
│   └── skills/        # Reusable agent workflows
├── grub/              # GRUB configuration and themes
└── wallpapers/        # Desktop wallpapers
```

## Setup

### Install dependencies

Install [Homebrew](https://brew.sh/), then run:

```sh
brew install git neovim tmux zoxide bat powerlevel10k ripgrep fd
brew install --cask ghostty font-liberation-nerd-font
```

Requires Neovim 0.11+. Install [NVM](https://github.com/nvm-sh/nvm) if using Node.js.

### Clone the repo

```sh
git clone https://github.com/ifwitis/dot.git ~/dot
cd ~/dot
```

### Personal symlinks

Make sure to backup any existing configurations before creating symlinks.

```sh
mkdir -p ~/.config
DOTFILES="$HOME/dot/dotfiles"

# tmux
ln -s "$DOTFILES/tmux/.tmux.conf" ~/.tmux.conf

# Ghostty
ln -s "$DOTFILES/ghostty" ~/.config/ghostty

# Neovim
ln -s "$DOTFILES/nvim" ~/.config/nvim

# Zsh
ln -s "$DOTFILES/zsh/.zshrc" ~/.zshrc
ln -s "$DOTFILES/zsh/.zshrc.other" ~/.zshrc.other
```

## Miscellaneous notes

Adjust for your machine-specific paths, fonts, and dependencies as needed.

### my zsh configuration
```
└── zsh/
    ├── .zshrc                      # primary config
    └── .zshrc.other/
        ├── .zshrc.comp_prog            # useful functions for competitive programming
        ├── .zshrc.completion           # terminal completino configuration
        ├── .zshrc.p10k                 # Powerlevel10k config
        ├── .zshrc.scripts              # miscellaneous bash functions
        └── .zshrc.secrets              # private environment variables
```

