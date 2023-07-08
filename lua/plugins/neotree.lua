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
