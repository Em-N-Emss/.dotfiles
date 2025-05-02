-- Place this at the top of your init.lua, *before* any plugin setups
local orig_notify = vim.notify
vim.notify = function(msg, level, opts)
  if opts and opts.title == "Codeium" then
    -- swallow Codeium notifications
    return
  end
  -- otherwise, call the original notify
  return orig_notify(msg, level, opts)
end

require("config.options")
require("config.autocmds")
require("config.keymaps")
require("config.lazy")

-- Récupérer la branche Git dynamiquement
local function git_branch()
    local handle = io.popen("git rev-parse --abbrev-ref HEAD 2>/dev/null")
    if not handle then
        return "" -- Return si aucune branche n'est trouvée
    end

    local branch = handle:read("*a") or ""
    handle:close()

    branch = branch:gsub("%s+", "") -- Enleve les espaces dans la branche
    return branch ~= "" and "[" .. branch .. "]" or ""
end


-- Function pour avoir le Codeium status
local function codeium_status()
    local ok, status_string = pcall(require, 'codeium.virtual_text')
    if ok and status_string then
        return "%{v:lua.require('codeium.virtual_text').status_string() == 0 ? '' : v:lua.require('codeium.virtual_text').status_string()}"    end
    return ""
end

-- Customisation de la statusline
local function statusline()
    local branch = git_branch()
    local file_name = " %f"
    local modified = "%{&readonly ? ' [RO]' : &modified ? ' [+]' : ''}"
    local align_right = "%="
    local fileencoding = "%{&fileencoding?&fileencoding:&encoding} "
    local fileformat = "[%{&fileformat}] "
    local filetype = "%y "
    local codeium = codeium_status()
    local percentage = "%p%% "
    local linecol = " %l:%c "

    return string.format(
        "%s %s%s%s%s%s%s%s%s%s",
        file_name,
        branch,
        modified,
        align_right,
        filetype,
        fileencoding,
        fileformat,
        codeium,
        linecol,
        percentage
    )
end

-- Affiche la colonne 80 quand la ligne atteint ou dépasse 80 caractères
local function toggle_colorcolumn()
    local line = vim.api.nvim_get_current_line()
    if #line >= 80 then
        vim.opt.colorcolumn = "80"  -- Affiche la colonne de couleur
    else
        vim.opt.colorcolumn = ""    -- Désactive la colonne si la ligne est trop courte
    end
end

-- Pour que toggle_colorcolumn soit accessible globalement pour autocmds
_G.toggle_colorcolumn = toggle_colorcolumn

-- Pour que statusline soit accessible globalement pour autocmds
_G.statusline = statusline

-- Background et Foreground pour la statusline VIM sans lualine
vim.cmd("highlight StatusLine ctermbg=1f1d2e guibg=#1f1d2e")
vim.cmd("highlight StatusLine ctermfg=908caa guifg=#908caa")
vim.cmd([[highlight QuickFixLine guibg=#d3d3d3 guifg=#000000 gui=bold]])

-- Pour Netrw
vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 25
vim.g.netrw_banner = 0
