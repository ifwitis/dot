-- Helper function alias for vim.keymap.set
local function Map(mode, lhs, rhs, opts) 
    local defaults = { remap = false, silent = true }
    local opts = vim.tbl_deep_extend('force', defaults, opts or {})
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- Helper function to perform a command and reset cursor positions
local function cursor_preserve_func(force_insert, cmd)
    -- Snapshot old state
    local old_line = vim.api.nvim_get_current_line()
    local old_len = string.len(old_line)
    
    local cursor = vim.api.nvim_win_get_cursor(0)
    local row = cursor[1]
    local old_col = cursor[2]
    
    -- Run the native comment engine
    vim.cmd.normal({ cmd, bang = false })
    
    -- Snapshot new state with target offset calculation
    local new_line = vim.api.nvim_get_current_line()
    local new_len = string.len(new_line)
    local comment_offset = new_len - old_len
    local target_col = old_col + comment_offset
    
    -- Boundary check
    if target_col > new_len then
        target_col = new_len
    elseif target_col < 0 then
        target_col = 0
    end
    
    -- Restore calibrated cursor position
    vim.api.nvim_win_set_cursor(0, { row, target_col })
    
    -- Restore insert mode, if triggered from insert mode
    if force_insert then
        vim.cmd("startinsert")
    end
end


-- =======================================================================
-- =========================== GENERAL KEYMAPS ===========================
-- =======================================================================

------------------------------------------------------
--------------- Visual Line Editing ------------------
------------------------------------------------------

-- Line Moving
Map("v", "J", ":m '>+1<CR>gv=gv") -- Visual > J to move line up one
Map("v", "K", ":m '<-2<CR>gv=gv") -- Visual > K to move line down one

-- Indenting
Map('v', '<Tab>', '>gv', { desc = 'Indent: Shift block right' })  -- Visual > Tab to Indent Shift Right
Map('v', '<S-Tab>', '<gv', { desc = 'Indent: Shift block left' }) -- Visual > Shift+Tab to Indent Shift Left

-- Delete Selection
Map("v", "<BS>", '"_d', { desc = "Delete selection without copying" }) -- Visual > Backspace


------------------------------------------------------
-------------- Command Line Keybinds -----------------
------------------------------------------------------

-- Delete word
Map("c", "<M-BS>", "<C-w>", { desc = "Delete word backward" }) -- Backspace


------------------------------------------------------
--------------- Insert Mode Keybinds -----------------
------------------------------------------------------

-- Move cursor forward and backward
Map('i', '<M-b>', '<Esc>bi', { desc = 'Shift left one word' })     -- Option/Alt + Left
Map('i', '<M-f>', '<Esc>lwi', { desc = 'Shift right one word' })   -- Option/Alt + Right

-- Delete word
Map("i", "<M-BS>", "<C-w>", { desc = "Delete word backward" })     -- Option/Alt + Backspace

-- Selection
Map("i", "<S-Left>", "<Esc>v",  { desc = "Start line selection left" })          -- Shift + Left
Map("i", "<S-Right>", "<Esc>llv", { desc = "Start line selection right" })       -- Shift + Right
Map("i", "<S-Up>", "<Esc>kV", { desc = "Start line selection up" })              -- Shift + Up
Map("i", "<S-Down>", "<Esc>Vj", { desc = "Start line selection down" })          -- Shift + Down

-- Undo/Redo
Map("i", "<C-z>", "<C-o>u", { desc = "Undo" })      -- CTRL + Z
Map("i", "<C-S-z>", "<C-o><C-r>", { desc = "Redo" })  -- CTRL + SHIFT + Z
Map("i", "<C-y>", "<C-o><C-r>", { desc = "Redo" })  -- CTRL + Y



------------------------------------------------------
--------------- Commenting Shortcuts -----------------
------------------------------------------------------
-- <C-/>  = Modern terminal/GUI translation for Ctrl + /
-- <D-/>  = GUI translation for Command + / (If using Neovide/Mac keys)
local comment_keys = { '<C-/>', '<D-/>' }
for _, key in ipairs(comment_keys) do
    -- NORMAL MODE: Toggle current line comment, preserving cursor position
    Map('n', key, function() 
        cursor_preserve_func(false, 'gcc')
    end, { remap = true, desc = 'Comment: Toggle line' })

    -- INSERT MODE: Toggle current line comment, preserving cursor and insert mode
    Map('i', key, function() 
        cursor_preserve_func(true, 'gcc')
    end, { desc = 'Comment: Toggle line' })

    -- VISUAL MODE: Toggle the highlighted block
    Map('v', key, 'gcgv', { remap = true, desc = 'Comment: Toggle block' })
end


------------------------------------------------------
----------------- Buffer Shortcuts -------------------
------------------------------------------------------

-- Buffer navigation with TAB/Shift+TAB
Map('n', '<Tab>', '<cmd>bnext<CR>', { desc = 'Next buffer' })
Map('n', '<S-Tab>', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })



-- ================================================================================================================================================================



-- =======================================================================
-- ============================ PLUGIN KEYMAPS ===========================
-- =======================================================================

-- =======================================================================
-- Mkdnflow Keymaps (Filetype Specific)
-- =======================================================================

-- ENTER/<CR>: Go to the navigation link in a Markdown file
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "rmd" },
    callback = function()
        Map('n', '<CR>', '<Cmd>MkdnEnter<CR>', { 
            buffer = true, 
            desc = 'Mkdn enter' 
        })
    end,
})

-- CMD+L: Toggle To-Do list in a Markdown file
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "rmd" },
    callback = function()
        Map({'n', 'i'}, '<D-l>', '<Cmd>MkdnToggleToDo<CR>', { 
            buffer = true, 
            desc = 'Mkdn toggle to-do list' 
        })
    end,
})

-- ENTER: Create a new list item
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "rmd" },
    callback = function()
        Map('i', '<CR>', '<cmd>MkdnNewListItem<CR>', { 
            buffer = true,
            desc = "Auto-continue markdown list items" 
        })
    end
})


-- =============================================================================
-- Blink.cmp Keymaps (Conditional Completion Logic)
-- =============================================================================

-- Find blink keymaps in ../plugins/blink.cmp

-- =============================================================================
-- Telescope Keymaps
-- =============================================================================

-- Defaults:
Map('n', '<leader>fd', function() require('telescope.builtin').find_files() end, { desc = 'Telescope find files' })
Map('n', '<leader>fg', function() require('telescope.builtin').live_grep() end, { desc = 'Telescope live grep' })
Map('n', '<leader><leader>', function() require('telescope.builtin').oldfiles() end, {desc = 'Telescope old files' })


-- =============================================================================
-- Neotree Keymaps
-- =============================================================================
Map("n", "<C-n>", ":Neotree filesystem reveal left<CR>", {})
Map("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})


-- =============================================================================
-- Multicursor Keymaps
-- =============================================================================
