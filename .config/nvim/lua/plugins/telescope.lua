return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        require('telescope').setup({
            defaults = {
                preview = {
                    enable = true,
                    hide_on_startup = true,
                },
                layout_config = {
                    preview_width = 0.6,
                },
                mappings = {
                    i = {
                        ["<C-o>"] = require('telescope.actions.layout').toggle_preview
                    },
                    n = {
                        ["<C-o>"] = require('telescope.actions.layout').toggle_preview
                    },
                },
            },
        })

        -- Pour utiliser git_worktree
        local git_worktree = require('telescope')
        git_worktree.load_extension("git_worktree")

        vim.keymap.set("n", "<leader>pt", function()
             git_worktree.extensions.git_worktree.git_worktrees()
        end)
        vim.keymap.set("n", "<leader>pT",  function()
            git_worktree.extensions.git_worktree.create_git_worktree()
        end)

        -- Fonction builtin de Telescope
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})

        vim.keymap.set('n', '<leader>pg', builtin.git_files, {})

        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)

        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)

        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)

        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

        vim.keymap.set('n', '<leader>po', function()
            local SecondBrain = "~/Second-Brain/"
            builtin.find_files({cwd = SecondBrain})
        end)
    end
}
