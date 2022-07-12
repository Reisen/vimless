return function(use)
    use { "folke/twilight.nvim",
        config = function()
            require("twilight").setup {
                dimming    = { inactive = true, },
                context    = 5,
                treesitter = true,
                expand     = {
                    "function",
                    "expression_statement",
                    "if_statement",
                    "method",
                    "struct_expression",
                    "table",
                },
            }
        end
    }
end
