vim.filetype.add({ extension = { gotmpl = 'gotmpl' } })

return {
    {
	"neovim/nvim-lspconfig",
	config = function()
	    -- 1. Configure diagnostics globally
	    vim.diagnostic.config({    
		virtual_text = {
		    spacing = 4,
		    severity_sort = true
		}
	    })

	    -- 2. Create the keymap on LspAttach
	    local lsp_group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true })
	    vim.api.nvim_create_autocmd('LspAttach', {
		group = lsp_group,
		callback = function(ev)
		    local opts = { buffer = ev.buf, silent = true, desc = 'Go to Definition' }
		    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		end
	    })

	    -- 2b. Add an autocommand for Go files to auto-format and organize imports on save
	    vim.api.nvim_create_autocmd("BufWritePre", {
		group = lsp_group,
		pattern = "*.go",
		callback = function()
		    local params = vim.lsp.util.make_range_params()
		    params.context = {only = {"source.organizeImports"}}
		    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
		    for _, res in pairs(result or {}) do
			for _, r in pairs(res.result or {}) do
			    if r.edit then vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
			    else vim.lsp.buf.execute_command(r.command) end
			end
		    end
		    vim.lsp.buf.format({async = false})
		end
	    })

	    -- 2c. Add an autocommand for Rust files to format code on save (rustfmt)
	    vim.api.nvim_create_autocmd("BufWritePre", {
		group = lsp_group,
		pattern = "*.rs",
		callback = function()
		    vim.lsp.buf.format({ async = false })
		end
	    })

	    -- 3. Set global capabilities (Blink recommends doing this via vim.lsp.config)
	    local capabilities = require('blink.cmp').get_lsp_capabilities()
	    vim.lsp.config('*', { capabilities = capabilities })

	    -- 3b. Configure server-specific settings natively via vim.lsp.config
	    vim.lsp.config('gopls', {
		cmd = { vim.fn.expand("$HOME") .. "/go/bin/gopls" },
		settings = {
                    gopls = {
                        completeUnimported = true,
                        usePlaceholders = true,
                        analyses = { unusedparams = true },
                        staticcheck = true,
                    },
                },
            })

            -- 3c. Configure Rust Analyzer settings natively via vim.lsp.config
            vim.lsp.config('rust_analyzer', {
                settings = {
                    ['rust-analyzer'] = {
                        cargo = {
                            allFeatures = true, -- Auto-load features from Cargo.toml
                        },
                        checkOnSave = {
                            command = "clippy", -- Replaces default 'cargo check' with deep clippy linting
                        },
                    },
                },
            })

            -- 4. Enable your servers natively without require('lspconfig')
            vim.lsp.enable({ 'lua_ls', 'ts_ls', 'gopls', 'rust_analyzer' })
        end
    }
}

