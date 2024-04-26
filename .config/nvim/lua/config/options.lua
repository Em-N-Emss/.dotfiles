vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.termguicolors = true -- Avoir la true color

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true -- Contrôle si NVIM utilise TAB ou ESPACE pour indenter

vim.opt.smartindent = true -- Alignement en fonction de la structure du code

vim.opt.wrap = false -- Evite de mettre à la ligne le texte hors de l'écran

vim.opt.swapfile = false -- Permet à VIM de créer un fichier qui servira de recover si un problème arrive
vim.opt.updatetime = 50 -- Permet de sauvegarder le swapfile tous les 50ms
vim.opt.backup = false -- Evite de créer un backup lors de l'ouverture de fichier (Optimisation)
vim.opt.undofile = true -- Permet de sauvegarder l'édition pour récupérer le fichier avant les dernières modifications

vim.opt.incsearch = true -- Recheche mise à jour à chaque fois que l'on tape une nouvelle lettre (Pratique)
vim.opt.hlsearch = false -- Evite de surligner lors de la recheche de mot


vim.opt.scrolloff = 8 -- Décalage de N lignes affichées dans la colonne verticale
vim.opt.signcolumn = "yes"

vim.opt.isfname:append("@-@") -- Permet à VIM de reconnaitre "@" et "-" comme des caractères possible pour un nom de fichier
