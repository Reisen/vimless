return function(config)
    if type(config.plugins.twilight) == 'boolean' and not config.plugins.twilight then
        return {}
    end

    return {
        "folke/twilight.nvim",
        config = function()
            if config.plugins.twilight and type(config.plugins.twilight) == 'function' then
                config.plugins.twilight()
                return
            end

            local opts = {
                dimming    = { inactive = true, },
                context    = 5,
                treesitter = true,
                expand     = {
                    "function",
                    "expression_statement",
                    "if_statement",
                    "method",
                    "struct_expression",
                    "table",
                },
            }

            require "twilight".setup(opts)
        end
    }
end
