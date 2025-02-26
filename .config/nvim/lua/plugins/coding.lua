return {
    -- Pour avoir ", {, [, `, ' qui se referme automatiquement
    -- {
    --     'windwp/nvim-autopairs',
    --     event = "InsertEnter",
    --     config = true
    --     -- use opts = {} for passing setup options
    --     -- this is equalent to setup({}) function
    -- },

    -- Pouvoir avoir les commentaires au bout des doigts grâce à "gc"
    {
        'numToStr/Comment.nvim',
        opts = {
            -- add any options here
        },
    },

    -- Permettre de mettre en quote du texte existant
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require("nvim-surround").setup({
                -- keymaps = {
                --     normal = "sa",
                --     delete = "sd",
                --     change = "sr",
                -- }
            })
        end
    }
}
