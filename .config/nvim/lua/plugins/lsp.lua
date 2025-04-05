return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",

    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "clangd",
                "marksman",
            },
            handlers = {
                function(server_name) -- default handler (optional)

                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()

                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }

                    }
                end,

            }
        })

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            window = {
                documentation = cmp.config.window.bordered(),
            },
            -- experimental = {
            --     ghost_text = true, -- afin d'avoir la completion affiché en texte
            -- },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                ['<C-d>'] = cmp.mapping.scroll_docs(4),
                ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                ['<C-l>'] = cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Insert, select = true }), -- Insère la completion et bouge le curseur sur la droite
                ['<A-l>'] = cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Replace, select = false}), -- Remplace le texte adjacent avec l'item choisi dans l'autocompletion, il faut mettre le curseur sur ce dernier pour que ça marche
                ['<C-b>'] = cmp.mapping.complete(),
                ['<A-n>'] = cmp.mapping.close(),
                ['<Tab>'] = cmp.config.disable, -- lire :h ins-completion pour comprendre pourquoi j'ai désactiver Tab

            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'path'},
                { name = 'luasnip' }, -- Pour luasnip
                -- { name = 'codeium' }, -- Pour utiliser codeium
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,

            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
