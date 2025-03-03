return {
    "ThePrimeagen/harpoon",
    enabled = true,
    branch = "harpoon2",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },

    keys = function()
        local harpoon = require("harpoon")
        local conf = require("telescope.config").values

        local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
            end

            require("telescope.pickers").new({}, {
                    prompt_title = "Harpoon",
                    finder = require("telescope.finders").new_table({
                        results = file_paths,
                    }),
                    previewer = conf.file_previewer({}),
                    sorter = conf.generic_sorter({}),
                }):find()
        end
        vim.keymap.set("n", "<leader>A", function() harpoon:list():prepend() end)
        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
        vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
        vim.keymap.set("n", "<leader>ph", function() toggle_telescope(harpoon:list()) end)


        vim.keymap.set("n", "<C-H>", function() harpoon:list():select(1) end)
        vim.keymap.set("n", "<C-T>", function() harpoon:list():select(2) end)
        vim.keymap.set("n", "<C-N>", function() harpoon:list():select(3) end)
        vim.keymap.set("n", "<C-S>", function() harpoon:list():select(4) end)

        vim.keymap.set("n", "<leader><C-H>", function() harpoon:list():replace_at(1) end)
        vim.keymap.set("n", "<leader><C-T>", function() harpoon:list():replace_at(2) end)
        vim.keymap.set("n", "<leader><C-N>", function() harpoon:list():replace_at(3) end)
        vim.keymap.set("n", "<leader><C-S>", function() harpoon:list():replace_at(4) end)

        vim.keymap.set("n", "<S-H>", function() harpoon:list():prev() end)
        vim.keymap.set("n", "<S-L>", function() harpoon:list():next() end)
    end,

    opts = function(_, opts)
        opts.settings = {
            save_on_toggle = false,
            sync_on_ui_close = false,
            save_on_change = true,
            enter_on_sendcmd = false,
            tmux_autoclose_windows = false,
            excluded_filetypes = { "harpoon", "alpha", "dashboard", "gitcommit" },
            mark_branch = false,
            key = function()
                return vim.loop.cwd()
            end,
        }
    end,

    config = function(_, opts)
        require("harpoon").setup(opts)
    end,
}
