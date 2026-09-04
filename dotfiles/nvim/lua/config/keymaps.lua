-- Helper function alias for vim.keymap.set
local function map(mode, lhs, rhs, opts)
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

-- Remap Redo to Leader+U
map('n', '<leader>u', '<C-r>', { desc = "Redo" })
-- Remap Backspace to Delete 
map('n', '<BS>', function()
    local line_len = string.len(vim.api.nvim_get_current_line())
    local col = vim.fn.col('.')
    if line_len == 0 then
        return 'i<BS><Esc>'
    elseif col == line_len then
        return '"_x'
    else
        return '"_<S-x>'
    end
end, { expr = true, desc = "Delete prev character without copying" })

------------------------------------------------------
------------------ Visual Effects --------------------
------------------------------------------------------

-- Remove highlighting
map('n', '<leader>rh', '<cmd>noh<CR>', { desc = "Remove highlighting" })

------------------------------------------------------
------------------ Open / Closing --------------------
------------------------------------------------------

-- Close files
map('n', '<leader>qa', '<cmd>wqa<CR>', { desc = "Save all and quit" })
map('n', '<leader>qq', '<cmd>qa!<CR>', { desc = "Force quit all" })
map('n', '<leader>qw', '<cmd>w<CR><cmd>lua vim.notify("Buffer saved!")<CR>', { desc = "Save buffer" })
map('n', '<leader>qc', '<cmd>wq<CR>', { desc = "Save and quit buffer" })

------------------------------------------------------
---------------- Window Navigation -------------------
------------------------------------------------------

-- Window navigation
map('n', '<leader>wh', '<C-w>h', { desc = "Move to left window" })
map('n', '<leader>wj', '<C-w>j', { desc = "Move to bottom window" })
map('n', '<leader>wk', '<C-w>k', { desc = "Move to top window" })
map('n', '<leader>wl', '<C-w>l', { desc = "Move to right window" })

-- Return focus to previous window
map('n', '<leader>wf', '<C-w>p', { desc = "Return focus to previous window" })

-- Delete window
map('n', '<leader>wd', '<C-w>c', { desc = "Delete current window" })

-- Center screen when jumping
map('n', '<C-u>', '<C-u>zz', { desc = "Half page up, centered" })
map('n', '<C-d>', '<C-d>zz', { desc = "Half page down, centered" })

-- Splitting & Resizing
map('n', '<leader>sv', '<cmd>vsplit<CR>', { desc = "Split window vertically" })
map('n', '<leader>sh', '<cmd>split<CR>', { desc = "Split window horizontally" })
-- map('n', '<M-Up>', '<C-w>+', { desc = "Increase window height" })
-- map('n', '<M-Down>', '<C-w>-', { desc = "Decrease window height" })
-- map('n', '<M-Left>', '<C-w><', { desc = "Decrease window width" })
-- map('n', '<M-Right>', '<C-w>>', { desc = "Increase window width" })

-- Scrolling
map('n', '<S-k>', '5kzz', { desc = "Scroll up faster" })
map('n', '<S-j>', '5jzz', { desc = "Scroll down faster" })

------------------------------------------------------
---------------- Buffer Navigation -------------------
------------------------------------------------------

-- Buffer navigation
map('n', '<leader>bn', '<cmd>bnext<CR>', { desc = "Next buffer" })
map('n', '<leader>bp', '<cmd>bprevious<CR>', { desc = "Previous buffer" })
map('n', '<leader>bd', '<cmd>bdelete!<CR>', { desc = "Close buffer" })

-- Close floating buffers / windows
map("n", "<Esc>", function()
    -- Loop through all open windows and close any that are relative/floating
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative ~= "" then
            vim.api.nvim_win_close(win, true)
        end
    end
end, { desc = "Close floating windows" })

------------------------------------------------------
--------------- Visual Line Editing ------------------
------------------------------------------------------

-- Select All, then return to original cursor position
map({'n', 'v'}, '<C-a>', function()
    local mode = vim.api.nvim_get_mode()["mode"]
    local current_pos = vim.fn.getpos('.')
    vim.cmd('normal! ggVGg$')
    vim.api.nvim_create_autocmd('ModeChanged', {
        buffer = 0,
        once = true,
        callback = function()
            vim.schedule(function ()
                vim.fn.setpos('.', current_pos)
                if mode == 'i' then
                    -- TO-DO: Pressing another key like y to yank, or = to indent doesn't return to insert properly
                    local keys = vim.api.nvim_replace_termcodes('<Esc>i', true, false, true)
                    vim.api.nvim_feedkeys(keys, 'nV', false)
                end
            end)
        end
    })
end, { desc = "Select all, and return" })

-- Line Moving
-- map('v', 'J', ":m '>+1<CR>gv=gv", { desc = "Move line down"}) -- Visual > J to move line up one
-- map('v', 'K', ":m '<-2<CR>gv=gv", { desc = "Move line up" }) -- Visual > K to move line down one

