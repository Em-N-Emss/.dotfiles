return {
    "epwalsh/obsidian.nvim",
    version = "*",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
    },

    config = function ()
        require("obsidian").setup({
            workspaces = {
                {
                    name = "Second-Brain",
                    path = "~/Second-Brain",
                },
            },
            overrides = {
                notes_subdir = "Inbox",
            },
            new_notes_location = "notes_subdir",

            disable_frontmatter = true,
            templates = {
                subdir = "Archive/Templates",
                date_format = "%Y%m%d",
                time_format = "%H%M",
            },
            -- Ouvre les URLs dans le navigateur
            follow_url_func = function(url)
                vim.fn.jobstart({"xdg-open", url})  -- linux/WSL
            end,
            mappings = {
                -- overrides the 'gf' mapping to work on markdown/wiki links within your vault
                ["gd"] = {
                    action = function()
                        return require("obsidian").util.gf_passthrough()
                    end,
                    opts = { noremap = false, expr = true, buffer = true },
                },
            },
            completion = {
                nvim_cmp = true,
                min_chars = 2,
            },
        })
    end
}
