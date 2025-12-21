#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias la='ls --color=auto -al'
alias grep='grep --color=auto'
alias icat='kitten icat'
PS1='[\u\[\e[1;35m\]@\h\[\e[0m\]]\[\e[0;36m\][\w]\[\e[0m\]\$ '

export EDITOR='nvim'
export VISUAL='nvim'
