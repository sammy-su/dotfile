alias ls="ls --color"
alias ll="ls -l"
alias la="ls -A"
alias topu="top -u ${USER}"
alias dud="du -hd"

export TERM='xterm-256color'

autoload -U colors && colors
PS1="%{$fg[yellow]%}%n%{$reset_color%}@%{$fg[cyan]%}%m%{$reset_color%}:%{$fg[red]%}%~%{$reset_color%}%{$fg[green]%}$%{$reset_color%} "

SAVEHIST=8192
HISTSIZE=8192
HISTFILE=~/.zsh_history
setopt append_history           # append
setopt hist_ignore_all_dups     # no duplicate
setopt hist_reduce_blanks       # trim blanks
setopt inc_append_history       # add commands as they are typed, don't wait until shell exit 
setopt share_history            # share hist between sessions
setopt hist_verify

##
## Vcs info
###
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn hg
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats "%{$fg[yellow]%}%c%{$fg[green]%}%u%{$reset_color%} [%{$fg[cyan]%}%b%{$reset_color%}] %{$fg[yellow]%}%s%{$reset_color%}"
precmd() {  # run before each prompt
  vcs_info
}

setopt prompt_subst
RPROMPT='${vcs_info_msg_0_}'

bindkey '\e[1;5C' forward-word  # C-Right
bindkey '\e[1;5D' backward-word # C-Left

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*:default' menu 'select=0'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*:*:vim:*:*files' ignored-patterns '*.pyc'
autoload -Uz compinit
compinit

rationalise-dot() {
    if [[ $LBUFFER = *..  ]]; then
        LBUFFER+=/..
    else
        LBUFFER+=.
    fi
}
zle -N rationalise-dot
bindkey . rationalise-dot

set -g default-command /bin/zsh
