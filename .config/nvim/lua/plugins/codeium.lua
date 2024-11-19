return {
    "Exafunction/codeium.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",

        "hrsh7th/nvim-cmp",

    },
    config = function()
        require("codeium").setup({
            enable_chat = true,
            workspace_root = {
                use_lsp = true,
                find_root = nil,
                paths = {
                    ".bzr",
                    ".git",
                    ".hg",
                    ".svn",
                    "_FOSSIL_",
                    "package.json",
                },
            },
            -- Optionally disable cmp source if using virtual text only

            enable_cmp_source = false,
            virtual_text = {
                enabled = true,
                manual = false,
                filetypes = {},
                default_filetype_enabled = true,
                idle_delay = 75,
                virtual_text_priority = 65535,
                map_keys = true,
                accept_fallback = nil,
                key_bindings = {
                    accept = "<C-y>",
                    accept_word = false,
                    accept_line = false,
                    clear = false,
                    next = "<C-p>",
                    prev = "<C-n>",
                }
            }

        })
    end
}
