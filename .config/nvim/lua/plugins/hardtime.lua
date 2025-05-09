local custom_levels = {
  HARDTIME = vim.log.levels.WARN + 1, -- Assign a unique value
}

vim.api.nvim_set_hl(0, "NotifyHARDTIMEBorder", { fg = "#e9bcb3" })
vim.api.nvim_set_hl(0, "NotifyHARDTIMEIcon", { fg = "#e9bcb3" })
vim.api.nvim_set_hl(0, "NotifyHARDTIMETitle", { fg = "#e9bcb3" })
vim.api.nvim_set_hl(0, "NotifyHARDTIMEBody", { fg = "#e9bcb3" })


-- 0. Ensure 'showmode' is enabled by default
vim.opt.showmode = true

-- 1. Define a highlight group for the hint message
vim.api.nvim_set_hl(0, "HardtimeHint", { fg = "#e9bcb3" })

-- 2. Define the combined mode and hint notification function
local function mode_hint(msg)
  -- Temporarily disable the native mode display
  local prev_showmode = vim.opt.showmode:get()
  vim.opt.showmode = false

  -- Determine the current mode
  local mode_code = vim.fn.mode()
  local mode_names = {
    i = "INSERT",
    v = "VISUAL",
    V = "VISUAL LINE",
    ["\22"] = "VISUAL BLOCK",
    c = "COMMAND",
  }
  local mode = mode_names[mode_code]

  -- Construct the display message
  local display_msg = msg
  if mode then
    -- display_msg = string.format("-- %s -- %s", mode, msg)
    display_msg = string.format("%s", msg)
  end

  -- Display the message using vim.notify with high priority
  vim.defer_fn(function()
    vim.notify(display_msg, vim.log.levels.WARN, { title = "Hardtime Hint" })
  end, 100) -- Delay in milliseconds

  -- Restore the original 'showmode' setting shortly after
  vim.defer_fn(function()
    vim.opt.showmode = prev_showmode
  end, 1000)
end

return {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
        callback = mode_hint,
        disabled_filetypes = { "netrw", "lazy", "mason", "undotree", "qf", "fugitive", "trouble", "help", "harpoon" },
        disable_mouse = false,
        hints = {
            ["Vgg y"] = {
                message = function()
                    return "Use <leader>ygg instead of Vgg<leader>y"
                end,
                length = 5,
            },
            ["d[tTfF].i"] = {
                message = function(keys)
                    return "Consider using c" .. keys:sub(2, 3) .. " instead of " .. keys
                end,
                length = 4,
            },
            ["j{2,}"] = {
                message = function()
                    return "Try using '5j' or 'Ctrl-d' for faster navigation."
                end,
                length = 2,
            },
            ["k{2,}"] = {
                message = function()
                    return "Consider '5k' or 'Ctrl-u' to move up more efficiently."
                end,
                length = 2,
            },
            ["d[eEwW]i"] = {
                message = function(keys)
                    return "Using 'ce' might be more effective than " .. keys
                end,
                length = 2,
            },
            ["<Up>"] = {
                message = function()
                    return "In insert mode, use Ctrl-o + k to move up without leaving insert mode."
                end,
                length = 1,
            },
            ["<Down>"] = {
                message = function()
                    return "In insert mode, use Ctrl-o + j to move down without leaving insert mode."
                end,
                length = 1,
            },
            ["<Left>"] = {
                message = function()
                    return "In insert mode, use Ctrl-o + h to move left without leaving insert mode."
                end,
                length = 1,
            },
            ["<Right>"] = {
                message = function()
                    return "In insert mode, use Ctrl-o + l to move right without leaving insert mode."
                end,
                length = 1,
            },
        },
    },
}
