-- Neovim Configuration, 100% Lua Inside!
--
-- TODO: Change neovim LSP symbols from E/W/H to colored CDOT.
-- TODO: Setup theme switching.
-- TODO: Create Hydra's instead of relying on which-key.

local scrollbar = false
local theme     = 'oxocarbon-lua'

-- Install Packer & Fennel
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


    -- IDE
    -- --------------------------------------------------------------------------------
    require('plugins/auto-session')(use)
    require('plugins/diffview')(use)
    require('plugins/gitsigns')(use)
    require('plugins/harpoon')(use)
    require('plugins/hydra')(use)
    require('plugins/leap')(use)
    require('plugins/marks')(use)
    require('plugins/telescope')(use)
    require('plugins/toggleterm')(use)
    require('plugins/trouble')(use)
    require('plugins/which-key')(use)

    -- Mini.ai
    use { 'echasnovski/mini.nvim',
        config = function()
            require 'mini.comment'.setup {}
            require 'mini.pairs'.setup   {}
            require 'mini.starter'.setup {}
        end
    }

    use 'ibhagwan/fzf-lua'

    -- Conditional Plugins
    __ = (scrollbar and require('plugins/scrollbar')(use))

    use { 'toppair/reach.nvim',
        config = function()
            require 'reach'.setup {}
        end
    }

    -- Quick `use` plugins.
    use 'tpope/vim-fugitive'
    use 'tpope/vim-repeat'
    use 'tpope/vim-vinegar'
    use 'unblevable/quick-scope'

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
