-- bootstrap lazy.nvim, LazyVim and your plugins
if vim.loader then
    vim.loader.enable()
end

_G.dd = function(...)
    require("util.debug").dump(...)
end
vim.print = _G.dd

require("config.lazy")

-- Background et Foreground pour la statusline VIM sans lualine
vim.cmd("highlight StatusLine ctermbg=1f1d2e guibg=#1f1d2e")
vim.cmd("highlight StatusLine ctermfg=908caa guifg=#908caa")
