function my_git_prompt() {
  tester=$(git rev-parse --git-dir 2> /dev/null) || return
  
  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""

  # is branch ahead?
  if $(echo "$(git log origin/$(current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi

  # is anything staged?
  if $(echo "$INDEX" | grep -E -e '^(D[ M]|[MARC][ MD]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
  fi

  # is anything unstaged?
  if $(echo "$INDEX" | grep -E -e '^[ MARC][MD] ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
  fi

  # is anything untracked?
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi

  # is anything unmerged?
  if $(echo "$INDEX" | grep -E -e '^(A[AU]|D[DU]|U[ADU]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
  fi

  if [[ -n $STATUS ]]; then
    STATUS=" $STATUS"
  fi

  echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(my_current_branch)$STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function my_current_branch() {
  echo $(current_branch || echo "(no branch)")
}

function conda_info() {
  if [[ -n $CONDA_DEFAULT_ENV ]]; then
    echo ${CONDA_PROMPT}
    #echo $(basename ${CONDA_DEFAULT_ENV})
  fi
}

if [ "$(whoami)" = "root" ]
then TIP_COLOR="%{$fg_bold[red]%}" && USER_SYMBOL="#"
else TIP_COLOR="%{$fg_bold[blue]%}" && USER_SYMBOL="$"
fi

function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "$SSH"
  fi
}
# Outputs a symbol for the repository type
function repos_type {
  git branch >/dev/null 2>/dev/null && echo '' && return
  hg root >/dev/null 2>/dev/null && echo '${PREFIX}☿${SUFFIX}' && return
  echo ''
}
START_LINE_ONE="%{$fg_bold[blue]%}╭──"
START_LINE_TWO="%{$fg_bold[blue]%}╰─"
THE_TIP="${TIP_COLOR}${USER_SYMBOL} %{$reset_color%}"
USER_HOST_SPLIT="%{$fg_bold[red]%}@"
PREFIX="%{$fg_bold[grey]%}["
SUFFIX="%{$fg_bold[grey]%}]"
MY_USER="%{$fg_bold[green]%}%n"
MY_HOST="%{$fg_bold[grey]%}%m"
MY_PATH="%{$fg_bold[white]%}%${PWD/#$HOME/~}"
SSH="%{$fg_bold[green]%}(ssh)"
CONDA_PROMPT="%{$fg_bold[red]%}{${CONDA_DEFAULT_ENV}}"

# Current time 24-hour format
MY_TIME="%{$fg_bold[blue]%}[%T]%{$reset_color%}"

# Return code of last command executed
MY_RETURN="%{$fg_no_bold[yellow]%}%?%{$reset_color%}"

# Number of terminals opened
MY_TERMS="%{$fg_no_bold[yellow]%}%L%{$reset_color%}"

# Line one and two of the prompt
PROMPT='${START_LINE_ONE}${MY_USER}${USER_HOST_SPLIT}${MY_HOST} ${MY_TIME} ${PREFIX}${MY_PATH}${SUFFIX} $(my_git_prompt) $(ssh_connection) $(repos_type) ${CONDA_PROMPT}
${START_LINE_TWO}${THE_TIP}'
RPS1="$(vi_mode_prompt_info) ${MY_RETURN}"

#Git Repo Info
ZSH_THEME_PROMPT_RETURNCODE_PREFIX="%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_no_bold[white]%}[%{$fg_no_bold[green]%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[magenta]%}↑"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[red]%}●"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[white]%}●"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[red]%}✘"
ZSH_THEME_GIT_PROMPT_SUFFIX="$fg_no_bold[white]]%{$reset_color%}"
