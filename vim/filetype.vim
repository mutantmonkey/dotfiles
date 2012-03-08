if exists("did_load_filetypes")
	finish
endif

augroup filetypedetect

au BufRead,BufNewFile /etc/nginx/conf/* set ft=nginx
au BufRead,BufNewFile *.md,*.markdown   set ft=markdown
au BufNewFile,BufRead *.srt             set ft=srt

augroup END
