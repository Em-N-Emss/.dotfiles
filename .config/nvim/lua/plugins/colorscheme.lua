return {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
        require("rose-pine").setup({
            disable_background = true,
            styles = {
                -- transparency = true, -- Mettre en com si problème de couleur contrast
                italic = false,
            }
        })
    vim.cmd.colorscheme("rose-pine")
    end
}

