return function(use)
    use { 'nvim-neotest/neotest',
      requires = {
        'rouge8/neotest-rust',
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
        'antoinemadec/FixCursorHold.nvim'
      },
      config = function()
          require 'neotest'.setup {
              adapters = {
                  require('neotest-rust')
              }
          }
      end
    }
end
