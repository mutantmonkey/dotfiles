################################################################################
# .zshrc - ZSH configuration
#
# author: mutantmonkey <mutantmonkey@gmail.com>
################################################################################

# History {{{

HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt appendhistory
bindkey -e

# }}}


# Key bindings {{{

bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "^H" backward-delete-word

# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line

# for non RH/Debian xterm, can't hurt for RH/DEbian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line

# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line

# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix

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
USER_COLOR=$'%{\e[1;32m%}'
DIR_COLOR=$'%{\e[0;37m%}'
RESET_COLOR=$'%{\e[0;00m%}'

export PROMPT="$MAIN_COLOR($USER_COLOR%n@%m$MAIN_COLOR|$DIR_COLOR%~$MAIN_COLOR)$RESET_COLOR%# "
export PROMPT2="$MAIN_COLOR... $RESET_COLOR"

# }}}


# Variables {{{

export BROWSER=firefox
export EDITOR=vim
export PAGER=less
export LESS="-iMx4"

# ensure terminal type is set properly for color-capable terminals
if [[ "$COLORTERM" == "gnome-terminal" ]] || [[ "$COLORTERM" == "Terminal" ]] || [[ "$COLORTERM" == "roxterm" ]]; then
	# make sure $TERM is xterm-256color if the terminal supports 256 colors
	export TERM=xterm-256color
fi

if [ -n "$TMUX" ]; then
	# set $TERM for tmux
	export TERM=screen-256color
fi

# }}}


# Aliases {{{

# SSH tunnels
alias sshtunnel_home="ssh -D 4711 -N home.schwinabart.com"
alias net_connected='netstat -tuoceewp'
alias net_listening='netstat -ntulp'
alias pacs='clyde -Ss'
alias strtx='xinit & vlock'
alias tmuxa='tmux new-session -t0'

alias -g li16998='li169-98.members.linode.com'

# }}}

