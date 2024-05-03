return {
    "epwalsh/obsidian.nvim",
    version = "*",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
    },

    config = function ()

        -- Global remap pour la daily-note
        vim.keymap.set("n", "<leader>od", function ()
            return "<cmd>ObsidianToday<CR><cmd>execute 'sleep 100m' | execute 'NoNeckPain' | execute 'norm Gzzo' | execute 'norm o' | startinsert!<CR>"
        end, { expr = true, buffer = true })

        -- Pareil pour la version split
        vim.keymap.set("n", "<leader>oD", function ()
            return ":rightbelow vsplit<CR><cmd>ObsidianToday<CR><cmd>execute 'sleep 100m' | execute 'NoNeckPain' | execute 'norm Gzzo' | execute 'norm o' | startinsert!<CR>"
        end, { expr = true })

        vim.keymap.set("n", "<leader>oz", function ()
            return ":!tmux splitw -h zet<CR>"
        end, { expr = true })

        require("obsidian").setup({
            workspaces = {
                {
                    name = "Second-Brain",
                    path = "~/Second-Brain",
                },
            },

            notes_subdir = "Inbox",
            new_notes_location = "notes_subdir",

            note_id_func = function()
                local suffix = require("obsidian").util.parse_cursor_link()
                return suffix
            end,

            note_path_func = function(spec)
                local path = spec.dir / tostring(spec.id)
                return path:with_suffix(".md")
            end,

            disable_frontmatter = true,

            templates = {
                subdir = "Archive/Templates",
                date_format = "%d-%m-%Y",
                time_format = "%Y%m%d%H%M",
                substitutions = {
                    yesterday = function ()
                        return os.date("%d-%m-%Y", os.time() - 86400)
                    end,

                    tomorrow = function ()
                        return os.date("%d-%m-%Y", os.time() + 86400)
                    end,
                }
            },

            daily_notes = {
                folder = "Periodic-Notes/Daily-Notes",
                date_format = "%d-%m-%Y",
                template = "Daily-Notes.md"
            },

            -- Ouvre les URLs dans le navigateur
            follow_url_func = function(url)
                vim.fn.jobstart({"xdg-open", url})  -- linux/WSL
            end,

            -- Remap seulement appliqué dans les markdown
            mappings = {
                -- Change le raccourci 'gf' pour se déplacer grâce aux liens Markdown/Wiki
                ["gd"] = {
                    action = function()
                        return require("obsidian").util.gf_passthrough()
                    end,
                    opts = { noremap = false, expr = true, buffer = true },
                },

                -- Permet de voir les notes qui font appel au link, ces derniers sont présenté sous le format telescope
                ["<leader>vrr"] = {
                    action = function ()
                        -- Voir les backlinks du markdown sous le curseur
                        if require("obsidian").util.cursor_on_markdown_link() then
                            return "<cmd>ObsidianBacklinks<CR>"
                        else
                            -- Voir les backlinks du buffer
                            return "<cmd>ObsidianBacklinks<CR>"
                        end
                    end,
                    opts = { noremap = false, expr = true, buffer = true },
                },

                -- Pour appliquer des templates sans passer par Obsidian
                ["<leader>ot"] = {
                    action = function()
                        return "<cmd>ObsidianTemplate<CR>"
                    end,
                    opts = { noremap = false, expr = true, buffer = true },
                },


                -- Permet de créer des notes qui n'existent pas pendant une review
                ["<leader>on"] = {
                    action = function()
                        return "<cmd>ObsidianNew<CR>"
                    end,
                    opts = { noremap = false, expr = true, buffer = true },
                },
            },

            -- LSP
            completion = {
                nvim_cmp = true,
                min_chars = 2,
            },
        })
    end
}