-- Indenting
map('v', '<Tab>', '>gv', { desc = 'Indent: Shift block right' })  -- Visual > Tab to Indent Shift Right
map('v', '<S-Tab>', '<gv', { desc = 'Indent: Shift block left' }) -- Visual > Shift+Tab to Indent Shift Left

-- Delete Selection
map('v', "<BS>", '"_d', { desc = "Delete selection without copying" }) -- Visual > Backspace


------------------------------------------------------
-------------- Command Line Keybinds -----------------
------------------------------------------------------
-- Delete word
map("c", "<M-BS>", "<C-w>", { desc = "Delete word backward" }) -- Backspace


------------------------------------------------------
--------------- Insert Mode Keybinds -----------------
------------------------------------------------------

-- Move cursor forward and backward
-- map('i', '<M-Left>', '<C-o>b', { desc = 'Shift left one word' })     -- Option/Alt + Left
-- map('i', '<M-Right>', '<C-o>w', { desc = 'Shift right one word' })   -- Option/Alt + Right

-- Smart Indent (Matches indent of nearest non-empty line above on an empty line)
map("i", "<Tab>", function()
    local line_num = vim.fn.line('.')
    local col = vim.fn.col('.')
    local before_cursor = vim.fn.getline('.'):sub(1, col - 1)
    -- Only smart-indent when there's nothing but whitespace before the cursor
    if not before_cursor:match("^%s*$") or line_num == 1 then
        return "<Tab>"
    end
    -- Calculate target indent of nearest non-whitespace line above
    local target_indent = nil
    for l = line_num - 1, 1, -1 do
        local line = vim.fn.getline(l)
        if not line:match("^%s*$") then
            target_indent = line:match("^%s*")
            break
        end
    end
    -- No content above at all, just a normal tab
    if not target_indent then
        return "<Tab>"
    end
    -- If not already at indent, auto-format
    if #before_cursor < #target_indent then
        -- Calculate indent from auto-formatting
        local auto_cols = -1
        if vim.bo.indentexpr ~= "" then
            vim.v.lnum = line_num
            local ok, result = pcall(vim.fn.eval, vim.bo.indentexpr)
            if ok then auto_cols = result end
        elseif vim.bo.cindent then
            auto_cols = vim.fn.cindent(line_num)
        elseif vim.bo.lisp then
            auto_cols = vim.fn.lispindent(line_num)
        end
        -- Only use <C-f> if auto-format actually advances our cursor
        if auto_cols > #before_cursor then
            return "<C-f>"
        end
    end
    -- Default Tab fallback
    return "<Tab>"
end, { expr = true, desc = "Smart indent" })

-- Delete word
map("i", "<M-BS>", "<C-w>", { desc = "Delete word backward" })     -- Option/Alt + Backspace

-- Selection
map({ "n", "i" }, "<S-Left>", "<Esc>v",  { desc = "Start line selection left" })        -- Shift + Left
map({ "n", "i" }, "<S-Right>", "<Esc>lv", { desc = "Start line selection right" })      -- Shift + Right
map({ "n", "i" }, "<S-Up>", "<Esc>lvk", { desc = "Start line selection up" })           -- Shift + Up
map({ "n", "i" }, "<S-Down>", "<Esc>vj", { desc = "Start line selection down" })        -- Shift + Down

-- Undo/Redo
-- (Mac)
map("i", "<D-z>", "<C-o>u", { desc = "Undo" })          -- CMD + Z
map("i", "<D-S-z>", "<C-o><C-r>", { desc = "Redo" })    -- CMD + SHIFT + Z
map("i", "<D-y>", "<C-o><C-r>", { desc = "Redo" })      -- CMD + Y
---
map("n", "<D-z>", "u", { desc = "Undo" })          -- CMD + Z
map("n", "<D-S-z>", "<C-r>", { desc = "Redo" })    -- CMD + SHIFT + Z
map("n", "<D-y>", "<C-r>", { desc = "Redo" })      -- CMD + Y
-- (Windows/General)
map("i", "<C-z>", "<C-o>u", { desc = "Undo" })          -- CTRL + Z
map("i", "<C-S-z>", "<C-o><C-r>", { desc = "Redo" })    -- CTRL + SHIFT + Z
map("i", "<C-y>", "<C-o><C-r>", { desc = "Redo" })      -- CTRL + Y
---
map("n", "<C-z>", "u", { desc = "Undo" })          -- CTRL + Z
map("n", "<C-S-z>", "<C-r>", { desc = "Redo" })    -- CTRL + SHIFT + Z
map("n", "<C-y>", "<C-r>", { desc = "Redo" })      -- CTRL + Y


------------------------------------------------------
--------------- Commenting Shortcuts -----------------
------------------------------------------------------
-- <C-_>  = TMUX binding for Ctrl + /
-- <C-/>  = Modern terminal/GUI translation for Ctrl + /
-- <D-/>  = GUI translation for Command + / (If using Neovide/Mac keys)
local comment_keys = { '<C-_>', '<C-/>', '<D-/>' }
for _, key in ipairs(comment_keys) do
    -- NORMAL MODE: Toggle current line comment, preserving cursor position
    map('n', key, function()
        cursor_preserve_func(false, 'gcc')
    end, { remap = true, desc = 'Comment: Toggle line' })

    -- INSERT MODE: Toggle current line comment, preserving cursor and insert mode
    map('i', key, function()
        cursor_preserve_func(true, 'gcc')
    end, { desc = 'Comment: Toggle line' })

    -- VISUAL MODE: Toggle the highlighted block
    map('v', key, 'gc', { remap = true, desc = 'Comment: Toggle block' })
