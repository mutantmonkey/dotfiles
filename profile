# default applications
export EDITOR=vim
export PAGER=less
export SUDO_EDITOR=rvim
export TERMINAL=termite
export VISUAL=vim

# XDG directory standard
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export ANSIBLE_CONFIG="$XDG_CONFIG_HOME/ansible/ansible.cfg"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch/notmuchrc"
export TASKDATA="$XDG_DATA_HOME/task"
export TASKRC="$XDG_CONFIG_HOME/task/taskrc"

# less config
export LESS="-R -iMx4"
export LESSHISTFILE=-
