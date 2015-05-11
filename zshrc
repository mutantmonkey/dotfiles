################################################################################
# .zshrc - ZSH configuration
################################################################################

# enable autocd mode to save precious keystrokes
setopt autocd

# History {{{
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt appendhistory
# }}}

# Key bindings {{{
bindkey -v

bindkey '^[[A'  vi-up-line-or-history
bindkey '^[[B'  vi-down-line-or-history
# }}}

# Auto completion {{{
fpath=($HOME/.dotfiles/zsh $fpath)

zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit

unsetopt menu_complete # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end

WORDCHARS=''

zmodload -i zsh/complist

## case-insensitive (all),partial-word and then substring completion
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
unset CASE_SENSITIVE
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' list-colors ''

# should this be in keybindings?
bindkey -M menuselect '^o' accept-and-infer-next-history

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $(whoami) -o pid,user,comm -w -w"

# disable named-directories autocompletion
#zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
#cdpath=(.)

# allow approximate
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# alias mosh to ssh completions
compdef mosh=ssh
compdef mosh4=mosh
# }}}

# Terminal colors {{{
if [ "$TERM" != "dumb" ]; then
    # directory colors
    eval $(dircolors -b)
    alias ls='ls --color=auto --group-directories-first -F'
    alias dir='ls --color=auto --group-directories-first -F'

    # grep color
    export GREP_COLOR="1;33"
    alias grep='grep --color=auto'
fi
# }}}

# Prompt {{{
MAIN_COLOR=$'%{\e[1;30m%}'
USER_COLOR=$'%{\e[1;34m%}'
DIR_COLOR=$'%{\e[0;37m%}'
RESET_COLOR=$'%{\e[0;00m%}'

export PROMPT="$MAIN_COLOR($USER_COLOR%n@%m$MAIN_COLOR|$DIR_COLOR%~$MAIN_COLOR)$RESET_COLOR%# "
export PROMPT2="$MAIN_COLOR... $RESET_COLOR"
# }}}

# Aliases {{{

# Git aliases
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gits="git status -sb"

function virtenv {
    source $HOME/.local/share/virtualenv/$1/bin/activate
}

function radio {
    case "$1" in
        echofm)
            stream_url=http://xgrid04.ruf.uni-freiburg.de:8000/
            ;;
        kpbs)
            stream_url=http://kpbs.streamguys.tv:80/kpbs-aac
            ;;
        ksdt)
            stream_url=http://ksdt.ucsd.edu:8000/stream
            ;;
        morefm)
            stream_url=http://204.45.27.179:3006/
            ;;
        radioq)
            stream_url=http://stream.radioq.de:8000/gross.mp3
            ;;
        startfm)
            stream_url=http://eteris.startfm.lt/startfm
            ;;
        wuvt)
            stream_url=http://engine.wuvt.vt.edu:8000/wuvt-hq.ogg
            ;;
        wvtf)
            stream_url=http://mp3.rev.net:8000/wvtf-64.mp3
            ;;
        wwvt)
            stream_url=http://mp3.rev.net:8000/riq-64.mp3
            ;;
        *)
            echo "Please enter a supported station."
            return 1
            ;;
    esac

    if [ -n "$MPD_HOST" ]; then
        mpc clear
        mpc add $stream_url
        mpc play
    else
        torify mpv --loop=force $stream_url
    fi
}
# }}}
