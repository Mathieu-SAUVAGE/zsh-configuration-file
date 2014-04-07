​
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
ICON_POWER='⚡'
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
    local result=""
    local bg_color=green
    if [[ $UID -eq 0 ]]; then
        bg_color=red
    fi

    print_segment $bg_color black $result"%n @ %M"
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
    RESULT=$(acpi -b)
    if [[ $RESULT != "" ]]; then
               RESULT=${RESULT#*,}
               RESULT=${${RESULT%%,*}:1}
               echo -n "${ICON_POWER}:${RESULT}%"
    fi
}

function build_right_prompt(){
    local result=""

    [[ $RETVAL -ne 0 ]] && result=$result" $ICON_FALSE "

    $(which acpi >/dev/null)
    [[ $? -eq 0 ]] && result=$result" $(get_power_information)"

    result=$result" $ICON_BACKGROUND_JOBS:%j"

    echo -n "$result"
}

RPROMPT=$(build_right_prompt)
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

