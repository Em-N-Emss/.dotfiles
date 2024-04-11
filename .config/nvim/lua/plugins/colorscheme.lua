-- return {
-- 	"craftzdog/solarized-osaka.nvim",
-- 	lazy = true,
-- 	priority = 1000,
-- 	opts = function()
-- 		return {
-- 			transparent = true,
-- 		}
-- 	end,
-- }
-- return {
-- 	-- add gruvbox
-- 	{ "ellisonleao/gruvbox.nvim" },
-- }

-- rose-pine
return {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    priority = 1000,
    -- Activer seulement dans Windows Terminal
    opts = {
        disable_background = true,
        styles = {
            transparency = true, -- Mettre en com si problème de couleur contrast
            italic = false,
        },
        require("notify").setup({
            background_colour = "#000000",
        }),
    },
}
