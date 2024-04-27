return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        require('telescope').setup({
            defaults = {
                layout_strategy = "vertical",
                layout_config = {
                    preview_cutoff = 10,
                    preview_height = 0.7,
                    vertical = {
                        size = {
                            width = "95%",
                            height = "95%",
                        },
                    },

                },
            },
        })

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader><leader>', builtin.find_files, {})

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
