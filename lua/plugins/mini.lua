---@diagnostic disable: unused-local

return function(config)
    if type(config.plugins.mini) == 'boolean' and not config.plugins.mini then
        return {}
    end

    return {
        'echasnovski/mini.nvim',
        priority = 800,
        config   = function()
            if config.plugins.mini and type(config.plugins.mini) == 'function' then
                config.plugins.mini()
                return
            end

            local treespec = require 'mini.ai'.gen_spec.treesitter
            local opts = {
                align     = {},
                bracketed = {},
                bufremove = {},
                comment   = {},
                operators = {},
                pairs     = {},
                surround  = {},

                animate = {
                    cursor = { enable = false },
                    scroll = { enable = false },
                    resize = { enable = false },
                    open   = { enable = false },
                    close  = { enable = false },
                },

                ai = {
                    custom_textobjects = {
                        e     = treespec({ a = '@assignment.outer', i = '@assignment.inner', }),
                        b     = treespec({ a = '@block.outer', i = '@block.inner', }),
                        c     = treespec({ a = '@call.outer', i = '@call.inner', }),
                        d     = treespec({ a = '@class.outer', i = '@class.inner', }),
                        f     = treespec({ a = '@function.outer', i = '@function.inner', }),
                        s     = treespec({ a = '@scope', i = '@scope', }),
                        ["/"] = treespec({ a = '@comment.outer', i = '@comment.outer', }),
                    },

                    mappings = {
                        around_last = '',
                        inside_last = '',
                    },
                },

                base16 = {
                    plugins = { default = true },

                    -- Set all base colors to black, as we're targetting cterm not gui.
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

                    -- Assign bases to the correct base16 colours.
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
                },

                files = {
                    options = {
                        use_as_default_explorer = false,
                    },
                },
            }

            if config.plugins.mini and type(config.plugins.mini) == 'table' then
                opts = vim.tbl_deep_extend('force', opts, config.plugins.mini)
            end

            local __ = nil
            __ = opts.ai        and require 'mini.ai'.setup(opts.ai)
            __ = opts.align     and require 'mini.align'.setup(opts.align)
            __ = opts.animate   and require 'mini.animate'.setup(opts.animate)
            __ = opts.base16    and require 'mini.base16'.setup(opts.base16)
            __ = opts.bracketed and require 'mini.bracketed'.setup(opts.bracketed)
            __ = opts.bufremove and require 'mini.bufremove'.setup(opts.bufremove)
            __ = opts.comment   and require 'mini.comment'.setup(opts.comment)
            __ = opts.files     and require 'mini.files'.setup(opts.files)
            __ = opts.operators and require 'mini.operators'.setup(opts.operators)
            __ = opts.pairs     and require 'mini.pairs'.setup(opts.pairs)
            __ = opts.surround  and require 'mini.surround'.setup(opts.surround)

            _G.HydraMappings['Buffer']['Other'].d    = { 'Delete Buffer', require 'mini.bufremove'.delete, {} }
            _G.HydraMappings['Root']['Plugins']['-'] = { 'MiniFiles',     require 'mini.files'.open, { exit = true } }

            -- mini.base16 configures most colours perfectly, but gets a few that look a little gnarly.
            -- Here we override some of those colours by defining an autocommand that override some of
            -- those highlights whenever a new buffer is opened.
            ---@diagnostic disable-next-line: unused-local
            vim.cmd [[
                augroup base16override
                autocmd!
                autocmd BufEnter *
                    \   highlight  Normal                 guibg=NONE    guifg=NONE
                    \|  highlight  SignColumn             ctermbg=NONE                
                    \|  highlight  WinSeparator           ctermbg=NONE  ctermfg=bg
                    \|  highlight  StatusLine             ctermbg=NONE  ctermfg=4     
                    \|  highlight  StatusLineNC           ctermbg=NONE  ctermfg=8     
                    \|  highlight  WinBar                 ctermbg=18    ctermfg=3
                    \|  highlight  WinBarNC               ctermbg=18    ctermfg=3     
                    \|  highlight  LineNr                 ctermbg=NONE  ctermfg=8
                    \|  highlight  GitSignsAdd            ctermbg=NONE                
                    \|  highlight  GitSignsChange         ctermbg=NONE                
                    \|  highlight  GitSignsDelete         ctermbg=NONE                
                    \|  highlight  DiagnosticSignError    ctermbg=NONE                
                    \|  highlight  DiagnosticSignWarn     ctermbg=NONE                
                    \|  highlight  DiagnosticSignInfo     ctermbg=NONE                
                    \|  highlight  DiagnosticSignHint     ctermbg=NONE                
                    \|  highlight  DiagnosticSignError    ctermbg=NONE                
                    \|  highlight  GitSignsAddLn          ctermbg=18    ctermfg=NONE  
                    \|  highlight  GitSignsChangeLn       ctermbg=18    ctermfg=NONE  
                    \|  highlight  GitSignsDeleteLn       ctermbg=18    ctermfg=NONE  
                    \|  highlight  GitSignsUntrackedLn    ctermbg=18    ctermfg=NONE  
                    \|  highlight  GitSignsUntrackedLn    ctermbg=18    ctermfg=NONE  
                    \|  highlight  EndOfBuffer            ctermbg=NONE  ctermfg=bg    
                    \|  highlight  WhichKeyFloat          ctermbg=NONE                
                    \|  highlight  WhichKeySeparator      ctermbg=NONE                
                    \|  highlight  FlashMatch             ctermbg=NONE  ctermfg=1     
                    \|  highlight  FlashCurrent           ctermbg=NONE  ctermfg=3     
                    \|  highlight  FlashLabel             ctermbg=NONE  ctermfg=2     cterm=underline,bold
                    \|  highlight  HydraHint              ctermbg=NONE                
                    \|  highlight  HydraBorder            ctermbg=NONE  ctermfg=19    
                    \|  highlight  HydraSelected          ctermbg=NONE                
                    \|  highlight  TelescopeBorder        ctermbg=NONE  ctermfg=8     
                    \|  highlight  TelescopeTitle         ctermbg=NONE  ctermfg=4
                    \|  highlight  NeoTreeWinSeparator    ctermbg=NONE  ctermfg=bg
                    \|  highlight  MiniFilesBorder        ctermbg=bg    ctermfg=4
                    \|  highlight  MiniFilesNormal        ctermbg=bg                  
                    \|  highlight  MiniFilesTitle         ctermbg=bg                  
                    \|  highlight  MiniFilesTitleFocused  ctermbg=bg                  
                    \|  highlight  TabLine                ctermbg=NONE  ctermfg=8
                    \|  highlight  TabLineFill            ctermbg=NONE  ctermfg=8
                    \|  highlight  TabLineSel             ctermbg=NONE  ctermfg=1
                    \|  highlight  QuickScopePrimary      ctermbg=NONE  ctermfg=1 cterm=underline
                    \|  highlight  QuickScopeSecondary    ctermbg=NONE  ctermfg=8
                    \|  highlight  Twilight               ctermfg=8
                augroup END
            ]]
        end
    }
end
