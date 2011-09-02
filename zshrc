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
bindkey -e

# }}}


# Key bindings {{{

bindkey -v

bindkey '^[[A'  vi-up-line-or-history
bindkey '^[[B'  vi-down-line-or-history

#bindkey "\e[1~" beginning-of-line
#bindkey "\e[4~" end-of-line
#bindkey "\e[5~" beginning-of-history
#bindkey "\e[6~" end-of-history
#bindkey "\e[3~" delete-char
#bindkey "\e[2~" quoted-insert
#bindkey "\e[5C" forward-word
#bindkey "\eOc" emacs-forward-word
#bindkey "\e[5D" backward-word
#bindkey "\eOd" emacs-backward-word
#bindkey "\e\e[C" forward-word
#bindkey "\e\e[D" backward-word
#bindkey "^H" backward-delete-word

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
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=lcd_vrgb -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"

# }}}


# Aliases {{{

alias sshtunnel_home="ssh -D 4711 -N home.schwinabart.com"

alias net_connected='sudo netstat -tuoeewp'
alias net_listening='sudo netstat -ntulp'
alias pacs='pacman -Ss'
alias strtx='startx & vlock'
alias tmuxa='tmux new-session -t0'
alias vless='/usr/share/vim/vim73/macros/less.sh'
alias flvplay='quvi --exec "mplayer %u"'

# }}}

