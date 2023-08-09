return function(config)
    if type(config.plugins.neotree) == 'boolean' and not config.plugins.neotree then
        return {}
    end

    return {
        'nvim-neo-tree/neo-tree.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'MunifTanjim/nui.nvim',
        },
        config   = function()
            if config.plugins.neotree and type(config.plugins.neotree) == 'function' then
                config.plugins.neotree()
                return
            end

            local opts = {
                -- Fix icons that are no longer present in Nerd Fonts 3.0+
                default_component_configs = {
                    git_status = {
                        symbols = {
                            added     = "✚",
                            conflict  = "",
                            deleted   = "✖",
                            ignored   = "",
                            modified  = "",
                            renamed   = "󰁕",
                            staged    = "",
                            unstaged  = "󰄱",
                            untracked = "",
                        }
                    },

                    document_symbols = {
                        kinds = {
                            Unknown       = { icon = "?", hl = "" },
                            Root          = { icon = "", hl = "NeoTreeRootName" },
                            File          = { icon = "󰈙", hl = "Tag" },
                            Module        = { icon = "", hl = "Exception" },
                            Namespace     = { icon = "󰌗", hl = "Include" },
                            Package       = { icon = "󰏖", hl = "Label" },
                            Class         = { icon = "󰌗", hl = "Include" },
                            Method        = { icon = "", hl = "Function" },
                            Property      = { icon = "󰆧", hl = "@property" },
                            Field         = { icon = "", hl = "@field" },
                            Constructor   = { icon = "", hl = "@constructor" },
                            Enum          = { icon = "󰒻", hl = "@number" },
                            Interface     = { icon = "", hl = "Type" },
                            Function      = { icon = "󰊕", hl = "Function" },
                            Variable      = { icon = "", hl = "@variable" },
                            Constant      = { icon = "", hl = "Constant" },
                            String        = { icon = "󰀬", hl = "String" },
                            Number        = { icon = "󰎠", hl = "Number" },
                            Boolean       = { icon = "", hl = "Boolean" },
                            Array         = { icon = "󰅪", hl = "Type" },
                            Object        = { icon = "󰅩", hl = "Type" },
                            Key           = { icon = "󰌋", hl = "" },
                            Null          = { icon = "", hl = "Constant" },
                            EnumMember    = { icon = "", hl = "Number" },
                            Struct        = { icon = "󰌗", hl = "Type" },
                            Event         = { icon = "", hl = "Constant" },
                            Operator      = { icon = "󰆕", hl = "Operator" },
                            TypeParameter = { icon = "󰊄", hl = "Type" },
                        }
                    },
                },

                sources = {
                  "filesystem",
                  "buffers",
                  "git_status",
                  "document_symbols",
                },

                filesystem = {
                    hijack_netrw_behavior = 'disabled',
                },

                source_selector = {
                    winbar = false,
                }
            }

            if config.plugins.neotree and type(config.plugins.neotree) == 'table' then
                opts = vim.tbl_extend('force', opts, config.plugins.neotree)
            end

            vim.g.neo_tree_remove_legacy_commands = 1

            require 'neo-tree'.setup(opts)
        end
    }
end
