return function(config)
    if type(config.plugins.mini) == 'boolean' and not config.plugins.mini then
        return {}
    end

    return {
        'echasnovski/mini.nvim',
        config = function()
            if config.plugins.mini and type(config.plugins.mini) == 'function' then
                config.plugins.mini()
                return
            end

            local treespec = require 'mini.ai'.gen_spec.treesitter

            local opts = {
                ai = {
                    custom_textobjects = {
                        e = treespec({
                            a = '@assignment.outer',
                            i = '@assignment.inner',
                        }),
                        b = treespec({
                            a = '@block.outer',
                            i = '@block.inner',
                        }),
                        c = treespec({
                            a = '@call.outer',
                            i = '@call.inner',
                        }),
                        d = treespec({
                            a = '@class.outer',
                            i = '@class.inner',
                        }),
                        f = treespec({
                            a = '@function.outer',
                            i = '@function.inner',
                        }),
                        s = treespec({
                            a = '@scope',
                            i = '@scope',
                        }),
                        ["/"] = treespec({
                            a = '@comment.outer',
                            i = '@comment.outer',
                        }),
                    },

                    mappings = {
                        around_last = '',
                        inside_last = '',
                    },
                },
                base16 = {
                    -- TODO: Find a way to extract a palette from the current terminal
                    -- colourscheme and use that as the default.
                    palette   = {
                        base00 = "#000000",
                        base01 = "#000000",
                        base02 = "#000000",
                        base03 = "#000000",
                        base04 = "#000000",
                        base05 = "#000000",
                        base06 = "#000000",
                        base07 = "#000000",
                        base08 = "#000000",
                        base09 = "#000000",
                        base0A = "#000000",
                        base0B = "#000000",
                        base0C = "#000000",
                        base0D = "#000000",
                        base0E = "#000000",
                        base0F = "#000000",
                    },
                    use_cterm = {
                        base00 = 0,
                        base01 = 18,
                        base02 = 19,
                        base03 = 8,
                        base04 = 20,
                        base05 = 7,
                        base06 = 21,
                        base07 = 15,
                        base08 = 1,
                        base09 = 16,
                        base0A = 3,
                        base0B = 2,
                        base0C = 6,
                        base0D = 4,
                        base0E = 5,
                        base0F = 17,
                    },
                    plugins   = {
                        default = true
                    }
                },
                comment = {},
            }

            if config.plugins.mini and type(config.plugins.mini) == 'table' then
                opts = vim.tbl_extend('force', opts, config.plugins.mini)
            end

            require 'mini.ai'.setup(opts.ai)
            require 'mini.base16'.setup(opts.base16)
            require 'mini.comment'.setup(opts.comment)

            -- mini.base16 configures most colours perfectly, but gets a few that look a little gnarly.
            -- Here we override some of those colours by defining an autocommand that override some of
            -- those highlights whenever a new buffer is opened.
            vim.cmd [[
                augroup base16override
                autocmd!
                autocmd BufEnter *
                    \  highlight  SignColumn           ctermbg=NONE  guibg=NONE  |
                    \  highlight  WinSeparator         ctermbg=NONE  guibg=NONE  |
                    \  highlight  StatusLine           ctermbg=NONE  guibg=NONE  ctermfg=4  |
                    \  highlight  StatusLineNC         ctermbg=NONE  guibg=NONE  ctermfg=8  |
                    \  highlight  WinBar               ctermbg=18    guibg=NONE  ctermfg=4  |
                    \  highlight  WinBarNC             ctermbg=18    guibg=NONE  ctermfg=4  |
                    \  highlight  GitSignsAdd          ctermbg=NONE  guibg=NONE  |
                    \  highlight  GitSignsChange       ctermbg=NONE  guibg=NONE  |
                    \  highlight  GitSignsDelete       ctermbg=NONE  guibg=NONE  |
                    \  highlight  DiagnosticSignError  ctermbg=NONE  guibg=NONE  |
                    \  highlight  DiagnosticSignWarn   ctermbg=NONE  guibg=NONE  |
                    \  highlight  DiagnosticSignInfo   ctermbg=NONE  guibg=NONE  |
                    \  highlight  DiagnosticSignHint   ctermbg=NONE  guibg=NONE  |
                    \  highlight  DiagnosticSignError  ctermbg=NONE  guibg=NONE  |
                    \  highlight  GitSignsAddLn        ctermbg=18    guibg=NONE  |
                    \  highlight  GitSignsChangeLn     ctermbg=18    guibg=NONE  |
                    \  highlight  EndOfBuffer          ctermbg=NONE  guibg=NONE
                augroup END
            ]]
        end
    }
end
