return function(config)
    if type(config.plugins.copilot) == 'boolean' and not config.plugins.copilot then
        return {}
    end

    return {
        'zbirenbaum/copilot.lua',
        cmd    = 'Copilot',
        event  = 'InsertEnter',
        config = function()
            if config.plugins.copilot and type(config.plugins.copilot) == 'function' then
                config.plugins.copilot()
                return
            end

            local opts = {
                suggestion = {
                    auto_trigger = true,
                    keymap = {
                        accept = "<Tab>",
                    },
                },
                filetypes = {
                    ["*"]           = false,

                    -- Copilot can be considered a privacy leak, by default it runs in filetypes that we really
                    -- don't want it to, like in mail in neomutt, in env files with secrets, etc. So instead we
                    -- add a whitelist of languages that we want it to run in. This is more likely to give us
                    -- copilot in places you actually want copilot, I.E: code files.
                    clojurec        = true,
                    clojurescript   = true,
                    clojure         = true,
                    clojurex        = true,
                    cpp             = true,
                    crystal         = true,
                    css             = true,
                    c               = true,
                    csharp          = true,
                    dart            = true,
                    elixir          = true,
                    erlang          = true,
                    fennel          = true,
                    fiph            = true,
                    fsharp          = true,
                    go              = true,
                    groovy          = true,
                    haskell         = true,
                    html            = true,
                    javascriptreact = true,
                    javascript      = true,
                    java            = true,
                    json            = true,
                    julia           = true,
                    kotlin          = true,
                    lisp            = true,
                    lua             = true,
                    markdown        = true,
                    moon            = true,
                    nim             = true,
                    nix             = true,
                    objc            = true,
                    ocaml           = true,
                    php             = true,
                    powershell      = true,
                    python          = true,
                    racket          = true,
                    reason          = true,
                    r               = true,
                    ruby            = true,
                    rust            = true,
                    scala           = true,
                    scheme          = true,
                    scss            = true,
                    sh              = true,
                    sql             = true,
                    svelte          = true,
                    swift           = true,
                    toml            = true,
                    typescriptreact = true,
                    typescript      = true,
                    verilog         = true,
                    vhdl            = true,
                    vim             = true,
                    vue             = true,
                    yaml            = true,
                    zig             = true,
                    zsh             = true,
                }
            }

            if config.plugins.copilot and type(config.plugins.copilot) == 'table' then
                opts = vim.tbl_deep_extend('force', opts, config.plugins.copilot)
            end

            require 'copilot' .setup(opts)
        end
    }
end

