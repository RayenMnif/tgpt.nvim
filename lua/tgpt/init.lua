local M = {}

local config = {
    buffer_width_ratio = 0.2,
    buffer_height_ratio = 0.9,
    default_prompt = [[
        Provide clear, actionable advice tailored to the user’s specific coding challenge, focusing on key solutions, best practices, and potential pitfalls. Explain simply, avoid unnecessary technical jargon, and ask politely for clarification if more context is needed. Always double-check calculations, logic, and syntax to prevent errors, suggest optimized approaches, highlight common mistakes, provide concise examples, and ensure explanations are immediately understandable. Keep guidance practical, step-by-step, and anticipate edge cases, while maintaining a natural, readable flow that can be absorbed in under five seconds.
    ]],
}

local createBuffer = function()
    WIDTH = vim.api.nvim_get_option("columns")
    HEIGHT = vim.api.nvim_get_option("lines")
    vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
        relative = 'editor',
        width = math.floor(WIDTH * config.buffer_width_ratio),
        height = math.floor(HEIGHT * config.buffer_height_ratio),
        col = WIDTH,
        row = 0,
        anchor = "NE",
        style = 'minimal',
        border = 'single'
    })
end

local InteractiveChat = function()
    createBuffer()
    vim.api.nvim_command("startinsert")
    vim.fn.termopen("tgpt -i", {
        on_exit = function()
            local win_id = vim.api.nvim_get_current_win()
            vim.api.nvim_win_close(win_id, true)
        end
    })
end

local RateMyCode = function()
    local file = vim.api.nvim_buf_get_name(0)
    local prompt = "cat " .. file .. " | tgpt '" .. config.default_prompt .. " Rate the code' "
    createBuffer()
    vim.fn.termopen(prompt)
end

local CheckForBugs = function()
    local file = vim.api.nvim_buf_get_name(0)
    local prompt = "cat " .. file .. " | tgpt '" .. config.default_prompt .. " Check for bugs in the code' "
    createBuffer()
    vim.fn.termopen(prompt)
end


function M.setup(user_config)
    if user_config then
        config = vim.tbl_extend("force", config, user_config)
    end

    local result = vim.fn.executable("tgpt")
    if result == 1 then
        vim.api.nvim_create_user_command("TgptChat", InteractiveChat
        , {
            nargs = 0,
        })
        vim.api.nvim_create_user_command("TgptRateMyCode",
            RateMyCode
            , {
                nargs = 0,
            })
        vim.api.nvim_create_user_command("TgptCheckForBugs",
            CheckForBugs
            , {
                nargs = 0,
            })
    else
        print(
            "[tgpt.nvim] tgpt is not installed on you system\nplease visit the tgpt github page for instructions https://github.com/aandrew-me/tgpt")
    end
end

return M
