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

# allow approximate
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# tab completion for PID :D
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

zstyle -e ':completion:*:(ssh|scp|ping|host|nmap|rsync):*' hosts 'reply=(
	${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) \
            	/dev/null)"}%%[#| ]*}//,/ }
	${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*}
	${=${${${${(@M)${(f)"$(<~/.ssh/config)"}:#Host *}#Host }:#*\**}:#*\?*}}
	)'

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

# Live media streams
RTMP_CACHE=1024
MMS_CACHE=$RTMP_CACHE

# Video
alias abc24au="rtmpdump -v -r rtmp://cp103653.live.edgefcs.net/live/international_medium@36382 | mplayer -cache $RTMP_CACHE -"
alias alj="rtmpdump -v -r 'rtmp://aljazeeraflashlivefs.fplive.net/aljazeeraflashlive-live/aljazeera_eng_med' | mplayer -cache $RTMP_CACHE -"
alias cspan1="rtmpdump -v -r rtmp://cp82346.live.edgefcs.net:1935/live/CSPAN1@14845 | mplayer -cache $RTMP_CACHE -"
alias france24="rtmpdump -v -r rtmp://stream2.france24.yacast.net/france24_live/en -a france24_live/en -W http://www.france24.com/en/sites/all/modules/maison/aef_player/flash/player.swf -p http://www.france24.com/en/aef_player_popup/france24_player -y f24_liveen | mplayer -cache $RTMP_CACHE -"
alias rt="rtmpdump -v -r rtmp://fms5.visionip.tv/live -a live -W http://rt.com/s/swf/player5.4.viral.swf -p http://rt.com/on-air/ -y RT_3 | mplayer -cache $RTMP_CACHE -"
alias skynews="mplayer -cache $MMS_CACHE mms://live1.wm.skynews.servecast.net/skynews_wmlz_live300k"

# Radio
alias echofm='mplayer -playlist http://xgrid04.ruf.uni-freiburg.de/echofm.m3u'
alias radioq='mplayer http://stream.radioq.de:8000/gross.mp3'
alias startfm='mplayer -playlist http://www.startfm.lt/startfm.m3u'
alias wuvt='mplayer -playlist http://www.wuvt.vt.edu/liveplayer/wuvtstream_hi.m3u'
alias wvtf='mplayer -playlist http://www.wvtf.org/images/stories/wvtf_high.m3u'
alias wwvt='mplayer -playlist http://www.wvtf.org/images/stories/riq_high.m3u'

# }}}
