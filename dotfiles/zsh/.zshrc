# Startup time tracker
zmodload zsh/datetime
zmodload zsh/complist
typeset -F START_TIME=$EPOCHREALTIME

# Setup autocomplete
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C   # use cached dump, skip security scan
fi

# Bootstrap zsh config fragments from ~/.zshrc.other/
if [ -d ~/.zshrc.other ]; then
    for config_file in ~/.zshrc.other/.zshrc.*(.N); do
        # echo "Setting up $config_file..."
        source "$config_file"
    done
fi

# p10k theme
source "$(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Initialize the base system PATH
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/libexec"

# Append additional tools
export PATH="/Library/Frameworks/Python.framework/Versions/3.13/lib/python3.13/site-packages:${PATH}" # Python
export PATH="/Library/Frameworks/Python.framework/Versions/3.13/bin:${PATH}"
export PATH="/opt/homebrew/bin:${PATH}"     # Homebrew packages
export PATH="${HOME}/.cargo/bin:${PATH}"    # Rust 
export PATH="$HOME/.opencode/bin:$PATH"     # Opencode
export GOPATH="$HOME/.local/share/go"       # Configure golang's PATH
export GPG_TTY=$TTY                         # Configure GPG terminal path

fpath+=("$STACK_LOG_BREW_PREFIX/share/zsh/site-functions") # Cleaned up brew prefix logic

# Tmux
bindkey -r "^[/"    # Unbind /

# Lazy Load for NVM (Node Version Manager) initialization
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm node npm npx corepack
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}
node() { unset -f nvm node npm npx corepack; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; node "$@"; }
npm() { unset -f nvm node npm npx corepack; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; npm "$@"; }
npx() { unset -f nvm node npm npx corepack; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; npx "$@"; }

# Configure TMUX session terminal history to exist independently
if [ -n "$TMUX" ]; then
  # Create a hidden history directory if it doesn't exist
  mkdir -p "$HOME/.tmux_history"
  # Dynamically query the current session name
  CURRENT_SESSION=$(tmux display-message -p '#S')
  export HISTFILE="$HOME/.tmux_history/history_s_${CURRENT_SESSION}"
fi

# Startup time calculation
typeset -F END_TIME=$EPOCHREALTIME
integer TOTAL_MS=$(( (END_TIME - START_TIME) * 1000 ))
print -P "%F{244}⚡ Shell initialized in ${TOTAL_MS}ms%f"
