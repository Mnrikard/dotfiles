local nl=$'\n'
local rarr=$'\ue0b0'
local larr=$'\ue0b2'
local ret_status="${nl}%(?:%{$fg_bold[green]%}✔√ :%{$fg_bold[red]%}✘x )"
PROMPT='%{$fg[black]$bg[cyan]$rarr%}%~%{$reset_color%}%{$fg[cyan]%}$rarr%{$reset_color%} $(git_prompt_info) ${ret_status}'
RPROMPT=$'%F{red}%K{default}$larr%F{white}%K{red} %D{%H:%M:%S} %{$reset_color%}%f%k'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%%"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
