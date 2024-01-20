-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Restriction de déplacement pour maitriser VIM
-- local discipline = require("dylan.discipline")
--
-- discipline.jerigros()

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

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
keymap.set("n", "te", ":tabedit") -- Ouvre un nouvel onglet
keymap.set("n", "<tab>", ":tabnext<Return>", opts) -- Passe à l'onglet suivant
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts) -- Passe à l'onglet précédent

-- Diviser la fenêtre courante
keymap.set("n", "ss", ":split<Return>", opts) -- Division de la fenêtre horizontalement
keymap.set("n", "sv", ":vsplit<Return>", opts) -- Division de la fenêtre verticalement

-- Déplacement de fenêtre en fenêtre
keymap.set("n", "sh", "<C-w>h") -- Aller à la fenêtre gauche
keymap.set("n", "sk", "<C-w>k") -- Aller à la fenêtre en haut
keymap.set("n", "sj", "<C-w>j") -- Aller à la fenêtre en bas
keymap.set("n", "sl", "<C-w>l") -- Aller à la fenêtre droite

-- Ajuster la fenêtre
keymap.set("n", "<C-w><left>", "<C-w><") -- Réduit la largeur de la fenêtre
keymap.set("n", "<C-w><right>", "<C-w>>") -- Augmente la largeur de la fenêtre
keymap.set("n", "<C-w><up>", "<C-w>+") -- Augmente la hauteur de la fenêtre
keymap.set("n", "<C-w><down>", "<C-w>-") -- Réduit la hauteur de la fenêtre

-- Recentrage avec les déplacement dans VIM
keymap.set("n", "J", "mzJ`z") -- Concatène la ligne actuelle et suivante sans espace
keymap.set("n", "<C-d>", "<C-d>zz") -- Déplacement du curseur vers le bas en restant au milieu
keymap.set("n", "<C-u>", "<C-u>zz") -- Déplacement du curseur vers le haut en restant au milieu
keymap.set("n", "n", "nzzzv") -- Lors de la recherche d'une occurrence, recentre le curseur au milieu de l'ecran
keymap.set("n", "N", "Nzzzv") -- Pareil mais en arrière

-- Diagnostics
keymap.set("n", "<C-n>", function()
	vim.diagnostic.goto_next()
end, opts)

keymap.set("n", "<leader>r", function()
	require("dylan.utils").replaceHexWithHSL()
end)
