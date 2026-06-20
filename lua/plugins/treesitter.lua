return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
	local configs = require("nvim-treesitter")
	configs.setup({
	    highlight = { enable = true },
	    indent = { enable = true },
	    autotag = { enable = true },
	    auto_install = true,
	})

	configs.install({
	    "c", 
	    "lua", 
	    "vim", 
	    "vimdoc", 
	    "query", 
	    "markdown", 
	    "markdown_inline",
	    "python",
	    "javascript",
	    "typescript",
	    "tsx",
	    "html",
	    "css"
	})

    end
}
