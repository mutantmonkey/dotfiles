let $VIMHOME="$XDG_CONFIG_HOME/vim"
set runtimepath=$XDG_CONFIG_HOME/vim,/usr/share/vim/vimfiles,$VIMRUNTIME
source $VIMHOME/vimrc

let g:vimwiki_list = [{ 'path': '~/vimwiki/', 'syntax': 'markdown' }]
