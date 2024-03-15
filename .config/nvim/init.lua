-- bootstrap lazy.nvim, LazyVim and your plugins
if vim.loader then
    vim.loader.enable()
end

_G.dd = function(...)
    require("util.debug").dump(...)
end
vim.print = _G.dd

require("config.lazy")

-- Récupérer la branche Git
local function git_branch()
    local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")

    if string.len(branch) > 0 then
        return branch
    else
        return ""
    end
end

-- Customisation de la statusline
local function statusline()
    -- local set_color_1 = "%#PmenuSel#"

    local branch = git_branch()

    -- local set_color_2 = "%#LineNr#"

    local file_name = "%F"

    -- local modified = " %m %r "
    local modified = "%{&readonly ? ' [RO]' : &modified ? ' [+]' : ''}"

    local align_right = "%="

    local fileencoding = "%{&fileencoding?&fileencoding:&encoding} "

    local fileformat = "[%{&fileformat}] "

    local filetype = "%y "

    local percentage = "%p%% "

    local linecol = " %l:%c "

    return string.format(
        "%s %s%s%s%s%s%s%s%s",
        -- set_color_1,
        branch,
        -- set_color_2,
        file_name,
        modified,
        align_right,
        filetype,
        fileencoding,
        fileformat,
        linecol,
        percentage
    )
end

vim.opt.statusline = statusline()

-- Background et Foreground pour la statusline VIM sans lualine
vim.cmd("highlight StatusLine ctermbg=1f1d2e guibg=#1f1d2e")
vim.cmd("highlight StatusLine ctermfg=908caa guifg=#908caa")
