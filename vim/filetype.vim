if exists("did_load_filetypes")
	finish
endif
"let did_load_filetypes = 1

augroup filetypedetect

au BufRead,BufNewFile /etc/nginx/conf/* set ft=nginx
au BufRead,BufNewFile *.md set ft=markdown
au BufNewFile,BufRead *.srt set ft=srt

augroup END
