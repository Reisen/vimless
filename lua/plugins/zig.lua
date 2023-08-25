return function(config)
    if type(config.plugins.zig) == 'boolean' and not config.plugins.zig then
        return {}
    end

    return {
        'ziglang/zig.vim',
        config = function()
            if config.plugins.zig and type(config.plugins.zig) == 'function' then
                config.plugins.zig()
                return
            end

            local opts = {
                autosave = true,
            }

            if config.plugins.zig and type(config.plugins.zig) == 'table' then
                opts = vim.tbl_deep_extend('force', opts, config.plugins.zig)
            end

            _G.zig_fmt_autosave = opts.autosave
        end
    }
end
