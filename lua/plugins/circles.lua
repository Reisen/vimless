return function(use)
    use {
        "projekt0n/circles.nvim",
        requires = {"nvim-tree/nvim-web-devicons"},
        config   = function()
            require("circles").setup {
                lsp   = true,
                icons = {
                    empty      = "○",
                    filled     = "●",
                    lsp_prefix = "●",
                },
            }
        end
    }
end
