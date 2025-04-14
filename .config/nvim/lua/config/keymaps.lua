vim.g.mapleader = " "

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Merci à ThePrimeagen pour ce Netrw
keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Netrw" })
keymap.set("n", "<leader>pV", vim.cmd.Vex, { desc = "Netrw vertical" })

-- Remap pour Lazy
keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Evite les missclicks
keymap.set("n", "Q", "<nop>")

-- Remap pour Mason
keymap.set("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason" })

--- Copier-Coler dans le système
keymap.set({ "n", "v" }, "<leader>y", [["+y]]) -- Copier ce qui est surligné et le met dans le clipboard systeme
keymap.set("n", "<leader>Y", [["+Y]]) -- Copier la ligne et la met dans le clipboard systeme
keymap.set("x", "<leader>p", [["_dP]]) -- Coupe la partie surlignée sans la mettre dans le presse-papier et colle ce qu'il y avait dans le presse-papier avant le curseur en mode visuel
keymap.set({"n", "v"}, "<leader>d", "\"_d") -- Coupe (une ou plusieurs lignes) SANS mettre dans le presse-papier système
keymap.set("n", "x", '"_x"') -- Coupe sans mettre dans le presse-papier

--- Tu croyais que j'blaguais Nono ?
keymap.set("i", "<C-c>", "<Esc>") -- Quitte l'insertion pour revenir au mode normal utile pour le Visual-Block mode

-- tmux-sessionizer
keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

--- Incrémenter/Décrémenter une valeur
-- keymap.set({ "n", "v" }, "+", "<C-a>")
-- keymap.set({ "n", "v" }, "g+", "g<C-a>", { desc = "Increment value 1 by 1" }) -- Version continue
-- keymap.set({ "n", "v" }, "-", "<C-x>")
-- keymap.set({ "n", "v" }, "g-", "g<C-x>", { desc = "Decrement value 1 by 1" }) -- Version continue

--- Selectionne tout le texte
-- keymap.set("n", "<C-a>", "gg<S-v>G")

-- Diviser la fenêtre courante
keymap.set("n", "ss", ":split<Return>", opts) -- Division de la fenêtre horizontalement
keymap.set("n", "sv", ":vsplit<Return>", opts) -- Division de la fenêtre verticalement

-- Déplacement de fenêtre en fenêtre
keymap.set("n", "sh", "<C-w>h") -- Aller à la fenêtre gauche
keymap.set("n", "sk", "<C-w>k") -- Aller à la fenêtre en haut
keymap.set("n", "sj", "<C-w>j") -- Aller à la fenêtre en bas
keymap.set("n", "sl", "<C-w>l") -- Aller à la fenêtre droite

-- Recentrage avec les déplacement dans VIM
keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- Après avoir sélectionnée un morceau de texte, le déplacement d'une ligne vers le bas et le réindente
keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- Après avoir sélectionnée un morceau de texte, le déplacement d'une ligne vers le haut et le réindente
keymap.set("n", "J", "mzJ`z") -- Concatène la ligne actuelle et celle du dessous sans espace
keymap.set("n", "<C-d>", "<C-d>zz") -- Déplacement du curseur vers le bas en restant au milieu
keymap.set("n", "<C-u>", "<C-u>zz") -- Déplacement du curseur vers le haut en restant au milieu
keymap.set("n", "n", "nzzzv") -- Lors de la recherche d'une occurrence, recentre le curseur au milieu de l'ecran
keymap.set("n", "N", "Nzzzv") -- Pareil mais en arrière
keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz") -- Se déplacer où y a les erreurs
keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")

-- Meilleur Indentation
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- Formatter le code grâce au LSP
keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Remplacer le mot sous le curseur
keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
