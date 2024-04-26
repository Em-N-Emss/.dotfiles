return {
	-- add symbols-outline
	{
		"shortcuts/no-neck-pain.nvim",
		cmd = "NoNeckPain",
		keys = { { "<leader>nn", "<cmd>NoNeckPain<cr>", desc = "[N]o [N]eckpain" } },
		opts = {},
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
