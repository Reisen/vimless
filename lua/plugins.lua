-- Neovim Configuration, 100% Lua Inside!
--
-- TODO: Rust Crate Graph as ASCII.
-- TODO: Find a way to Container Shell in tab.

local scrollbar = false
local theme     = 'tokyonight'

-- Install Packer
-- ------------------------------------------------------------------------------------
local packer = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(packer)) > 0 then
    vim.fn.system({
        'git',
        'clone',
        '--depth', '1',
        'https://github.com/wbthomason/packer.nvim',
        packer
    })
end

-- Configure Plugins
-- ------------------------------------------------------------------------------------
return require('packer').startup(function()
    use 'wbthomason/packer.nvim'

    -- Theming
    -- --------------------------------------------------------------------------------
    require('themes')(use, theme)
    require('plugins/nvim-web-devicons')(use)
    require('plugins/twilight')(use)

    use { 'gen740/SmoothCursor.nvim',
        config = function()
            require('smoothcursor').setup {
                priority = 10,
                linehl   = true,
                fancy    = {
                    enable = true,
                    head   = {
                        cursor = 'o',
                        texthl = 'SmoothCursor',
                        linehl = nil
                    },
                    body   = {
                        { cursor = "●", texthl = "SmoothCursorRed" },
                        { cursor = "●", texthl = "SmoothCursorOrange" },
                        { cursor = "•", texthl = "SmoothCursorYellow" },
                        { cursor = "•", texthl = "SmoothCursorGreen" },
                        { cursor = "•", texthl = "SmoothCursorAqua" },
                        { cursor = ".", texthl = "SmoothCursorBlue" },
                        { cursor = ".", texthl = "SmoothCursorPurple" },
                    }
                },
            }
        end
    }


    -- IDE
    -- --------------------------------------------------------------------------------
    require('plugins/auto-session')(use)
    require('plugins/comment')(use)
    require('plugins/diffview')(use)
    require('plugins/gitsigns')(use)
    require('plugins/harpoon')(use)
    require('plugins/hydra')(use)
    require('plugins/leap')(use)
    require('plugins/marks')(use)
    require('plugins/mind')(use)
    require('plugins/octo')(use)
    require('plugins/telescope')(use)
    require('plugins/toggleterm')(use)
    require('plugins/trouble')(use)
    require('plugins/which-key')(use)

    -- Mini.ai
    use { 'echasnovski/mini.nvim',
        config = function()
            require 'mini.comment'.setup {}
            require 'mini.starter'.setup {}
        end
    }

    -- Conditional Plugins
    __ = (scrollbar and require('plugins/scrollbar')(use))

    use { 'toppair/reach.nvim',
        config = function()
            local reach_options = {
                handle       = 'dynamic',
                show_current = true,
                sort         = function(a, b)
                    return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
                end,
            }

            -- Bind Reach to <leader>j
            function _G.reach_jumper()
                require('reach').buffers(reach_options)
            end

            vim.api.nvim_set_keymap('n', '<leader>j', '<cmd>lua reach_jumper()<CR>', {
                noremap = true,
                silent  = true,
            })

            require 'reach'.setup {}
        end
    }

    -- Quick `use` plugins.
    use 'tpope/vim-fugitive'
    use 'tpope/vim-repeat'
    use 'tpope/vim-vinegar'
    use 'unblevable/quick-scope'
    use 'ibhagwan/fzf-lua'

    -- EasyAlign Bindings.
    use { 'junegunn/vim-easy-align',
        config = function()
            vim.cmd [[
                xmap ga <Plug>(EasyAlign)
                nmap ga <Plug>(EasyAlign)
            ]]
        end
    }

    -- Zen Mode Bindings
    use { 'Pocco81/true-zen.nvim',
        config = function()
            vim.api.nvim_set_keymap("n", "<leader>zn", ":TZNarrow<CR>", {})
            vim.api.nvim_set_keymap("v", "<leader>zn", ":'<,'>TZNarrow<CR>", {})
            vim.api.nvim_set_keymap("n", "<leader>zf", ":TZFocus<CR>", {})
            vim.api.nvim_set_keymap("n", "<leader>zm", ":TZMinimalist<CR>", {})
            vim.api.nvim_set_keymap("n", "<leader>za", ":TZAtaraxis<CR>", {})
        end,
    }


    -- Completion
    -- --------------------------------------------------------------------------------
    require('plugins/cmp')(use)

    use 'github/copilot.vim'


    -- Languages & LSP
    -- --------------------------------------------------------------------------------
    require('plugins/rust')(use)
    require('plugins/lspconfig')(use)
    require('plugins/treesitter')(use)

    use 'hashivim/vim-terraform'
    use 'tomlion/vim-solidity'
    use 'iden3/vim-circom-syntax'
    use 'LnL7/vim-nix'
    use { 'eraserhd/parinfer-rust', run = 'cargo build --release' }


    -- Fun
    -- --------------------------------------------------------------------------------
    vim.g.cryptoprice_base_currency = "usd"
    vim.g.cryptoprice_crypto_list   = { "bitcoin", "ethereum", "solana" }
    vim.g.cryptoprice_window_width  = 60
    vim.g.cryptoprice_window_height = 10
    use 'gaborvecsei/cryptoprice.nvim'
end)
