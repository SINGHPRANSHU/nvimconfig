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

            -- 3. Set global capabilities (Blink recommends doing this via vim.lsp.config)
            local capabilities = require('blink.cmp').get_lsp_capabilities()
            vim.lsp.config('*', { capabilities = capabilities })

            -- 4. Enable your servers natively without require('lspconfig')
            vim.lsp.enable({ 'lua_ls', 'ts_ls' })
        end
    }
}

