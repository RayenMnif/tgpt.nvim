local M = {}

local createBuffer = function ()
    WIDTH = vim.api.nvim_get_option("columns")
    HEIGHT = vim.api.nvim_get_option("lines")
    vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
            relative = 'editor',
            width = math.floor(WIDTH / 5),
            height = math.floor(HEIGHT / 1.1),
            col = WIDTH,
            row = 0,
            anchor = "NE",
            style = 'minimal',
            border = 'single'
    })
end

local InteractiveChat = function ()
    createBuffer()
    vim.api.nvim_command("startinsert")
    vim.fn.termopen("tgpt -i", {on_exit = function ()
        local win_id = vim.api.nvim_get_current_win()
        vim.api.nvim_win_close(win_id, true)
    end})
end

local RateMyCode = function ()
   local file = vim.api.nvim_buf_get_name(0)
   local prompt = "cat " .. file .. " | tgpt 'Rate the code' "
   createBuffer()
   vim.fn.termopen(prompt)
end

local CheckForBugs = function ()
   local file = vim.api.nvim_buf_get_name(0)
   local prompt = "cat " .. file .. " | tgpt 'Check for bugs' "
   createBuffer()
   vim.fn.termopen(prompt)
end


function M.setup()
    local result = vim.fn.executable("tgpt")
    if result == 1 then
        vim.api.nvim_create_user_command("Chat", InteractiveChat
        , {
            nargs = 0,
        })
        vim.api.nvim_create_user_command("RateMyCode",
           RateMyCode 
        , {
            nargs = 0,
        })
        vim.api.nvim_create_user_command("CheckForBugs",
            CheckForBugs
        , {
            nargs = 0,
        })
    else
        print("[tgpt.nvim] tgpt is not installed on you system\nplease visit the tgpt github page for instructions https://github.com/aandrew-me/tgpt")
    end
end

return M

