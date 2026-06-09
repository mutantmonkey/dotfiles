return {
    "vimwiki/vimwiki", 
    lazy = false,
    version = "*",
    init = function() 
	vim.g.vimwiki_list = {
	    {
		path = '~/vimwiki/',
		syntax = 'markdown',
		ext = 'md'
	    },
	}
    vim.g.vimwiki_global_ext = 0
    end,
}
