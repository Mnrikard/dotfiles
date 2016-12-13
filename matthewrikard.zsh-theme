local nl=$'\n'
local ret_status="${nl}%(?:%{$fg_bold[green]%}😎 :%{$fg_bold[red]%}😿 )"
PROMPT='%{$fg[cyan]%}%~%{$reset_color%} $(git_prompt_info) ${ret_status}'
RPROMPT='%D{%H:%M:%S}%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
