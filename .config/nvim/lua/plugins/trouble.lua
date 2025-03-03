return {
    "folke/trouble.nvim",
    opts = {
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
            end,
        },
        {
            "[t",
            function()
                require("trouble").next({ skip_groups = true, jump = true })
            end,
        },
        {
            "]t",
            function()
                require("trouble").prev({ skip_groups = true, jump = true })
            end,
        },
    },
}
