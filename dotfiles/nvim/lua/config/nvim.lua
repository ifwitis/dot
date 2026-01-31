-- Keybinding
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
vim.keymap.set('t', '<C-t>', '<C-\\><C-n><C-w><C-p>', { noremap = true, silent = true })
--vim.keymap.set('n', '<C-w>t', toggle_terminal{ noremap = true, silent = true })
vim.keymap.set('n', '<C-w>e', ":enew<CR>", { noremap = true, silent = true })
vim.keymap.set({'n','v','i'}, '<C-q>', '<Esc>:qa!<CR>', { noremap = true, silent = true})
vim.keymap.set('t', '<C-q>', '<C-\\><C-n>:q<CR>', { noremap = true, silent = true})

-- Set Indentation defaults
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.number = true


local function start_terminal()
    -- Close any currently open terminal windows
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local bufr = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_buf_get_option(bufr, 'buftype') == 'terminal' then
            vim.api.nvim_win_close(win, false)
    	end
    end

    -- Check if any terminal buffers are running
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
            if vim.api.nvim_buf_get_option(buf, 'buftype') == 'terminal' then
                --vim.api.nvim_buf_delete(buf, { force = true })
                vim.cmd("bot 5split")
                vim.api.nvim_win_set_buf(0, buf)
                vim.cmd("startinsert")
                return
            end
        end
    end

    vim.cmd("bot 5split | terminal")
    vim.cmd("startinsert")
end
vim.keymap.set('n', '<C-t>', start_terminal, { noremap = true, silent = true })

--[[
-- Auto Open Terminal
vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    nested = true,
    callback = function()
        require("nvim-tree.api").tree.open()
        start_terminal()
    end,
})
--]]

-- Auto Start Insert in Terminal
--[[
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        if vim.bo.buftype == "terminal" then
            vim.cmd("startinsert")
        end
    end,
})
]]



