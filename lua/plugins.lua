return require('packer').startup(function()
    use 'wbthomason/packer.nvim'

    -- Theming
    -- --------------------------------------------------------------------------------
    require('plugins/bufferline')(use)
    require('plugins/indent-blankline')(use)
    require('plugins/nvim-web-devicons')(use)
    require('plugins/onedark')(use)

    use 'hashivim/vim-terraform'


    -- IDE
    -- --------------------------------------------------------------------------------
    require('plugins/auto-session')(use)
    require('plugins/comment')(use)
    require('plugins/diffview')(use)
    require('plugins/gitsigns')(use)
    require('plugins/goyo')(use)
    require('plugins/leap')(use)
    require('plugins/marks')(use)
    require('plugins/scrollbar')(use)
    require('plugins/symbols-outline')(use)
    require('plugins/telescope')(use)
    require('plugins/toggleterm')(use)
    require('plugins/trouble')(use)
    require('plugins/which-key')(use)

    use { 'toppair/reach.nvim',
        config = function()
            require 'reach'.setup {
            }
        end
    }

    use 'junegunn/vim-easy-align'
    use 'rstacruz/vim-closer'
    use 'tpope/vim-endwise'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-repeat'
    use 'tpope/vim-vinegar'
    use 'unblevable/quick-scope'

    vim.cmd [[
        xmap ga <Plug>(EasyAlign)
        nmap ga <Plug>(EasyAlign)
    ]]


    -- Completion
    -- --------------------------------------------------------------------------------
    require('plugins/cmp')(use)
    use 'github/copilot.vim'


    -- Languages / LSP
    -- --------------------------------------------------------------------------------
    require('plugins/rust')(use)
    require('plugins/lspconfig')(use)
    require('plugins/treesitter')(use)


    -- Fun
    -- --------------------------------------------------------------------------------
    vim.g.cryptoprice_base_currency = "usd"
    vim.g.cryptoprice_crypto_list   = {"bitcoin", "ethereum", "solana"}
    vim.g.cryptoprice_window_width  = 60
    vim.g.cryptoprice_window_height = 10
    use 'gaborvecsei/cryptoprice.nvim'
end)
