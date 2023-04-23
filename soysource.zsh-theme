function prompt_soysource_setup(){
#export __GIT_PROMPT_DIR=${0:A:h}
#
#export GIT_PROMPT_EXECUTABLE=${GIT_PROMPT_EXECUTABLE:-"python"}
#
## Initialize colors.
#autoload -U colors
#colors
#
## Allow for functions in the prompt.
#setopt PROMPT_SUBST
#
setopt PROMPT_SUBST 
#pmodload 'git-prompt'
#autoload -U add-zsh-hook
##
#add-zsh-hook chpwd chpwd_update_git_vars
#add-zsh-hook preexec preexec_update_git_vars
#add-zsh-hook precmd precmd_update_git_vars
#
### Function definitions
#function preexec_update_git_vars() {
#    case "$2" in
#        git*|hub*|gh*|stg*)
#        __EXECUTED_GIT_COMMAND=1
#        ;;
#    esac
#}
#
#function precmd_update_git_vars() {
#    if [ -n "$__EXECUTED_GIT_COMMAND" ] || [ ! -n "$ZSH_THEME_GIT_PROMPT_CACHE" ]; then
#        update_current_git_vars
#        unset __EXECUTED_GIT_COMMAND
#    fi
#}
#
#function chpwd_update_git_vars() {
#    update_current_git_vars
#}
#
#function update_current_git_vars() {
#    unset __CURRENT_GIT_STATUS
#
#    if [[ "$GIT_PROMPT_EXECUTABLE" == "python" ]]; then
#        local gitstatus="$__GIT_PROMPT_DIR/gitstatus.py"
#        _GIT_STATUS=`python ${gitstatus} 2>/dev/null`
#    fi
#    if [[ "$GIT_PROMPT_EXECUTABLE" == "haskell" ]]; then
#        _GIT_STATUS=`git status --porcelain --branch &> /dev/null | $__GIT_PROMPT_DIR/src/.bin/gitstatus`
#    fi
#     __CURRENT_GIT_STATUS=("${(@s: :)_GIT_STATUS}")
#	GIT_BRANCH=$__CURRENT_GIT_STATUS[1]
#	GIT_AHEAD=$__CURRENT_GIT_STATUS[2]
#	GIT_BEHIND=$__CURRENT_GIT_STATUS[3]
#	GIT_STAGED=$__CURRENT_GIT_STATUS[4]
#	GIT_CONFLICTS=$__CURRENT_GIT_STATUS[5]
#	GIT_CHANGED=$__CURRENT_GIT_STATUS[6]
#	GIT_UNTRACKED=$__CURRENT_GIT_STATUS[7]
#}



#ZSH_THEME_SCM_PROMPT_PREFIX="%{%B\e[48;5;208m%} "
ZSH_THEME_GIT_PROMPT_PREFIX="%{%B%K{11}%F{235}%} "
ZSH_THEME_GIT_PROMPT_PREFIX2="%{%B%K{157}%F{235}%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{%b%k%f%}"
#ZSH_THEME_GIT_PROMPT_DIRTY="%{%B%F{196}%}* %{%F{2}%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_SEPARATOR=" "
ZSH_THEME_GIT_PROMPT_BRANCH="%{%B%K{11}%F{235}%}"
ZSH_THEME_GIT_PROMPT_BRANCH2="%{%B%K{157}%F{235}%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{%B%F{34}%}%{o%G%}"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{%B%F{196}%}%{x%G%}"
ZSH_THEME_GIT_PROMPT_CHANGED="%{%B%F{201}%}%{+%G%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{<%G%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{>%G%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{..%G%} "
ZSH_THEME_GIT_PROMPT_CLEAN="%{%B%K{166}%} "
ZSH_THEME_GIT_PROMPT_CLEAN2="%{%B%K{64}%} "



HOSTNUM=$(hostname)
if [ -z ${SSH_CONNECTION} ]; then
  COLORID=0
  export COLORHOST=""
else
  if [ ${#HOSTNUM} -lt 5 ]; then
    HOSTID=${HOSTNUM}
  else
    expr "${HOSTNUM: -2:1}" + 1 >/dev/null 2>&1
    if [ $? -lt 2 ]; then 
      HOSTID=${HOSTNUM: -2:2}
    else
      expr "${HOSTNUM: -3:1}" + 1 >/dev/null 2>&1
      if [ $? -lt 2 ]; then 
        HOSTID=$[4 - ${HOSTNUM: -3:1}]${HOSTNUM: -1:1}
      else
        HOSTID=${HOSTNUM: -3:1}${HOSTNUM: -1:1}
      fi
    fi
  fi
  expr "${HOSTID: -2:1}" + 1 >/dev/null 2>&1
  if [ $? -lt 2 ]; then 
    if [ ${HOSTID} = "w" ]; then
      COLORID=20
    elif [ ${HOSTID} -eq 30 ]; then
      COLORID=22
    elif [ ${HOSTID} -ge 40 ] && [ ${HOSTID} -lt 50 ]; then
      COLORID=$[$HOSTID + 180]
    elif [ ${HOSTID} -gt 30 ] && [ ${HOSTID} -lt 40 ]; then
      NUM1=$[$HOSTID - 31]
      COLORID=$[$NUM1 % 2 + 28 + 6 * $[$NUM1 / 2]]
    elif [ ${HOSTID} -ge 50 ]; then
      NUM2=$[$HOSTID - 50]
      COLORID=$[$NUM2 % 2 + 26 + 6 * $[$NUM2 / 2]]
    else
      COLORID=14
    fi
  else
    COLORID=13
  fi
  export COLORHOST="%{%B%K{${COLORID}}%F{233} ssh %f%k%}"
fi

#if [ -n "$(whence -f git_super_status)" ]; then
git_remote_status_detailed(){
  precmd_update_git_vars
  if [ -n "$__CURRENT_GIT_STATUS" ]; then
    if [ "$GIT_BRANCH" = "master" ]; then
      STATUS="$ZSH_THEME_GIT_PROMPT_PREFIX$ZSH_THEME_GIT_PROMPT_BRANCH$GIT_BRANCH"
    else
      STATUS="$ZSH_THEME_GIT_PROMPT_PREFIX2$ZSH_THEME_GIT_PROMPT_BRANCH2$GIT_BRANCH"
    fi
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_SEPARATOR"
    if [ "$GIT_CHANGED" -eq "0" ] && [ "$GIT_CONFLICTS" -eq "0" ] && [ "$GIT_STAGED" -eq "0" ] && [ "$GIT_AHEAD" -eq "0" ]; then
      if [ "$GIT_BRANCH" = "master" ]; then
        STATUS="$ZSH_THEME_GIT_PROMPT_CLEAN$GIT_BRANCH"
      else
        STATUS="$ZSH_THEME_GIT_PROMPT_CLEAN2$GIT_BRANCH"
      fi
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_SEPARATOR"
    fi
    if [ "$GIT_BEHIND" -ne "0" ]; then
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_BEHIND$GIT_BEHIND"
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_SEPARATOR"
    fi
    if [ "$GIT_AHEAD" -ne "0" ]; then
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD$GIT_AHEAD"
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_SEPARATOR"
    fi
    if [ "$GIT_STAGED" -ne "0" ]; then
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED$GIT_STAGED "
    fi
    if [ "$GIT_CONFLICTS" -ne "0" ]; then
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CONFLICTS$GIT_CONFLICTS "
    fi
    if [ "$GIT_CHANGED" -ne "0" ]; then
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CHANGED$GIT_CHANGED "
    fi
    if [ "$GIT_UNTRACKED" -ne "0" ]; then
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED%{${reset_color}%}"
    fi
    STATUS="$STATUS%{${reset_color}%}$ZSH_THEME_GIT_PROMPT_SUFFIX"
    echo "$STATUS"
  fi
}
#elif [ -n "$(whence -f git_prompt_info)" ]; then
#git_remote_status_detailed(){
# echo $(git_prompt_info)
# #$(bzr_prompt_info)
#}
#else
#git_remote_status_detailed(){
#}
#
#fi
# PROMPT_ARCH=''
# if [ ! -z ${ARCH} ]; then
#   PROMPT_ARCH='%{%B%F{230}%K{167}%} ${ARCH} %{%b%f%k%}'
# fi
export PROMPT_ARCH='%{%B%F{230}%K{167}%}${ARCH:+(}${ARCH}${ARCH:+)}%{%b%f%k%}'

RPROMPT='%{%F{11}%}%~%{%b%k%f%}'
PROMPT='${COLORHOST}%(?.%{%B%K{230}%F{31}%} %n@%m %{%K{31}%F{230}%} $(id -ng) .%{%B%K{230}%F{160}%} %n@%m %{%B%K{160}%F{230}%} $(id -ng) )'"${PROMPT_ARCH}"'$(git_remote_status_detailed)%(?.%{%B%K{24}%F{230}%}.%{%B%K{88}%F{230}%}) %T %D %{%b%k%f%}
%{%B%F{230}%}>%{%b%f%}%{%B%F{228}%}>%{%b%f%}%{%B%F{226}%}>%{%b%f%} '
# PROMPT=$'%{%B\e[48;5;${COLORID};38;5;231m%}  %(?.%{%B\e[48;5;28;38;5;231m%} %n@%m $(id -ng) %{%B\e[48;5;235;38;5;231m%}.%{%B\e[48;5;88;38;5;231m%} %n@%m $(id -ng) ) %~ $(git_remote_status_detailed)%{%B\e[48;5;235;38;5;231m%} %B%T %D %{$reset_color%}
# %{%B\e[38;5;1m%}>%{%B\e[38;5;3m%}>%{%B\e[38;5;2m%}>%{$reset_color%} '
PROMPT2='%{%B%F{0}%}%_> %{%b%f%}'
}

prompt_soysource_setup "$@"
# vim: filetype=zsh
