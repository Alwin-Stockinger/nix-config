PROMPT="%{$fg_bold[cyan]%}%c%{$reset_color%}"
PROMPT+=' $(kube_ps1) '
#PROMPT+=' $(git_prompt_info)'


ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
KUBE_PS1_PREFIX="("
KUBE_PS1_SUFFIX=")"
KUBE_PS1_SYMBOL_DEFAULT=""
KUBE_PS1_CTX_COLOR="red"
KUBE_PS1_NS_COLOR="red"
KUBE_PS1_BG_COLOR=""
KUBE_PS1_DIVIDER=''
KUBE_PS1_SEPARATOR=''
KUBE_PS1_NS_ENABLE=false
