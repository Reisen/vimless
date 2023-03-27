-- A Neovim function that is expected to be bound to a keymap.
--
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
        reviewer  = "You are a senior software engineer tasked with reviewing a pull request. You must search for bugs, inconsistent formatting, inconsistent or poor variable naming, logic errors, security vulnerabilities, memory leaks, poor documentation, and other issues. You should include suggested code changes where possible.",
        improver  = "You are a senior software engineer tasked with improving code. You must search for bugs, inconsistent formatting, inconsistent or poor variable naming, logic errors, security vulnerabilities, memory leaks, poor documentation, and other issues. Your reply should be exactly, and only, the code you have improved.",
        explainer = "You are a senior software engineer tasked with explaining code. You must search for bugs, inconsistent formatting, inconsistent or poor variable naming, logic errors, security vulnerabilities, memory leaks, poor documentation, and other issues. Explain the code and your findings.",
        generator = "You are tasked with producing code from an explanation. The code should be high quality and follow best practices, a be kept short when possible. Variable names should be clear but not overly long. The code should be well documented and easy to understand. Your reply should only contain the code.",
    })[mode]

    -- Submit the result to ChatGPT.
    local cmd = string.format([[
        curl -s \
            -H 'Content-Type: application/json' \
            -H 'Authorization: Bearer %s' \
            -d '%s' \
            https://api.openai.com/v1/chat/completions
    ]], api_key, vim.fn.json_encode({
        model       = 'gpt-3.5-turbo',
        messages    = {
            { role = "system", content = system_role, },
            { role = "user",   content = text,        },
        },
        max_tokens  = 4000,
        temperature = 0.9,
        top_p       = 1,
    }))

    local result = vim.fn.system(cmd)
    local json = vim.fn.json_decode(result).choices[1].message.content:gsub("^%s*(.-)%s*$", "%1")
    vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, vim.split(json, "\n"))
end

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

          -- Bind our custom GPT to <leader>c during visual mode.
          vim.api.nvim_set_keymap('v', '<leader>cr', ':lua ChatGPTSubmit("reviewer")<CR>',  { noremap = true, silent = true })
          vim.api.nvim_set_keymap('v', '<leader>ci', ':lua ChatGPTSubmit("improver")<CR>',  { noremap = true, silent = true })
          vim.api.nvim_set_keymap('v', '<leader>ce', ':lua ChatGPTSubmit("explainer")<CR>', { noremap = true, silent = true })
          vim.api.nvim_set_keymap('v', '<leader>cg', ':lua ChatGPTSubmit("generator")<CR>', { noremap = true, silent = true })
          vim.api.nvim_set_keymap('v', '<leader>cc', ':lua ChatGPTSubmit("")<CR>',          { noremap = true, silent = true })
        end
    }
end
