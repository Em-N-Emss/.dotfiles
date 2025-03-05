return {
    "folke/trouble.nvim",
    opts = {
        -- follow = false,
        auto_preview = false,
        win = {
            type = "split",
            -- relative = "win",
            position = "bottom",
        },
        preview = {
            scratch = false
        },
        icons = {
            indent = {
                middle = " ",
                last = " ",
                top = " ",
                ws = "│  ",
            },
        },
        modes = {
            diagnostics = {
                groups = {
                    { "filename", format = "{file_icon} {basename:Title} {count}" },

                },
            },
        },
    }, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
        {
            "<leader>t",
            function()
                require("trouble").toggle("diagnostics")
            end
        },
        {
            "[t",
            function()
                require("trouble").next({ skip_groups = true, jump = true })
            end
        },
        {
            "]t",
            function()
                require("trouble").prev({ skip_groups = true, jump = true })
            end
        },
        {
            "<C-q>", function()
                if require("trouble").is_open("diagnostics") then
                    vim.diagnostic.setqflist({ open = true })
                    require("trouble").toggle("diagnostics")
                else
                    -- Pour faire en sorte que si <C-q> est utilisé dans un autre contexte, il gardera ses commandes par defaut
                    vim.api.nvim_feedkeys(
                        vim.api.nvim_replace_termcodes("<C-q>", true, false, true), "n", true)
                end
            end
        }
    },
}
