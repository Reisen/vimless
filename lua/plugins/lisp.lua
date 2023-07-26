return function(config)
    if type(config.plugins.lisp) == 'boolean' and not config.plugins.lisp then
        return {}
    end

    return {
        'eraserhd/parinfer-rust',
        build  = 'cargo build --release',
        config = function()
            if config.plugins.lisp and type(config.plugins.lisp) == 'function' then
                config.plugins.lisp()
                return
            end

            local opts = {}

            if config.plugins.lisp and type(config.plugins.lisp) == 'table' then
                opts = vim.tbl_extend('force', opts, config.plugins.lisp)
            end
        end
    }
end
