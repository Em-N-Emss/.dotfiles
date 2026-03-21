return {
    {
        "shortcuts/no-neck-pain.nvim",
        config = function ()
            require("no-neck-pain").setup({
                vim.keymap.set("n", "<leader>nn", "<cmd>NoNeckPain<CR>"),
                vim.keymap.set("n", "<leader>ns", "<cmd>NoNeckPainScratchPad<CR>"),
                width = 75,
                buffers = {
                    colors = {
                        blend = 0.9,
                    },
                    wo = {
                        fillchars = "eob: ", -- Permet d'enlever les "~" à la fin du buffer
                    },
                    bo = {
                        filetype = "md"
                    },
                    scratchPad = {
                        -- fileName = string.format("no-neck-pain-%s",vim.fn.fnamemodify(vim.fn.expand("#<#:p"), ":t")),
                        location = ".scratchpad/"
                        -- pathToFile = ".scratchpad"
                    }
                },
            })
        end
    },
    -- Markdown plugin
    {
        'brianhuster/live-preview.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim',
        },
    },

    -- For focus on markdown
    {
        "folke/twilight.nvim",
        -- require("twilight").setup(){
        --     dimming = {
        --         alpha = 0.25,
        --         color = { "Normal", "#ffffff" },
        --     },
        --     context = 10,
        --     treesitter = true,
        --     expand = { "function", "method", "table", "if_statement" },
        -- }

        opts ={
            dimming = {
                alpha = 0.25,
                color = { "Normal", "#ffffff" },
                inactive = false
            },
            context = 10,
            treesitter = true,
            expand = { "function", "method", "table", "if_statement" },
        },
    },

    {
        "folke/zen-mode.nvim",
        dependencies = { "folke/twilight.nvim" },
        event = "VeryLazy",
        config = function()
            require("zen-mode").setup({
                window = {
                    width = 80,
                    backdrop = 1,
                    options = {}
                },
                plugins = {
                    twilight = { enabled = false },
                },
                on_open = function()
                    -- Vérifie si la quickfix list était ouverte avant zen-mode
                    local qf_open = false
                    for _, win in ipairs(vim.fn.getwininfo()) do
                        if win.quickfix == 1 then
                            qf_open = true
                            break
                        end
                    end
                    require("rose-pine").setup({
                        disable_background = true,
                        styles = { transparency = true, italic = false },
                        palette = {
                            main = {
                                love = "#c85d78",
                                gold = "#e9bcb3",
                                pine = "#5b7b8b",
                            },
                        },
                        highlight_groups = {
                            TreesitterContext = { bg = 'NONE' },
                            TreesitterContextLineNumber = { bg = 'NONE' },
                        }
                    })
                    vim.cmd.colorscheme("rose-pine")
                    vim.cmd("highlight StatusLine ctermbg=1f1d2e guibg=#1f1d2e")
                    vim.cmd("highlight StatusLine ctermfg=908caa guifg=#908caa")
                    vim.cmd([[highlight QuickFixLine guibg=#d3d3d3 guifg=#000000 gui=bold]])
                    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#d3d3d3" })

                    vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "#1f1d2e" })
                    vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "#1f1d2e" })
                    vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "#1f1d2e" })
                    vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "#1f1d2e" })
                    vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "#1f1d2e" })
                    vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "#1f1d2e" })

                    -- Réouvre la quickfix list si elle était ouverte
                    if qf_open then
                        vim.schedule(function()
                            vim.cmd("copen")
                        end)
                    end
                end,
                on_close = function()
                    require("rose-pine").setup({
                        disable_background = true,
                        styles = { transparency = false, italic = false },
                        palette = {
                            main = {
                                love = "#c85d78",
                                gold = "#e9bcb3",
                                pine = "#5b7b8b",
                            },
                        },
                        highlight_groups = {
                            TreesitterContext = { bg = 'NONE' },
                            TreesitterContextLineNumber = { bg = 'NONE' },
                        }
                    })
                    vim.cmd.colorscheme("rose-pine")
                end,
            })

            -- Zen Markdown v.1 without twilight
            vim.keymap.set("n", "<leader>zm", function()
                require("zen-mode").toggle()
                vim.wo.number = true
                vim.wo.rnu = true
            end)
            -- Zen Markdown v.2
            vim.keymap.set("n", "<leader>zM", function()
                require("zen-mode").setup {
                    window = {
                        width = 83,
                        options = { }
                    },
                }
                require("zen-mode").toggle()
                vim.wo.number = false
                vim.wo.rnu = false
                vim.opt.colorcolumn = "0"
            end)
        end
    }

 --    {
	-- 	"iamcco/markdown-preview.nvim",
	-- 	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	-- 	ft = { "markdown" },
	-- 	build = function()
	-- 		vim.fn["mkdp#util#install"]()
	-- 	end,
	-- },
    -- {
    --     'MeanderingProgrammer/render-markdown.nvim',
    --     dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you prefer nvim-web-devicons
    --     ---@module 'render-markdown'
    --     ---@type render.md.UserConfig
    --     opts = {
    --         render_modes = { "n", "c", "t" },
    --         heading = {
    --             signs = false,
    --             position = "inline",
    --             icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
    --         },
    --         sign = { enabled = false },
    --     },
    -- },
}
