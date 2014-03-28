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

ICON_SEPARATOR='⮀'
ICON_DIRTY_WORKING_DIRECTORY='±'
ICON_GIT_BRANCH='⭠'
ICON_GIT_DETACHED_HEAD='➦'
ICON_TRUE='✔'
ICON_FALSE='✘'
ICON_POWER='⚡'
ICON_ROOT='☢'

# Begin a segment
# $1 background color
# $2 foreground color
# $3 value
# Both can be omitted, rendering default background/foreground color
print_segment() {
	local bg fg
	[[ -n $1 ]] && bg="%K{$1}" || bg="%k"
	[[ -n $2 ]] && fg="%F{$2}" || fg="%f"

	if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
		echo -n " %{$bg%F{$CURRENT_BG}%}$ICON_SEPARATOR%{$fg%} "
	else
		echo -n "%{$bg%}%{$fg%} "
	fi
	CURRENT_BG=$1
	[[ -n $3 ]] && echo -n $3
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
print_status() {
	local symbols=()

	[[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"x
	[[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"
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

ICON_SEPARATOR='⮀'
ICON_DIRTY_WORKING_DIRECTORY='±'
ICON_GIT_BRANCH='⭠'
ICON_GIT_DETACHED_HEAD='➦'
ICON_TRUE='✔'
ICON_FALSE='✘'
ICON_POWER='⚡'
ICON_ROOT='☢'

CURRENT_BG='NONE'

# Begin a segment
# $1 background color
# $2 foreground color
# $3 value
# Both can be omitted, rendering default background/foreground color
print_segment() {
	local bg fg
	[[ -n $1 ]] && bg="%K{$1}" || bg="%k"
	[[ -n $2 ]] && fg="%F{$2}" || fg="%f"

	if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
		echo -n " %{$bg%F{$CURRENT_BG}%}$ICON_SEPARATOR%{$fg%} "
	else
		echo -n "%{$bg%}%{$fg%} "
	fi
	CURRENT_BG=$1
	[[ -n $3 ]] && echo -n $3
}

print_status() {
	local symbols=()

	[[ $1 -ne 0 ]] && symbols+="%{%F{red}%}${ICON_FALSE}"
	[[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"
	[[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}${ICON_ROOT}"
 
	[[ -n "$symbols" ]] && print_segment black default "$symbols"
}

print_name(){
	local result=("%n @ %M")
	[[ -n "$result" ]] && print_segment black default "$result"
}

build_prompt(){
	print_status $?
	print_name
}

#PROMPT="%{${normalColor}%}[%n @ %M]--[%{${reset_color}%}%~%{${normalColor}%}] → %# %{${reset_color}%}"
PROMPT=$(build_prompt)

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
