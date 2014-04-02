​# enable the autocompletion with alias management
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
ICON_BACKGROUND='⚙'
ICON_TRUE='✔'
ICON_FALSE='✘'
ICON_POWER='⚡'
ICON_ROOT='☢'
ICON_ATOM='⚛'
ICON_ROUNDING_STAR='⚝'
ICON_STAR='★'
ICON_WARNING='⚠'
ICON_RECYCLE='♽'
ICON_RECYCLE='♻'
ICON_RECYCLE='♼'
ICON_RECYCLE='☣'
ICON_RECYCLE='☠'
ICON_RECYCLE='☯'


RETURN_VALUE=0
PREVIOUS_BG_COLOR='NONE'
RETURN_VALUE=0

print_segment() {
    local bg="%K{$1}"
    local fg="%F{$2}"
    local value=$3

    if [[ $PREVIOUS_BG_COLOR != 'NONE' ]]; then
        local t="%F{${PREVIOUS_BG_COLOR}}"
        echo -n "%{${bg}${t}%}${ICON_SEPARATOR}%{${bg}${fg}%} ${3} "
    else
        echo -n "%{${bg}${fg}%} ${3} "
    fi

    PREVIOUS_BG_COLOR=$1
}

print_status() {
    [[ $RETURN_VALUE -ne 0 ]] && echo "%{%F{red}%}✘"
    [[ $UID -eq 0 ]] && echo "%{%F{yellow}%}⚡"
    [[ $(jobs -l | wc -l) -gt 0 ]] && echo "%{%F{cyan}%}⚙"
}

print_name(){
    local result=""
    if [[ $UID -eq 0 ]]; then
        result=$result"${ICON_ROOT} "
    fi
    if [[ $(jobs -l | wc -l) -gt 0 ]]; then
        result=$result"${ICON_BACKGROUND} "
    fi
    print_segment black white  $result"%n @ %M"
}

print_directory() {
    print_segment blue black "%~"
}

prompt_git() {
    local ref dirty
    if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
        ZSH_THEME_GIT_PROMPT_DIRTY='±'
        dirty=$(parse_git_dirty)
        ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
        if [[ -n $dirty ]]; then
            prompt_segment yellow black "${ref/refs\/heads\//⭠ }$dirty"
        else
            prompt_segment green black "${ref/refs\/heads\//⭠ }$dirty"
        fi
    fi
}

# Context: user@hostname (who am I and where am I)
prompt_context() {
    local user=`whoami`
 
    if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)$user@%m"
    fi
}

prompt_end() {
    echo -n "%{$reset_color%}%{%F{${PREVIOUS_BG_COLOR}}%}${ICON_SEPARATOR}%{$reset_color%} "
}

build_prompt(){
    print_name
    print_directory
    prompt_end
}

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