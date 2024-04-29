vim.opt.guicursor = "" -- Avoir un cuseur constant même en étant en insert mode

vim.opt.nu = true
vim.opt.relativenumber = true
-- vim.opt.fillchars = { eob = ' ' } -- Permet d'enlever les "~" à la fin du buffer

vim.opt.termguicolors = true -- Avoir la true color
vim.opt.laststatus = 3 -- Pour que la statusbar soit la même pour toutes les fenêtres

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true -- Contrôle si NVIM utilise TAB ou ESPACE pour indenter

vim.opt.smartindent = true -- Alignement en fonction de la structure du code
vim.opt.breakindent = true -- Garde la forme si le texte dépasse de la fenêtre

vim.opt.wrap = false -- Permet au texte de sortir de l'écran

vim.opt.swapfile = false -- Permet à VIM de créer un fichier qui servira de recover si un problème arrive
vim.opt.updatetime = 50 -- Permet de sauvegarder le swapfile tous les 50ms
vim.opt.backup = false -- Evite de créer un backup lors de l'ouverture de fichier (Optimisation)
vim.opt.undofile = true -- Permet de sauvegarder l'édition pour récupérer le fichier avant les dernières modifications

vim.opt.incsearch = true -- Recheche mise à jour à chaque fois que l'on tape une nouvelle lettre (Pratique)
vim.opt.hlsearch = false -- Evite de surligner lors de la recheche de mot


vim.opt.scrolloff = 8 -- Décalage de N lignes affichées dans la colonne verticale
vim.opt.virtualedit = "block" -- Permet de pouvoir selectionner en bloc sans qu'il y ait besoin de texte
vim.opt.signcolumn = "yes"

vim.opt.isfname:append("@-@") -- Permet à VIM de reconnaitre "@" et "-" comme des caractères possible pour un nom de fichier
