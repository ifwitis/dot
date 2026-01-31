#
# ~/.bashrc
#

#
# Command Prompt Appearance Config
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias la='ls --color=auto -al'
alias grep='grep --color=auto'

# Git
GIT_PS1_SHOWDIRTYSTATE='y'
GIT_PS1_SHOWUNTRACKEDFILES='y'
GIT_PS1_SHOWCOLORHINTS='y'
GIT_PS1_SHOWUPSTREAM='auto'

# Colors
RESET='\[\e[0m\]'
MAGENTA='\[\e[1;35m\]'
BLUE='\[\e[1;34m\]'
CYAN='\[\e[36m\]'

#PS1='[\u\[\e[1;35m\]@\h\[\e[0m\]]\[\e[0;36m\][\w]\[\e[0m\]\$ '
PS1="${RESET}[${MAGENTA}\u${BLUE}@\h ${CYAN}\W${RESET}]\$ "

export EDITOR='nvim'
export VISUAL='nvim'

#
# Auto-start ssh-agent
#
env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2=agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    ssh-add
fi

unset env

