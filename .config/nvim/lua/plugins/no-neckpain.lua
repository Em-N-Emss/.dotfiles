return {
    {
        "shortcuts/no-neck-pain.nvim",
        config = function ()
            require("no-neck-pain").setup({
                vim.keymap.set("n", "<leader>nn", "<cmd>NoNeckPain<CR>"),
                vim.keymap.set("n", "<leader>ns", "<cmd>NoNeckPainScratchPad<CR>"),
                width = 75,
                buffers = {
                    colors = {
                        blend = 0.9,
                    },
                    wo = {
                        fillchars = "eob: ", -- Permet d'enlever les "~" à la fin du buffer
                    },
                    bo = {
                        filetype = "md"
                    },
                    scratchPad = {
                        -- fileName = string.format("no-neck-pain-%s",vim.fn.fnamemodify(vim.fn.expand("#<#:p"), ":t")),
                        location = ".scratchpad/"
                        -- pathToFile = ".scratchpad"
                    }
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
