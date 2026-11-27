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

-- Reload configs
map("n", "<leader>rl", function()
  local plugins = require("lazy.core.config").plugins
  local loaded = {}
  for name, plugin in pairs(plugins) do
    if plugin._.loaded then
      table.insert(loaded, name)
    end
  end

  table.sort(loaded)
  _G.complete_lazy_plugins = function(arglead)
    return vim.tbl_filter(function(name)
      return vim.startswith(name, arglead)
    end, loaded)
  end

  local name = vim.fn.input({
    prompt = "Reload plugin: ",
    completion = "customlist,v:lua.complete_lazy_plugins",
  })

  if name ~= "" and plugins[name] then
    vim.cmd("Lazy reload " .. vim.fn.fnameescape(name))
  end
end, { desc = "Reload Lazy plugin" })

map("n", "<leader>rr", function()
  vim.cmd("source %")
  vim.notify("Reloaded " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
end, { desc = "Reload current config file" })

-- Toggle indent size
map("n", "<leader>ti", function()
  local width = vim.bo.shiftwidth == 2 and 4 or 2
  vim.bo.tabstop = width
  vim.bo.shiftwidth = width
  vim.bo.softtabstop = width
  vim.bo.expandtab = true
  vim.notify("Indentation changed: " .. width .. " spaces")
end, { desc = "Toggle indentation size (2, 4)" })

-- Remap Redo to Leader+U
map('n', 'U', '<C-r>', { desc = "Redo" })
-- Remap Backspace to Delete
map("n", "<BS>", function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  -- edge case: delete empty line itself without yanking
  if #line == 0 then
    return row > 1 and 'k"_dd' or "<Nop>"
  end
  -- edge case: join with previous line
  if col == 0 then
    return row > 1 and "kgJ" or "<Nop>"
  end
  -- edge case: delete end-of-line character
  if col >= #line - 1 then
    return '"_x'
  end
  -- delete character before cursor
  return '"_X'
end, { expr = true, desc = "Smart backspace without yanking" })

------------------------------------------------------
------------------ Visual Effects --------------------
------------------------------------------------------

-- Clear search highlighting
map('n', '<leader>rh', function()
  vim.cmd.nohlsearch()
  vim.notify("Search highlighting cleared")
end, { desc = "Clear search highlighting" })

-- Toggle line wrapping
map('n', '<leader>wr', function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify("Line wrapping set to: " .. (vim.wo.wrap and "enabled" or "disabled"))
end, { desc = "Toggle line wrapping" })

------------------------------------------------------
------------------ Open / Closing --------------------
------------------------------------------------------

-- Close files
map('n', '<leader>qw', '<cmd>w<CR><cmd>lua vim.notify("Buffer saved!")<CR>', { desc = "Save buffer" })
map('n', '<leader>qs', '<cmd>wq<CR>', { desc = "Save and quit buffer" })
map('n', '<leader>qa', '<cmd>wqa<CR>', { desc = "Save all and quit" })
map('n', '<leader>qq', '<cmd>q!<CR>', { desc = "Force quit buffer" })
map('n', '<leader>qf', '<cmd>qa!<CR>', { desc = "Force quit all" })

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
map({ 'v', 'n' }, '<S-k>', '5kzz', { desc = "Scroll up faster" })
map({ 'v', 'n' }, '<S-j>', '5jzz', { desc = "Scroll down faster" })

------------------------------------------------------
---------------- Buffer Navigation -------------------
------------------------------------------------------

-- Buffer navigation (Relies on bufferline)
map('n', '<leader>bb', '<C-^>', { desc = "Alternate buffer" })
map('n', '<leader>bn', '<cmd>BufferLineCycleNext<CR>', { desc = "Next buffer" })
map('n', '<leader>bp', '<cmd>BufferLineCyclePrev<CR>', { desc = "Previous buffer" })
map('n', '<leader>bd', '<cmd>bdelete!<CR>', { desc = "Close buffer" })
map('n', '<leader>bo', '<cmd>BufferLineCloseOthers<CR>', { desc = "Close other buffers" })
for i = 1, 9 do
  map("n", "<leader>b" .. i, function()
    local buffers = require("bufferline").get_elements().elements
    if buffers[i] then
      require("bufferline").go_to(i, true)
    else
      vim.notify("No buffer at position " .. i, vim.log.levels.WARN, { title = "Bufferline" })
    end
  end, { desc = "Go to buffer " .. i })
end

-- Buffer clean-up
local function cleanup_buffers(predicate, delete_opts, label)
  local visible = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    visible[vim.api.nvim_win_get_buf(win)] = true
  end
  local count = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if not visible[buf] and predicate(buf) then
      vim.api.nvim_buf_delete(buf, delete_opts or {})
      count = count + 1
    end
  end
  vim.notify(("Cleaned up %d %s buffer(s)"):format(count, label))
end

map("n", "<leader>bc", function()
  cleanup_buffers(function(buf)
    return vim.bo[buf].buflisted and not vim.bo[buf].modified
  end, {}, "hidden")
end, { desc = "Clean up hidden buffers" })

map("n", "<leader>bC", function()
  cleanup_buffers(function(buf)
    if vim.bo[buf].buflisted then
      return false
    end
    local is_inactive = not vim.api.nvim_buf_is_loaded(buf)
    local is_generic_scratch = vim.bo[buf].buftype == "nofile" and vim.bo[buf].filetype == ""
    return is_inactive or is_generic_scratch
  end, { force = true }, "inactive/scratch")
end, { desc = "Clean up inactive unlisted buffers" })

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
local api = vim.api
local ns = api.nvim_create_namespace('select_all_restore')
local pending_cleanup

local function is_visual(mode)
  return mode == 'v' or mode == 'V' or mode == '\22'
end

map({ 'n', 'v', 'i' }, '<C-a>', function()
  -- Clear any previous unfinished selection tracking
  if pending_cleanup then
    pending_cleanup()
  end

  local original_mode = api.nvim_get_mode().mode
  local was_insert = original_mode:sub(1, 1) == 'i'
  local win = api.nvim_get_current_win()
  local buf = api.nvim_get_current_buf()
  local row, col = unpack(api.nvim_win_get_cursor(win))

  -- Extmark follows the cursor position through text edits
  local mark = api.nvim_buf_set_extmark(buf, ns, row - 1, col, {
    right_gravity = true,
  })

  local autocmd_id
  local cleanup

  cleanup = function()
    if autocmd_id then
      pcall(api.nvim_del_autocmd, autocmd_id)
    end
    if api.nvim_buf_is_valid(buf) then
      pcall(api.nvim_buf_del_extmark, buf, ns, mark)
    end
    if pending_cleanup == cleanup then
      pending_cleanup = nil
    end
  end

  pending_cleanup = cleanup

  local entered_visual = false

  autocmd_id = api.nvim_create_autocmd('ModeChanged', {
    callback = function()
      local old = vim.v.event.old_mode
      local new = vim.v.event.new_mode

      -- Ignore transitions until Select All has entered Visual mode
      if not entered_visual then
        entered_visual = is_visual(new)
        return
      end

      -- Restore only after leaving Visual mode
      if not is_visual(old) or is_visual(new) then
        return
      end

      api.nvim_del_autocmd(autocmd_id)
      autocmd_id = nil

      local function restore()
        if not api.nvim_win_is_valid(win)
            or not api.nvim_buf_is_valid(buf)
            or api.nvim_win_get_buf(win) ~= buf
            or api.nvim_get_current_win() ~= win then
          cleanup()
          return
        end

        local pos = api.nvim_buf_get_extmark_by_id(buf, ns, mark, {})
        cleanup()

        if #pos == 0 then
          return
        end

        -- Clamp row to the current buffer after deletions.
        local line_count = api.nvim_buf_line_count(buf)
        local target_row = math.max(1, math.min(pos[1] + 1, line_count))

        local line = api.nvim_buf_get_lines(
          buf, target_row - 1, target_row, false
        )[1] or ""

        -- Clamp column to the current line.
        local target_col = math.max(0, math.min(pos[2], #line))

        api.nvim_win_set_cursor(win, { target_row, target_col })

        if was_insert then
          if target_col == #line and #line > 0 then
            vim.cmd("startinsert!")
          else
            vim.cmd("startinsert")
          end
        end
      end
      -- Let the Visual operation finish before restoring the cursor
      if new:sub(1, 1) == 'c' then
        api.nvim_create_autocmd('CmdlineLeave', {
          once = true,
          callback = function()
            vim.schedule(restore)
          end,
        })
      else
        vim.schedule(restore)
      end
    end,
  })

  -- Exit current mode, select every line including the final line
  local keys = api.nvim_replace_termcodes('<Esc>ggVG', true, false, true)
  api.nvim_feedkeys(keys, 'n', false)
end, { desc = "Select all and restore cursor/mode" })

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

-- Smart Indent (Matches indent of nearest non-empty line above on an empty line)
map("i", "<Tab>", function()
  -- Preserves blink snippet navigation
  if vim.snippet.active({ direction = 1 }) then
    return "<Cmd>lua vim.snippet.jump(1)<CR>"
  end

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
map("i", "<M-BS>", "<C-w>", { desc = "Delete word backward" }) -- Option/Alt + Backspace

-- Selection
map({ "n", "i" }, "<S-Left>", "<Esc>v", { desc = "Start line selection left" })    -- Shift + Left
map({ "n", "i" }, "<S-Right>", "<Esc>lv", { desc = "Start line selection right" }) -- Shift + Right
map({ "n", "i" }, "<S-Up>", "<Esc>lvk", { desc = "Start line selection up" })      -- Shift + Up
map({ "n", "i" }, "<S-Down>", "<Esc>vj", { desc = "Start line selection down" })   -- Shift + Down

-- Undo/Redo
-- (Mac -- ensure terminal forwards keys properly)
-- Set OPTION+Z, OPTION+SHIFT+Z, OPTION+Y
map("n", "<M-z>", "u", { desc = "Undo" })
map("i", "<M-z>", "<C-o>u", { desc = "Undo" })
for _, key in ipairs({ "<M-S-z>", "<D-y>" }) do
  map("n", key, "<C-r>", { desc = "Redo" })
  map("i", key, "<C-o><C-r>", { desc = "Redo" })
end
-- Set CMD+Z, CMD+SHIFT+Z, CMD+Y
map("n", "<D-z>", "u", { desc = "Undo" })
map("i", "<D-z>", "<C-o>u", { desc = "Undo" })
for _, key in ipairs({ "<D-S-z>", "<D-y>" }) do
  map("n", key, "<C-r>", { desc = "Redo" })
  map("i", key, "<C-o><C-r>", { desc = "Redo" })
end
-- (Windows/General)  --  Set CTRL+Z, CTRL+SHIFT+Z, and CTRL+Y
map("i", "<C-z>", "<C-o>u", { desc = "Undo" })
map("n", "<C-z>", "u", { desc = "Undo" })
for _, key in ipairs({ "<C-S-z>", "<C-y>" }) do
  map("n", key, "<C-r>", { desc = "Redo" })
  map("i", key, "<C-o><C-r>", { desc = "Redo" })
end
---

------------------------------------------------------
------------------- Terminal Mode --------------------
------------------------------------------------------
map('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

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

-- Find plugin keymaps in respective plugins/<plugin>.lua files
