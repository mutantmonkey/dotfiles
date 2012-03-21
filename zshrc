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

## for rxvt
#bindkey "\e[8~" end-of-line
#bindkey "\e[7~" beginning-of-line

## for non RH/Debian xterm, can't hurt for RH/DEbian xterm
#bindkey "\eOH" beginning-of-line
#bindkey "\eOF" end-of-line

## for freebsd console
#bindkey "\e[H" beginning-of-line
#bindkey "\e[F" end-of-line

## completion in the middle of a line
#bindkey '^i' expand-or-complete-prefix

# }}}

# Auto completion {{{

zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on succesive tab press
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
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
cdpath=(.)

# use /etc/hosts and known_hosts for hostname completion
[ -r /etc/ssh/ssh_known_hosts ] && _global_ssh_hosts=(${${${${(f)"$(</etc/ssh/ssh_known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r ~/.ssh/known_hosts ] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r /etc/hosts ] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()

# }}}

# Terminal colors {{{

# directory colors
if [ "$TERM" != "dumb" ]; then
    # directory colors
    eval `dircolors -b`
    alias ls='ls --color=auto -F'
    alias dir='ls --color=auto -F'

    # grep color
    export GREP_COLOR="1;33"
    alias grep='grep --color=auto'
fi

# Zenburn colors for console
if [ "$TERM" = "linux" ]; then
    echo -en "\e]P03f3f3f" # zenburn black (normal black)
    echo -en "\e]P8709080" # bright-black  (darkgrey)
    echo -en "\e]P1705050" # red           (darkred)
    echo -en "\e]P9dca3a3" # bright-red    (red)
    echo -en "\e]P260b48a" # green         (darkgreen)
    echo -en "\e]PAc3bf9f" # bright-green  (green)
    echo -en "\e]P3dfaf8f" # yellow        (brown)
    echo -en "\e]PBf0dfaf" # bright-yellow (yellow)
    echo -en "\e]P4506070" # blue          (darkblue)
    echo -en "\e]PC94bff3" # bright-blue   (blue)
    echo -en "\e]P5dc8cc3" # purple        (darkmagenta)
    echo -en "\e]PDec93d3" # bright-purple (magenta)
    echo -en "\e]P68cd0d3" # cyan          (darkcyan)
    echo -en "\e]PE93e0e3" # bright-cyan   (cyan)
    echo -en "\e]P7dcdccc" # white         (lightgrey)
    echo -en "\e]PFffffff" # bright-white  (white)
fi

# }}}

# Window title {{{

# user@host:dir
case "$TERM" in
    xterm*|rxvt*)
        precmd () {print -Pn "\e]0;%n@%m: %~\a"}
    ;;
esac

# }}}

# Prompt {{{

MAIN_COLOR=$'%{\e[1;30m%}'
USER_COLOR=$'%{\e[1;34m%}'
DIR_COLOR=$'%{\e[0;37m%}'
RESET_COLOR=$'%{\e[0;00m%}'

export PROMPT="$MAIN_COLOR($USER_COLOR%n@%m$MAIN_COLOR|$DIR_COLOR%~$MAIN_COLOR)$RESET_COLOR%# "
export PROMPT2="$MAIN_COLOR... $RESET_COLOR"

# }}}

# Variables {{{
export BROWSER=firefox
export EDITOR=vim
export PAGER=less
export LESS="-R -iMx4"

# Java settings
export _JAVA_AWT_WM_NONREPARENTING=1
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=lcd_vrgb -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"

# }}}

# Aliases {{{

alias flvplay="quvi --exec 'mplayer %u'"
alias net_connected='sudo lsof -i -n | grep -v LISTEN'
alias net_listening='sudo lsof -i -n | grep LISTEN'
alias mpdstream='mplayer --prefer-ipv4 http://localhost:8000'
alias pacs='pacman -Ss'
alias strtx='startx & vlock'
alias vless='/usr/share/vim/vim73/macros/less.sh'

alias canto="canto -D $XDG_CONFIG_HOME/canto/ -L $XDG_DATA_HOME/canto/log -F $XDG_DATA_HOME/canto/feeds/ -S $XDG_CONFIG_HOME/canto/scripts/"

# Live media streams
RTMP_CACHE=1024
MMS_CACHE=$RTMP_CACHE

# Video
alias abc24au="mplayer -framedrop -cache $RTMP_CACHE rtmp://cp103653.live.edgefcs.net/live/international_medium@36382"
alias alj="mplayer -framedrop -cache $RTMP_CACHE rtmp://aljazeeraflashlivefs.fplive.net/aljazeeraflashlive-live/aljazeera_eng_med"
alias cspan1="mplayer -framedrop -cache $RTMP_CACHE rtmp://cp82346.live.edgefcs.net:1935/live/CSPAN1@14845"
alias cspan2="mplayer -framedrop -cache $RTMP_CACHE rtmp://cp82347.live.edgefcs.net:1935/live/CSPAN2@14846"
alias cspan3="mplayer -framedrop -cache $RTMP_CACHE rtmp://cp82348.live.edgefcs.net:1935/live/CSPAN3@14847"
alias france24="rtmpdump -v -r rtmp://stream2.france24.yacast.net/france24_live/en -a france24_live/en -W http://www.france24.com/en/sites/all/modules/maison/aef_player/flash/player.swf -p http://www.france24.com/en/aef_player_popup/france24_player -y f24_liveen | mplayer -framedrop -cache $RTMP_CACHE -"
alias rt="rtmpdump -v -r rtmp://fms5.visionip.tv/live -a live -W http://rt.com/s/swf/player5.4.viral.swf -p http://rt.com/on-air/ -y RT_3 | mplayer -framedrop -cache $RTMP_CACHE -"
alias skynews="mplayer -cache $MMS_CACHE mms://live1.wm.skynews.servecast.net/skynews_wmlz_live300k"

# Radio
alias echofm='mplayer http://xgrid04.ruf.uni-freiburg.de:8000/'
alias radioq='mplayer http://stream.radioq.de:8000/gross.mp3'
alias startfm='mplayer http://eteris.startfm.lt/startfm'
alias wuvt='mplayer http://engine.collegemedia.vt.edu:8000/wuvt.ogg'
alias wvtf='mplayer http://mp3.rev.net:8000/wvtf-64.mp3'
alias wwvt='mplayer http://mp3.rev.net:8000/riq-64.mp3'

# }}}
