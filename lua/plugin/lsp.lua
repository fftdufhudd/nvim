local M = {
    "https://github.com/VonHeikemen/lsp-zero.nvim",
    dependencies = {
        "https://github.com/mason-org/mason.nvim",
        "https://github.com/mason-org/mason-lspconfig.nvim",
        "https://github.com/neovim/nvim-lspconfig",
        "https://github.com/hrsh7th/cmp-nvim-lsp",
        "https://github.com/hrsh7th/nvim-cmp",
        "https://github.com/L3MON4D3/LuaSnip", -- We will use this for snippets
        "https://github.com/hrsh7th/cmp-buffer", -- Needed for the 'buffer' source
    },
    config = function()
        -- Core LSP-Zero Setup
        local lsp_zero = require('lsp-zero')
        local cmp = require('cmp')
        local capabilities = require('cmp_nvim_lsp').default_capabilities() -- REQUIRED for cmp integration

        -- 1. Setup the Language Server Keymaps on Attach
        lsp_zero.on_attach(function(client, bufnr)
                  vim.notify("Handler Attached: " .. client.name, vim.log.levels.INFO)
            local opts = {buffer = bufnr}

            -- 3. Diagnostics (Errors/Warnings)
            vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
            vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
            vim.keymap.set('n', '<leader>d', '<cmd>lua vim.diagnostic.setloclist()<cr>', opts)
            vim.keymap.set('n', '<leader>D', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
            vim.keymap.set('n', '<C-K>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)

            -- Optional: Set status line client name
            vim.b[bufnr].lsp_clients = client.name
        end)


        --- 2. CMP Configuration (Your provided block, corrected) ---

        cmp.setup({
            snippet = {
                -- REQUIRED: Use LuaSnip since it's in your dependencies
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
               ['<C-,>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
               ['<C-.>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
               ['<C-s>'] = cmp.mapping.scroll_docs(-4),
               ['<C-w>'] = cmp.mapping.scroll_docs(4),
               ['<C-Space>'] = cmp.mapping.complete(), -- MANUAL COMPLETION KEYBIND
               ['<C-e>'] = cmp.mapping.abort(),
               ['<CR>'] = cmp.mapping.confirm({ select = true }),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- Use luasnip source to match the expand function
            }, {
                { name = 'buffer' },
            })
        })

        -- 4. Mason and LSP Setup
        require("mason").setup({
            registries = {
               'github:Crashdummyy/mason-registry',
               'github:mason-org/mason-registry',
            }
         })
        require("mason-lspconfig").setup({
            ensure_installed = {
               "clangd",
               "lua_ls",
               "rust_analyzer",
               "ols",
            },
            handlers = {
                -- Use lsp-zero's default setup, but pass in the capabilities
                lsp_zero.default_setup,

                -- Custom setup function to correctly pass capabilities to all servers
                function(server_name)
                    require('lspconfig')[server_name].setup({
                        capabilities = capabilities, -- This line is crucial for cmp to work!
                        on_attach = lsp_zero.on_attach,
                    })
                end,

               ['clangd'] = function ()
                  local lspconfig = require('lspconfig')

                  lspconfig.clangd.setup({
                     capabilities = capabilities,
                     cmd = { "clangd" },
                     on_attach = lsp_zero.on_attach,
                     filetypes = { "c", "cpp", "h", "hpp" },
                     root_dir = function()
                         return require('lspconfig.util').root_pattern(
                             'compile_commands.json',
                             'compile_flags.txt',
                             '.git'  -- Check for a Git repository root as a fallback
                         )(vim.api.nvim_buf_get_current())
                        end,
                     init_options = {
                        fallbackFlags = {
                           '-std=c++20',
                           '-Wall'
                        }
                     }
                  })
               end,
               ['ols'] = function()
                  local lspconfig = require('lspconfig')

                  lspconfig.ols.setup({
                     capabilities = capabilities,
                     on_attach = lsp_zero.on_attach,
                     filetypes = {'odin'},

                     init_options = {
                        -- IMPORTANT: Path to your Odin installation root
                        collections = {
                           { name = "core", path = os.getenv('HOME') .. '/opt/odin/core' }
                        },
                        --odin_root_override = os.getenv("HOME") .. '/opt/odin',
                        enable_format = true,
                        enable_hover = true,
                        enable_snippets = true,
                     },
                  })
               end,
            },
        })

        -- Initialize LuaSnip loader
        require("luasnip.loaders.from_vscode").lazy_load()

    end,
}

return M
