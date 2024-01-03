-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local discipline = require("dylan.discipline")

discipline.jerigros()

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

--- Le Saint-Graal de VIM : L'AUTOCOMPLETION DE ENTRER A TAB
keymap.set("i", "<Tab>", "<C-n>", opts)

--- Copier-Coler dans le système
keymap.set({ "n", "v" }, "<leader>y", [["+y]]) -- Copier ce qui est surligné
keymap.set("n", "<leader>Y", [["+Y]]) -- Copier la ligne
keymap.set("x", "<leader>p", [["_dP]]) -- Coupe la partie surlignée et colle ce qu'il y avait dans le presse-papier avant le curseur en mode visuel
keymap.set({ "n", "v" }, "<leader>d", [["_d]]) -- Coupe (une ou plusieurs lignes) SANS mettre dans le presse-papier système
keymap.set("n", "x", '"_x"') -- Coupe tout ce qui est selectionné et non un seul caractère

--- Tu croyais que j'blaguais Nono ?
keymap.set("i", "<C-c", "<Esc>") -- Quitte l'insertion pour revenir au mode normal

--- Incrémenter/Décrémenter une valeur
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

--- Supprime un mot en arrière
keymap.set("n", "dw", 'vb"_d')

--- Selectionne tout le texte
keymap.set("n", "<C-a>", "gg<S-v>G")

--- Désactivation de la continuité en insertion
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts) --Version en dessous
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts) --Version au dessus

--- Jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-- Gestion des onglets
keymap.set("n", "te", ":tabedit")
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)

-- Diviser la fenêtre courante
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-- Déplacement de fenêtre en fenêtre
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Ajuster la fenêtre
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-- Diagnostics
keymap.set("n", "<C-j>", function()
  vim.diagnostic.goto_next()
end, opts)

keymap.set("n", "<leader>r", function()
  require("dylan.utils").replaceHexWithHSL()
end)
