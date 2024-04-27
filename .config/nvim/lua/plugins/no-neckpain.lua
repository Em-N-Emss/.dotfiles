return {
    {
        "shortcuts/no-neck-pain.nvim",
        config = function ()
            require("no-neck-pain").setup({
                vim.keymap.set("n", "<leader>nn", "<cmd>NoNeckPain<CR>"),
                buffers = {
                    colors = {
                        blend = 0.9,
                    },
                    wo = {
                        fillchars = "eob: ", -- Permet d'enlever les "~" à la fin du buffer
                    },
                },
            })
        end
    },
    -- Markdown plugin
    {
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },

		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
}
