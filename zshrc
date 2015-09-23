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

bindkey -v
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

# create a zkbd compatible hash;
# # to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# sometimes the mapping is incorrect
# manually set the key
bindkey "\e[1~" beginning-of-line
bindkey "\e[H" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[F" end-of-line

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"   forward-char
[[ -n "${key[PageUp]}"    ]]  && bindkey  "${key[PageUp]}"  up-line-or-search 
[[ -n "${key[PageDown]}"  ]]  && bindkey  "${key[PageDown]}" down-line-or-search

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
function zle-line-init () {
    echoti smkx
}
function zle-line-finish () {
    echoti rmkx
}
zle -N zle-line-init
zle -N zle-line-finish  
