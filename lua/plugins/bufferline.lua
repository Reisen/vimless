return function(config)
    if type(config.plugins.bufferline) == 'boolean' and not config.plugins.bufferline then
        return {}
    end

    return {
        'akinsho/bufferline.nvim',
        tag          = "v2.*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        config       = function()
            if config.plugins.bufferline and type(config.plugins.bufferline) == 'function' then
                config.plugins.bufferline()
                return
            end

            local opts = {
                options = {
                    always_show_bufferline  = true,
                    diagnostics             = 'nvim_lsp',
                    separator_style         = { '', '' },
                    show_buffer_close_icons = false,
                    show_close_icon         = false,
                }
            }

            if config.plugins.bufferline and type(config.plugins.bufferline) == 'table' then
                opts = vim.tbl_deep_extend('force', opts, config.plugins.bufferline)
            end

            require 'bufferline'.setup(opts)
        end
    }
end
