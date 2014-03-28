# enable the autocompletion with alias management
autoload -U compinit && compinit
setopt completealiases
# enable cache for completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh_cache
# improve completion format
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
# arrow key navigation enbaled
zstyle ':completion:*' menu select

# enable selective historique
setopt hist_ignore_space
# delete historique double values
setopt hist_ignore_all_dups

# enable autocd
setopt autocd

# enable advances regexpr
setopt extendedglob

# color completion
zmodload zsh/complist
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=36=31"

# warning if file exists
#setopt NO_clobber

# alert me if something failed
#setopt printexitvalue

autoload -U promptinit && promptinit

# commands corrections
setopt correctall

# prompt definition
autoload -U colors && colors

defaultColor=$fg_no_bold[white]
boldColor=$fg_bold[green]
normalColor=$fg_no_bold[green]

#if it's root
if [ ${EUID} -eq 0 ]; then
	boldColor=$fg_bold[red]
	normalColor=$fg_no_bold[red]
fi

PROMPT="%{${normalColor}%}[%n @ %M]--[%{${reset_color}%}%~%{${normalColor}%}] → %# %{${reset_color}%}"

#alias
alias ls='ls --color=auto'                   # replace the ls command to add coloration
alias ll='ls --color=auto -lh'               # list all files and folders with human readable size and coloration
alias lal='ls --color=auto -lah'             # list all files and folders including hidden files and folders with human readable size and coloration

alias grep='grep --color=auto'               # replace the grep command to add coloration
alias shutdown='shutdown now'                # replace the default shutdown command to add 'now' parameter

#man coloration
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}
