return function(config)
    if type(config.plugins.marks) == 'boolean' and not config.plugins.marks then
        return {}
    end

    return {
        'chentoast/marks.nvim',
        config = function()
            if config.plugins.marks and type(config.plugins.marks) == 'function' then
                config.plugins.marks()
                return
            end

            local opts = {
                default_mappings = true,
                signs            = true,
            }

            if config.plugins.marks and type(config.plugins.marks) == 'table' then
                opts = vim.tbl_deep_extend('force', opts, config.plugins.marks)
            end

            require 'marks'.setup(opts)
        end
    }
end
