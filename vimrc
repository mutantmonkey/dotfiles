" ##############################################################################
" .vimrc - Vim configuration bootstrap
" ##############################################################################

set backupdir=$XDG_CACHE_HOME/vim/backup " vim will not create this directory.
set directory=$XDG_CACHE_HOME/vim/swap " vim will not create this directory.
set runtimepath=$XDG_CONFIG_HOME/vim,$XDG_CONFIG_HOME/vim/after,/usr/share/vim/vimfiles,$VIMRUNTIME
set undodir=$XDG_CACHE_HOME/vim/undo " vim will not create this directory.
set viminfo+=n$XDG_CACHE_HOME/vim/viminfo

let $VIMHOME="$XDG_CONFIG_HOME/vim"
source $VIMHOME/vimrc

let g:vimwiki_list = [{ 'path': '~/vimwiki/', 'syntax': 'markdown' }]
