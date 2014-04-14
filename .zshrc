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

ICON_SEPARATOR_RIGHT_FULL='⮀'
ICON_SEPARATOR_RIGHT_EMPTY='⮁'
ICON_SEPARATOR_LEFT_FULL='⮂'
ICON_SEPARATOR_LEFT_EMPTY='⮃'
ICON_DIRTY_WORKING_DIRECTORY='±'
ICON_GIT_BRANCH='⭠'
ICON_GIT_DETACHED_HEAD='➦'
ICON_GIT_ATTACHED_HEAD='➥'
ICON_BACKGROUND_JOBS='⚙'
ICON_TRUE='✔'
ICON_FALSE='✘'
ICON_POWER_BATTERY='🔋'
ICON_POWER_ADAPTER='🔌'
ICON_ROOT='☢'

RETVAL="0"
PREVIOUS_BG_COLOR='NONE'

function print_segment() {
	local bg="%K{$1}"
	local fg="%F{$2}"
	local value=$3

	if [[ $PREVIOUS_BG_COLOR != 'NONE' ]]; then
		if [[ $PREVIOUS_BG_COLOR != $1 ]]; then
			local PREVIOUS_BG="%F{${PREVIOUS_BG_COLOR}}"
			echo -n "%{${bg}${PREVIOUS_BG}%}${ICON_SEPARATOR_RIGHT_FULL}%{${bg}${fg}%} ${3} "
		else
			echo -n "%{${bg}${fg}%} ${ICON_SEPARATOR_RIGHT_EMPTY} ${3} "
		fi
	else
		echo -n "%{${bg}${fg}%} ${3} "
	fi

	PREVIOUS_BG_COLOR="$1"
}

function print_name(){
	local bg_color=green
	if [[ $UID -eq 0 ]]; then
		bg_color=red
	fi

	print_segment $bg_color black "%n @ %M"
}

function print_directory() {
	print_segment black white "%~"
}

function prompt_end() {
	echo -n "%{$reset_color%}%{%F{${PREVIOUS_BG_COLOR}}%}${ICON_SEPARATOR_RIGHT_FULL}%{$reset_color%} "
}

function build_prompt(){
	RETVAL=%?
	print_name
	print_directory
	prompt_end
}

function get_power_information(){
	BATTERY_STATE=$(acpi -b)
	POWER_ADAPTER_STATE=$(acpi -a)
	POWER_ADAPTER_STATE_FORMATTED=${${POWER_ADAPTER_STATE#*:}:1}

    if [[ $POWER_ADAPTER_STATE_FORMATTED == "on-line" && $BATTERY_STATE == "" ]]; then
        echo -n $ICON_POWER_ADAPTER
    elif [[ $BATTERY_STATE != "" ]]; then
        BATTERY_STATE_FORMATTED=${${${BATTERY_STATE#*,}%%,*}:1}
        case $POWER_ADAPTER_STATE_FORMATTED in
            "on-line")
                echo -n $ICON_POWER_ADAPTER' :'$BATTERY_STATE_FORMATTED'%'
                ;;
            "off-line")
                echo -n $ICON_POWER_BATTERY' :'$BATTERY_STATE_FORMATTED'%'
            ;;
        esac
    fi
}

function get_git_information(){
	RESULT=${$(git branch | grep '^/*'):2}
	echo -n ${ICON_GIT_BRANCH}':'${RESULT}'%'
}

function build_right_prompt(){
	local result=""

	$(which git >/dev/null) && $(ls .git 2>/dev/null) && result=$result"$(get_git_information) "

	$(which acpi >/dev/null) && result=$result"$(get_power_information) "
	result=$result"$ICON_BACKGROUND_JOBS:%j"

	echo -n $result"%{$reset_color%}"
}

setopt PROMPT_SUBST
RPROMPT='$(build_right_prompt)'
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
	LESE_TERMCAP_me=$'\E[0m' \
	LESS_TERMCAP_se=$'\E[0m' \
	LESS_TERMCAP_so=$'\E[38;5;246m' \
	LESS_TERMCAP_ue=$'\E[0m' \
	LESS_TERMCAP_us=$'\E[04;38;5;146m' \
	man "$@"
}
