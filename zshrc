################################################################################
# .zshrc - ZSH configuration
#
# author: mutantmonkey <mutantmonkey@mutantmonkey.in>
################################################################################

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
alias kismet="TERM=xterm-color kismet"
alias pacs='pacman -Ss'
alias strtx='startx & vlock'
alias mplayer='mpv'

# Git aliases
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gits="git status -sb"

# Live media streams {{{
function tv {
    RTMP_CACHE=1024
    MMS_CACHE=$RTMP_CACHE

    case "$1" in
        france24)
            rtmpdump -v -r rtmp://stream2.france24.yacast.net/france24_live/en\
                -a france24_live/en \
                -W http://www.france24.com/en/sites/all/modules/maison/aef_player/flash/player.swf\
                -p http://www.france24.com/en/aef_player_popup/france24_player\
                -y f24_liveen | mpv -framedrop -cache $RTMP_CACHE -
            ;;
        rt)
            rtmpdump -v -r rtmp://fms5.visionip.tv/live -a live \
                -W http://rt.com/s/swf/player5.4.viral.swf \
                -p http://rt.com/on-air/ -y RT_3 |\
                mpv -framedrop -cache $RTMP_CACHE -
            ;;
        skynews)
            mpv -cache $MMS_CACHE \
                mms://live1.wm.skynews.servecast.net/skynews_wmlz_live300k
            ;;
        *)
            echo "Please enter a supported station."
            return 1
            ;;
    esac
}

function radio {
    case "$1" in
        kpbs)
            streamurl=http://kpbs.streamguys.tv:80/kpbs-aac
            ;;
        echofm)
            streamurl=http://xgrid04.ruf.uni-freiburg.de:8000/
            ;;
        morefm)
            streamurl=http://204.45.27.179:3006/
            ;;
        radioq)
            streamurl=http://stream.radioq.de:8000/gross.mp3
            ;;
        startfm)
            streamurl=http://eteris.startfm.lt/startfm
            ;;
        wuvt)
            streamurl=http://engine.wuvt.vt.edu:8000/wuvt-hq.ogg
            ;;
        wvtf)
            streamurl=http://mp3.rev.net:8000/wvtf-64.mp3
            ;;
        wwvt)
            streamurl=http://mp3.rev.net:8000/riq-64.mp3
            ;;
        *)
            echo "Please enter a supported station."
            return 1
            ;;
    esac

    mpc clear
    mpc add $streamurl
    mpc play
}
# }}}
# }}}
