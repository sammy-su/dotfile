alias ls="ls --color"
alias ll="ls -l"
alias lh="ls -lh"
alias la="ls -A"
alias lf="ls --color=none | xargs -i sh -c \"echo -n '{}\t'; ls {} | wc -l\""
alias topu="top -u ${USER} -c"
alias dud="du -hd"
alias psu="pstree -u ${USER}"
alias py_kill="psu -p | grep ^python | awk -F'---' '{print \$1}' | sed 's/[^0-9]//g' | xargs -i kill {}"
alias cdw="cd ${WORK}"
alias cdd="cd ${DATA}"
alias cdv="cd ${VISION}"
alias cdt="cd ${USER_TMP}"

function sshcd() {
    ssh -x -t -t $1 "cd ${PWD}; zsh -l";
}

function condor_statistics () {
    if [[ $1 == 'GPU' ]]; then
        condor_status -constraint GPU | tail -n 5
    else
        condor_status -constraint InMastodon | tail -n 5
    fi
}
function condor_jobs () {
    if [[ $1 == 'jobs' ]]; then
        condor_q -submitter ycsu | grep held | awk '{print $1}' | paste -s -d"+" | bc;
    elif [[ $1 == 'list' ]]; then
        condor_q -submitter ycsu | grep held;
    elif [[ $1 == 'submitter' ]]; then
        condor_q -submitter ycsu | grep 'held\|Submitter';
    else
        condor_q -submitter ycsu | grep held | awk '{print $9}' | paste -s -d"+" | bc;
    fi
}

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
#setopt share_history            # share hist between sessions
setopt hist_verify
setopt auto_param_slash
setopt complete_in_word

DIRSTACKFILE="$HOME/.cache/zsh/dirs"
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
    dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
fi
chpwd() {
  print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}

DIRSTACKSIZE=32

setopt AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME

## Remove duplicate entries
setopt PUSHD_IGNORE_DUPS

## This reverts the +/- operators.
setopt PUSHD_MINUS

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
key[Enter]=${terminfo[kent]}

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

##
# zplug
###
source ~/.zplug/init.zsh

zplug "hlissner/zsh-autopair", defer:2
zplug "willghatch/zsh-cdr"
zplug "zsh-users/zaw"

zplug load

bindkey '^R' zaw-history
bindkey -M filterselect '^J' down-line-or-history
bindkey -M filterselect '^K' up-line-or-history

zstyle ':filter-select:highlight' matched fg=red
zstyle ':filter-select' max-lines 20 # use 10 lines for filter-select
zstyle ':filter-select' rotate-list yes # enable rotation for filter-select
zstyle ':filter-select' case-insensitive yes # enable case-insensitive search
zstyle ':filter-select' extended-search yes # see below
zstyle ':filter-select' hist-find-no-dups yes # ignore duplicates in history source

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
