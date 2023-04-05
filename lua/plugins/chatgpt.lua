return function(use)
    use { 'jackMort/ChatGPT.nvim',
        requires = {
          'MunifTanjim/nui.nvim',
          'nvim-lua/plenary.nvim',
          'nvim-telescope/telescope.nvim'
        },
        config = function()
          require('chatgpt').setup({
              keymaps = {
                  submit      = '<C-s>',
                  new_session = '<C-a>',
              }
          })

            -- This function finds the currently selected visual range, and then submits it
            -- to ChatGPT for processing.
            function _G.ChatGPTSubmit(mode)
                -- Check we have `curl` installed.
                if vim.fn.executable('curl') == 0 then
                    print("ChatGPT: curl is not installed.")
                    return
                end

                -- Get OPENAI_API_KEY from environment.
                local api_key = vim.fn.getenv('OPENAI_API_KEY')

                -- Get current visual range, and ask the user for a prompt.
                local start_line = vim.fn.getpos("'<")[2]
                local end_line   = vim.fn.getpos("'>")[2]
                local text       = table.concat(vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false), "\n")
                local prompt     = "GPT Action: "
                local user_input = mode == '' and vim.fn.input(prompt) or ''

                -- A set of common roles (if no prompt was given).
                local system_role = user_input ~= '' and user_input or ({
                    reviewer  = "You are an expert software engineer tasked with reviewing a pull request.",
                    improver  = "You are an expert software engineer tasked with improving code. You will be sent code that you must improve, and you will only reply with the improved code. Make the code shorter, clearer, with better variable naming and documentation. Fix bugs where necessary, and refactor if it can be improved.",
                    explainer = "You are an expert software engineer tasked with explaining code.",
                    generator = "You are an expert software engineer tasked with producing code from an explanation. The code should be easy to understand, high quality, terse when reasonable, and follow best practices.",
                })[mode]

                -- Submit the result to ChatGPT.
                local cmd = string.format([[
                    curl -s \
                        -H 'Content-Type: application/json' \
                        -H 'Authorization: Bearer %s' \
                        -d '%s' \
                        https://api.openai.com/v1/chat/completions
                ]], api_key, vim.fn.json_encode({
                    model       = 'gpt-4',
                    messages    = {
                        -- The `text` may contain characters that get escaped in bash as it
                        -- is inserted between single quotes. Make sure to sub any
                        -- characters that would get escaped.
                        { role = "system", content = system_role, },
                        { role = "user",   content = text:gsub("'", "\'"), },
                    },
                    max_tokens  = 2000,
                    temperature = 0.9,
                    top_p       = 1,
                }))

                local result = vim.fn.system(cmd)
                local json = vim.fn.json_decode(result)
                local content = json.choices[1].message.content:gsub("^%s*(.-)%s*$", "%1")
                vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, vim.split(content, "\n"))
            end

            -- This function finds the currently selected visual range, and then submits it
            -- to ChatGPT for processing.
            function _G.ChatGPTPrompt()
                -- Check we have `curl` installed.
                if vim.fn.executable('curl') == 0 then
                    print("ChatGPT: curl is not installed.")
                    return
                end

                -- Get OPENAI_API_KEY from environment.
                local api_key = vim.fn.getenv('OPENAI_API_KEY')

                -- Get current visual range, and ask the user for a prompt.
                local start_line = vim.fn.getpos("'<")[2]
                local end_line   = vim.fn.getpos("'>")[2]
                local text       = table.concat(vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false), "\n")

                -- Submit the result to ChatGPT.
                local cmd = string.format([[
                    curl -s \
                        -H 'Content-Type: application/json' \
                        -H 'Authorization: Bearer %s' \
                        -d '%s' \
                        https://api.openai.com/v1/completions
                ]], api_key, vim.fn.json_encode({
                    model       = 'gpt-3.5-turbo',
                    prompt      = text:gsub("'", "\\'"),
                    max_tokens  = 2000,
                    temperature = 0.9,
                    top_p       = 1,
                }))

                local result = vim.fn.system(cmd)
                local json = vim.fn.json_decode(result)
                local content = json.choices[1].text:gsub("^%s*(.-)%s*$", "%1")
                vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, vim.split(content, "\n"))
            end

          -- Bind our custom GPT to <leader>c during visual mode.
          vim.api.nvim_set_keymap('v', '<leader>cr', ':lua ChatGPTSubmit("reviewer")<CR>',  { noremap = true, silent = true })
          vim.api.nvim_set_keymap('v', '<leader>ci', ':lua ChatGPTSubmit("improver")<CR>',  { noremap = true, silent = true })
          vim.api.nvim_set_keymap('v', '<leader>ce', ':lua ChatGPTSubmit("explainer")<CR>', { noremap = true, silent = true })
          vim.api.nvim_set_keymap('v', '<leader>cg', ':lua ChatGPTSubmit("generator")<CR>', { noremap = true, silent = true })
          vim.api.nvim_set_keymap('v', '<leader>cc', ':lua ChatGPTSubmit("")<CR>',          { noremap = true, silent = true })
          vim.api.nvim_set_keymap('v', '<leader>cp', ':lua ChatGPTPrompt<CR>',              { noremap = true, silent = true })
        end
    }
end
