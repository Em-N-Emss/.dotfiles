local augroup = vim.api.nvim_create_augroup
local EmGroup = augroup('Em', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

-- Désactive l'action de "Coller" quand on est pas dans Insert Mode
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "set nopaste",
})

-- Treesiter
vim.filetype.add({
    extension = {
        templ = 'templ',
    }
})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',

    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',

            timeout = 40,
        })
    end,
})

autocmd({"BufWritePre"}, {
    group = EmGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})


-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "jsonc", "markdown" },
	callback = function()
		vim.opt.conceallevel = 0
	end,
})

autocmd('LspAttach', {
    group = EmGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    end
})
