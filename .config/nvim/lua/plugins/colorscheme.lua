return {

    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
        require("rose-pine").setup({
            disable_background = true,
            styles = {
                -- transparency = true, -- Mettre en com si problème de couleur contrast
                italic = false,
            },
            palette = {
                main = {
                    love = "#c85d78",   -- Error color (darker red)
                    gold = "#e9bcb3",  -- Muted gold
                    pine = "#5b7b8b",  -- Softer pine
                    -- foam = "#8bbfbb",  -- Muted foam
                },
            },
            highlight_groups = {
                TreesitterContext = { bg = 'NONE' },
                TreesitterContextLineNumber = { bg = 'NONE' },
            }
        })
        vim.cmd.colorscheme("rose-pine")
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end
}

