#!/bin/bash
# Terraform helpers
alias 'tf'='terraform'
alias 'tfw'='terraform workspace'
alias 'tfw-ls'='terraform workspace list'
alias 'tfw-use'='terraform workspace select'
alias 'tfw-rm'='terraform workspace delete'
prompt_callback()
{
    # get current workspace
    WORKSPACE=${TF_WORKSPACE:-$(terraform workspace show)}
    if $(pwd | /bin/grep -q 'terraform'); then
      if [ -n "$WORKSPACE" ]; then
        echo -ne "${White}(terraform: "
        [ "${WORKSPACE}" == "production" ] && echo -ne "${BoldRed}" || echo -ne "${Green}"
        echo -e "${WORKSPACE}${White})${ResetColor}"
      fi
    fi
}
# dozy.io 2020
# Download latest version from https://github.com/dozyio/terraform-bash-workspace-prompt
RESETCOLOR="$(echo -e "\001\033[0m\002")"
PURPLETEXT="$(echo -e "\001\033[35m\002")"
BOLDTEXT="$(echo -e "\001\033[1m\002")"
SAFETEXT="$(echo -e "\001\033[1;32m\002")"
CAUTIONTEXT="$(echo -e "\001\033[1;33;93m\002")"
DANGERTEXT="$(echo -e "\001\033[1;41;97m\002")"
TFPURPLE="$(echo -e "$PURPLETEXT(TF:$RESETCOLOR")"
TFPURPLEEND="$(echo -e "$PURPLETEXT)$RESETCOLOR")"
function terraform_workspace_prompt()
{
    if [ -d .terraform ]; then
        terraform_workspace="$(command terraform workspace show 2>/dev/null)"
        if [[ $terraform_workspace == "prod"* ]] || \
            [[ $terraform_workspace == "PROD"* ]] || \
            [[ $terraform_workspace == "Prod"* ]]; then
            echo -e " $TFPURPLE$DANGERTEXT${terraform_workspace}$RESETCOLOR$TFPURPLEEND"
        elif [[ $terraform_workspace == "test"* ]] || \
            [[ $terraform_workspace == "TEST"* ]] || \
            [[ $terraform_workspace == "testmachina"* ]] || \
            [[ $terraform_workspace == "Testmachina"* ]] || \
            [[ $terraform_workspace == "TestMachina"* ]] || \
            [[ $terraform_workspace == "test-machina"* ]] || \
            [[ $terraform_workspace == "dev"* ]] || \
            [[ $terraform_workspace == "DEV"* ]] || \
            [[ $terraform_workspace == "Dev"* ]]; then
            echo -e " $TFPURPLE$SAFETEXT${terraform_workspace}$RESETCOLOR$TFPURPLEEND"
        elif [[ $terraform_workspace == "heart"* ]] || \
            [[ $terraform_workspace == "fire"* ]] || \
            [[ $terraform_workspace == "water"* ]] || \
            [[ $terraform_workspace == "wind"* ]] || \
            [[ $terraform_workspace == "earth"* ]] || \
            [[ $terraform_workspace == "integrations"* ]] || \
            [[ $terraform_workspace == "dev"* ]] || \
            [[ $terraform_workspace == "DEV"* ]] || \
            [[ $terraform_workspace == "Dev"* ]]; then
            echo -e " $TFPURPLE$CAUTIONTEXT${terraform_workspace}$RESETCOLOR$TFPURPLEEND"
        else
            echo -e " $TFPURPLE$BOLDTEXT${terraform_workspace}$RESETCOLOR$TFPURPLEEND"
        fi
    fi
}
if test -f ~/.config/git/git-prompt.sh
then
    . ~/.config/git/git-prompt.sh
else
    PS1='\[\033]0;Git Bash$PWD\007\]' # set window title
    PS1="$PS1"'\n'                 # new line
    PS1="$PS1"'\[\033[32m\]'       # change to green
    PS1="$PS1"'\u@\h '             # user@host<space>
    #PS1="$PS1"'\[\033[35m\]'       # change to purple
    #PS1="$PS1"'$MSYSTEM '          # show MSYSTEM
    PS1="$PS1"'\[\033[33m\]'       # change to white
    PS1="$PS1"'\w'                 # current working directory
    if test -z "$WINELOADERNOEXEC"
    then
        GIT_EXEC_PATH="$(git --exec-path 2>/dev/null)"
        COMPLETION_PATH="${GIT_EXEC_PATH%/libexec/git-core}"
        COMPLETION_PATH="${COMPLETION_PATH%/lib/git-core}"
        COMPLETION_PATH="$COMPLETION_PATH/share/git/completion"
        if test -f "$COMPLETION_PATH/git-prompt.sh"
        then
            . "$COMPLETION_PATH/git-completion.bash"
            . "$COMPLETION_PATH/git-prompt.sh"
            PS1="$PS1"'\[\033[36m\]'  # change color to cyan
            PS1="$PS1"'`__git_ps1`'   # bash function
        fi
    fi
    # PS1="$PS1"' \[\033[37m\][\A]'  # 24h time, white
    PS1="$PS1"'\[\033[0m\]'        # change color
    PS1="$PS1"'\n'                 # new line
    # At the moment putting this before the new line results in bash: command substitution: line 1: syntax error near unexpected token `)'
    PS1="$PS1"'$(terraform_workspace_prompt)' # Terraform Workspace
    PS1="$PS1"'$ '                 # prompt: always $
fi
MSYS2_PS1="$PS1"               # for detection by MSYS2 SDK's bash.basrc
# Evaluate all user-specific Bash completion scripts (if any)
if test -z "$WINELOADERNOEXEC"
then
    for c in "$HOME"/bash_completion.d/*.bash
    do
        # Handle absence of any scripts (or the folder) gracefully
        test ! -f "$c" ||
        . "$c"
    done
fi
#Git status options
# export GIT_PS1_SHOWSTASHSTATE=true
# export GIT_PS1_SHOWDIRTYSTATE=true
# export GIT_PS1_SHOWUNTRACKEDFILES=true
# export GIT_PS1_SHOWUPSTREAM="auto"