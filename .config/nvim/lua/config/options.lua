-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.mapleader = " "

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true -- Contrôle si NVIM utilise TAB ou ESPACE pour indenter
vim.opt.smarttab = true -- TAB intelligent
vim.opt.autoindent = true -- Aligner le curseur MRC la feature
vim.opt.smartindent = true -- Alignement en fonction de la structure du code
vim.opt.breakindent = true -- Garde la forme si le texte dépasse de la fenêtre

-- vim.cmd([[set mouse = a]]) -- Active la souris

vim.opt.title = true -- Met à jour le nom de la fenêtre courante

vim.opt.wrap = false -- Evite de mettre à la ligne le texte hors de l'écran

vim.opt.scrolloff = 8 -- Décalage de N lignes affichées dans la colonne verticale

vim.opt.splitbelow = true -- Split en bas si split vertical
vim.opt.splitright = true -- Split à droite si split horizontal
vim.opt.splitkeep = "cursor" -- Garde le curseur dans une fenêtre sans changer alors qu'on ferme une autre

vim.opt.backspace = { "start", "eol", "indent" } -- Rend la supression efficace dans le contexte du curseur

vim.opt.backup = false -- Evite de créer un backup lors de l'ouverture de fichier (Optimisation)

vim.opt.incsearch = true -- Recheche mise à jour à chaque fois que l'on tape une nouvelle lettre (Pratique)

vim.opt.undofile = true -- Permet de sauvegarder les traces de l'édition pour récupérer le fichier avant les dernières modifications