end



-- ================================================================================================================================================================



-- =======================================================================
-- ============================ PLUGIN KEYMAPS ===========================
-- =======================================================================

-- ======================================================================
-- Neovim / Lazy
-- ======================================================================
map('n', '<leader>l', '<cmd>Lazy<CR>', { desc = "Open Lazy" })
---@diagnostic disable-next-line: undefined-global
map('n', '<leader>h', function() Snacks.dashboard.open() end, { desc = "Go to Dashboard Home" })


-- ======================================================================
-- LSP
-- ======================================================================

-- See LSP-related keybinds in lsp/init.lua


-- ======================================================================
-- Themery
-- ======================================================================

map('n', '<leader>th', '<cmd>Themery<CR>', { desc = "Choose a theme" })


-- ======================================================================
-- Fine Cmdline
-- ======================================================================

map('n', ':', function()
    -- Check if the current buffer is locked or a help file
    if vim.bo.modifiable == false or vim.bo.buftype == 'help' then
        -- Fallback immediately to the native, un-breakable cmdline
        vim.api.nvim_feedkeys(':', 'n', true)
    else
        local success, _ = pcall(function()
            require('fine-cmdline').open()
        end)
        if not success then
            vim.api.nvim_feedkeys(':', 'n', true)
        end
    end
end, { desc = "Safe Fine Cmdline Switch" })


-- ======================================================================
-- Mkdnflow 
-- ======================================================================
--
-- Helper function to check if the cursor is before the first actual text word
-- local function cursor_is_before_text()
    --     local line = vim.api.nvim_get_current_line()
    --     local col = vim.api.nvim_win_get_cursor(0)[2] -- 0-indexed column
    --
    --     -- Find the index of the first character that is NOT a space, tab, -, *, +, or digit/dot
    --     local text_start = line:find("[^%s%-%*%+%.%d]")
    --     vim.print(text_start)
    --     if not text_start then
    --         -- If the line only contains spaces or list markers, allow tabbing anywhere
    --         return true
    --     end
    --
    --     -- Lua string indices are 1-based, Neovim cursor column is 0-based
    --     return col < (text_start - 1)
    -- end

    -- ENTER/<CR>: Go to the navigation link in a Markdown file
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "rmd" },
        callback = function()
            map('n', '<CR>', '<Cmd>MkdnEnter<CR>', {
                buffer = true,
                desc = 'Mkdn enter'
            })
        end,
    })

    -- ENTER: Create a new list item
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "rmd" },
        callback = function()
            map('i', '<CR>', '<cmd>MkdnNewListItem<CR>', {
                buffer = true,
                desc = "Auto-continue markdown list items"
            })
        end
    })

    -- TAB/SHIFT+TAB: Smart list indenting
    -- vim.api.nvim_create_autocmd("FileType", {
        --     pattern = { "markdown", "rmd" },
        --     callback = function()
            --         map('i', '<Tab>', function()
                --             if cursor_is_before_text() then
                --                 vim.cmd("MkdnIndentListItem")
                --             else
                --                 vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n", true)
                --             end
                --         end, { desc = "Smart shift right"})
                --
                --
                --         map('i', '<S-Tab>', function()
                    --             if cursor_is_before_text() then
                    --                 vim.cmd("MkdnDedentListItem")
                    --             else
                    --                 vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, true, true), "n", true)
                    --             end
                    --         end, { desc = "Smart shift left"})
                    --     end
                    -- })


                    -- ======================================================================
                    -- Blink.cmp 
                    -- ======================================================================

                    -- Find blink keymaps in ../plugins/blink.cmp
                    -- <Leader>e for showing autocomplete/documentation

                    -- ======================================================================
                    -- Telescope 
                    -- ======================================================================

                    -- Defaults
                    map('n', '<leader><leader><leader>', function() require('telescope.builtin').find_files() end, { desc = 'Telescope find files' })
                    map('n', '<leader>fg', function() require('telescope.builtin').live_grep() end, { desc = 'Telescope live grep' })


                    -- ======================================================================
                    -- Nvim Tree 
                    -- ======================================================================

                    -- Defaults
                    map('n', '<leader>tr', "<cmd>NvimTreeToggle<CR>", { desc = "Toggle File tree" })
                    map('n', '<leader>rt', "<cmd>NvimTreeFocus<CR>", { desc = "Toggle File tree focus" })

                    -- ======================================================================
                    -- Mason 
                    -- ======================================================================

                    -- Defaults
                    map('n', '<leader>m', "<cmd>Mason<CR>", { desc = "Open Mason LSP Manager" })


                    -- ======================================================================
                    -- Multicursor 
                    -- =======================================================================y=
