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
            function _G.ChatGPTSubmit(model, mode)
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
                    reviewer  = [[
The AI Assistant knows how to act as a professional software engineer. The AI
assistant knows how to review code in any programming language. The AI
assistant provides feedback on code style, formatting, documentation, and looks
for logic errors, code that could be more idiomatic, and potential security
flaws. The reviews the AI assistant produces are broken down into each
observation with code suggestions whenever possible.
]],
                    improver  = [[
The AI Assistant is sent code, and replies with improved code that can be
directly inserted into an editor. The AI Assistant improves code by following
ALL the following instructions:
  - Improve code style, following idiomatic conventions when possible.
  - Improve performance of code when a more efficient solution is possible.
  - In languages with optional typing, add typing when possible.
  - In languages with strict typing, introduce new types/structs/enums to improve correctness.
  - Use more idiomatic patterns.
  - Fix any logic errors and bugs present.
  - Fix any security flaw present.
  - Improve comments and documentation whenever it can be made more clear.
  - Add new concise and easy to understand comments where they are missing.
  - Never EVER remove existing comments unless the refactor is so significant that the comment is no longer relevant.
The code sent to the AI assistant to improve is as follows:
                    ]],
                    explainer = [[
The AI Assistant knows how to act as a professional software engineer, one who
how to explain code in any programming language. The AI assistant provides
explanations of code sent to it, responding with a clear, detailed, but easy to
understand explanation of the code. Any complex algorithms or assumptions made
by code are highlighted by the AI assistant and explained in depth. If code
utilizes complex features of a language that are difficult to understan or not
commonly used, the AI assistant explains the feature in detail. It is important
that the goal of the explanation is to understand WHY the code works and was
written the way it was, not just WHAT the code does.
]],
                    generator = [[
The AI Assistant knows how to act as a professional software engineer, one who
knows how to write code in any programming language. The AI assistant is sent a
comment or a small piece of initial code, and responds with a complete program
that implements the desired functionality. The AI assistant is able to write
code that meets all the following properties:
  - As efficient as possible.
  - In languages with optional typing, well typed.
  - In languages with strict typing, well typed and uses new types/structs/enums for strong correctness.
  - Uses idiomatic patterns whenever possible.
  - Free of logic errors.
  - Free of security flaws.
  - Concise but very thorough comments that are easy to understand.
]],
                })[mode]

                -- Submit the result to ChatGPT.
                local cmd = string.format([[
                    curl -s \
                        -H 'Content-Type: application/json' \
                        -H 'Authorization: Bearer %s' \
                        -d '%s' \
                        https://api.openai.com/v1/chat/completions
                ]], api_key, vim.fn.json_encode({
                    model       = model,
                    messages    = {
                        -- The `text` may contain characters that get escaped in bash as it
                        -- is inserted between single quotes. Make sure to sub any
                        -- characters that would get escaped.
                        { role = "system", content = system_role, },
                        { role = "user",   content = text:gsub("'", "\\'"), },
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
                    model       = 'text-davinci-003',
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

          -- Bind custom GPT to <leader>c during visual mode.
          vim.api.nvim_set_keymap('v', '<leader>cr', ':lua ChatGPTSubmit("gpt-3.5-turbo", "reviewer")<CR>',  { noremap = true, silent = true })
          vim.api.nvim_set_keymap('v', '<leader>ci', ':lua ChatGPTSubmit("gpt-3.5-turbo", "improver")<CR>',  { noremap = true, silent = true })
          vim.api.nvim_set_keymap('v', '<leader>ce', ':lua ChatGPTSubmit("gpt-3.5-turbo", "explainer")<CR>', { noremap = true, silent = true })
          vim.api.nvim_set_keymap('v', '<leader>cg', ':lua ChatGPTSubmit("gpt-3.5-turbo", "generator")<CR>', { noremap = true, silent = true })
          vim.api.nvim_set_keymap('v', '<leader>cc', ':lua ChatGPTSubmit("gpt-3.5-turbo", "")<CR>',          { noremap = true, silent = true })
          vim.api.nvim_set_keymap('v', '<leader>cp', ':lua ChatGPTPrompt()<CR>',                               { noremap = true, silent = true })

          vim.api.nvim_set_keymap('v', '<leader>c4r', ':lua ChatGPTSubmit("gpt-4", "reviewer")<CR>',  { noremap = true, silent = true })
          vim.api.nvim_set_keymap('v', '<leader>c4i', ':lua ChatGPTSubmit("gpt-4", "improver")<CR>',  { noremap = true, silent = true })
          vim.api.nvim_set_keymap('v', '<leader>c4e', ':lua ChatGPTSubmit("gpt-4", "explainer")<CR>', { noremap = true, silent = true })
          vim.api.nvim_set_keymap('v', '<leader>c4g', ':lua ChatGPTSubmit("gpt-4", "generator")<CR>', { noremap = true, silent = true })
          vim.api.nvim_set_keymap('v', '<leader>c4c', ':lua ChatGPTSubmit("gpt-4", "")<CR>',          { noremap = true, silent = true })
        end
    }
end
