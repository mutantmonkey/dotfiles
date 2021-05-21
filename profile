# default applications
export PAGER=less
export TERMINAL=alacritty

# use nvim as the default editor if installed; otherwise, default to vim
if [ -x /usr/bin/nvim ]; then
    export EDITOR=nvim
    export SUDO_EDITOR="nvim -Z"
    export VISUAL=nvim
else
    export EDITOR=vim
    export SUDO_EDITOR=rvim
    export VISUAL=vim
fi

# XDG directory standard
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export ANSIBLE_CONFIG="$XDG_CONFIG_HOME/ansible/ansible.cfg"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch/notmuchrc"
export TASKDATA="$XDG_DATA_HOME/task"
export TASKRC="$XDG_CONFIG_HOME/task/taskrc"
export XPRA_USER_CONF_DIRS="$XDG_CONFIG_HOME/xpra"

# less config
export LESS="-FRSXMK"
export LESSHISTFILE=-

export GOPATH="$HOME/go"
export PATH="$PATH:$HOME/bin"

export WORMHOLE_TRANSIT_RELAY=wss://relay.magic-wormhole.io/v1
