require("config.options")
require("config.autocmds")
require("config.keymaps")
require("config.lazy")

-- Récupérer la branche Git
local function git_branch()
    local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")

    if string.len(branch) > 0 then
        return "[" .. branch .. "]"
    else
        return ""
    end
end

-- Customisation de la statusline
local function statusline()
    -- local set_color_1 = "%#PmenuSel#"

    local branch = git_branch()

    -- local set_color_2 = "%#LineNr#"

    local file_name = " %f"

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
        file_name,
        branch,
        -- set_color_2,
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
vim.cmd([[highlight QuickFixLine guibg=grey guifg=#000000]])


-- vim.cmd [[
--   highlight! Pmenu guibg=#242424 guifg=#e0def4   " Darker grey background for completion
--   highlight! PmenuSel guibg=#303030 guifg=#ffffff " Slightly lighter grey for selected item in completion
-- ]]


-- Pour Netrw
vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 25
