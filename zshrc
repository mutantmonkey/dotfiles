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
fpath=($HOME/.config/zsh $fpath)

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
    if [ -e $1 ]; then
        echo "Please specify the virtualenv as an argument."
        return 1
    else
        source $HOME/.local/share/virtualenv/$1/bin/activate
    fi
}

function radio {
    case "$1" in
        echofm)
            # echoFM 88,4 Feiburg, Germany
            # http://www.echo-fm.uni-freiburg.de/
            stream_url=http://xgrid04.ruf.uni-freiburg.de:8000/
            ;;
        kalx)
            # KALX-FM 90.7 Berkeley, CA
            # http://kalx.berkeley.edu/how-listen
            stream_url=http://icecast.media.berkeley.edu:8000/kalx-128.ogg
            ;;
        kaos)
            # KAOS-FM 89.3 Olympia, WA
            # http://kaosradio.org/listen/
            stream_url=http://205.134.192.90:8930/
            ;;
        kcpr)
            # KCPR-FM 91.3 San Luis Obispo, CA
            # http://kcpr.org/listen/
            #stream_url=http://129.65.35.106:8000/KCPRHIGH
            stream_url=http://129.65.35.106:8000/KCPRMP3
            ;;
        kdvs)
            # KDVS-FM 90.3 Davis, CA
            # http://kdvs.org/programming/listen-now/
            stream_url=http://169.237.101.239:8000/kdvs128vorbis
            ;;
        kpbs)
            # KPBS-FM 89.5 San Diego, CA
            stream_url=http://kpbs.streamguys.tv:80/kpbs-aac
            ;;
        ksdt)
            stream_url=http://ksdt.ucsd.edu:8000/stream
            ;;
        kvcu)
            # KVCU-AM 1190 Boulder, CO
            # http://www.radio1190.org/
            stream_url=http://radio1190.colorado.edu:8000/master.mp3
            ;;
        kvrx)
            # KVRX-FM 91.7 Austin, TX
            # http://www.kvrx.org/livestream/
            stream_url=http://tstv-stream.tsm.utexas.edu:8000/kvrx_livestream
            ;;
        morefm)
            stream_url=http://204.45.27.179:3006/
            ;;
        radioq)
            # http://www.radioq.de/hoeren/
            stream_url=http://stream.radioq.de:8000/gross.mp3
            ;;
        somafm-defcon)
            # http://somafm.com/defcon/directstreamlinks.html
            stream_url=http://uwstream3.somafm.com:6200
            ;;
        somafm-dronezone)
            # http://somafm.com/dronezone/directstreamlinks.html
            stream_url=http://uwstream2.somafm.com:8100
            ;;
        somafm-fluid)
            # http://somafm.com/fluid/directstreamlinks.html
            stream_url=http://uwstream2.somafm.com:9196
            ;;
        somafm-groovesalad)
            # http://somafm.com/groovesalad/directstreamlinks.html
            stream_url=http://uwstream2.somafm.com:3000
            ;;
        somafm-secretagent)
            # http://somafm.com/secretagent/directstreamlinks.html
            stream_url=http://xstream1.somafm.com:9010
            ;;
        somafm-spacestation)
            # http://somafm.com/spacestation/directstreamlinks.html
            stream_url=http://xstream1.somafm.com:8200
            ;;
        somafm-thetrip)
            # http://somafm.com/thetrip/directstreamlinks.html
            stream_url=http://xstream1.somafm.com:2504
            #stream_url=http://uwstream3.somafm.com:2504
            ;;
        startfm)
            stream_url=http://eteris.startfm.lt/startfm
            ;;
        wcbn)
            # WCBN-FM 88.3 Ann Arbor, MI
            # http://www.wcbn.org/
            stream_url=http://floyd.wcbn.org:8000/wcbn-hd.mp3
            ;;
        wknc)
            # WKNC-FM 88.1 Raleigh, NC
            # http://www.wknc.org/listen
            stream_url=http://wknc.sma.ncsu.edu:8000/wknchq.ogg
            ;;
        wmfo)
            # WMFO-FM 91.5 Medford, MA
            # http://www.wmfo.org/
            stream_url=http://130.64.87.48:8000/
            ;;
        wmse)
            # WMSE-FM 91.7 Milwaukee, WI
            # http://www.wmse.org/stream/
            stream_url=http://peace.str3am.com:6780
            ;;
        wrek)
            # WREK-FM 91.1 Atlanta, GA
            # https://www.wrek.org
            stream_url=http://streaming.wrek.org:8000/main/128kb.mp3
            ;;
        wuvt)
            # WUVT-FM 90.7 Blacksburg, VA
            # https://www.wuvt.vt.edu/listen-live
            stream_url=http://engine.wuvt.vt.edu:8000/wuvt-hq.ogg
            ;;
        wvtf)
            # WVTF-FM 89.1 Roanoke, VA
            stream_url=http://mp3.rev.net:8000/wvtf-64.mp3
            ;;
        wwvt)
            # WWVT-FM 89.9 Roanoke, VA (Radio IQ)
            stream_url=http://mp3.rev.net:8000/riq-64.mp3
            ;;
        wxyc)
            # WXYC-FM 89.3 Chapel Hill, NC
            # http://www.wxyc.org/listen
            stream_url=http://audio-mp3.ibiblio.org:8000/wxyc-alt.mp3
            #stream_url=http://audio-mp3.ibiblio.org:8000/wxyc.mp3
            #stream_url=http://152.46.7.128:8000/wxyc.ogg
            ;;
        yurt)
            # Hampshire College
            # http://yurt.hampshire.edu/
            stream_url=http://192.101.188.47:8000
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
        torsocks -i mpv --loop=force $stream_url
    fi
}
# }}}
