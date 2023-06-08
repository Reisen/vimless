return function(config)
    if type(config.plugins.circles) == 'boolean' and not config.plugins.circles then
        return {}
    end

    return {
        "projekt0n/circles.nvim",
        dependencies = {"nvim-tree/nvim-web-devicons"},
        config       = function()
            if config.plugins.circles and type(config.plugins.circles) == 'function' then
                config.plugins.circles()
                return
            end

            local opts = {
                lsp   = true,
                icons = {
                    empty      = "○",
                    filled     = "●",
                    lsp_prefix = "●",
                },
            }

            require('circles').setup(opts)
        end
    }
end
