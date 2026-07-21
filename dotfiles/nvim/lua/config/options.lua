------------------------------------------------------------
-- General Neovim settings and configuration
-----------------------------------------------------------

-- Default options are not included
-- See: https://neovim.io/doc/user/vim_diff.html
-- [2] Defaults - *nvim-defaults*

local o = vim.o       -- Set options

-----------------------------------------------------------
-- General
-----------------------------------------------------------
o.mouse = 'a'                       -- Enable mouse support
o.clipboard = 'unnamedplus'         -- Copy/paste to system clipboard
o.cursorline = true                 -- Highlight current line
o.cursorlineopt = "number"          -- Highlight current line number
o.swapfile = false                  -- Don't use swapfile
o.completeopt = 'menuone,noinsert,noselect'  -- Autocomplete options

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
o.number = true           -- Show line numbers
o.relativenumber = true   -- Show relative line numbers
o.showmatch = true        -- Highlight matching parenthesis
o.foldmethod = 'marker'   -- Enable folding (default 'foldmarker')
o.splitright = true       -- Vertical split to the right
o.splitbelow = true       -- Horizontal split to the bottom
o.ignorecase = true       -- Ignore case letters when search
o.smartcase = true        -- Ignore lowercase for the whole pattern
o.linebreak = true        -- Wrap on word boundary
o.laststatus = 3          -- Set global statusline
o.inccommand = "nosplit"    -- Set Ex command previews
o.termguicolors = true    -- Enable 24-bit RGB colors

o.guicursor = "n-v-c:block-Cursor,i-ci-ve:ver25-lCursor,r-cr:hor20,o:hor50"     -- Map GUI Cursor to reflect light/dark mode settings

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
o.expandtab = true        -- Use spaces instead of tabs
o.shiftwidth = 4          -- Shift 4 spaces when tab
o.tabstop = 4             -- 1 tab == 4 spaces
o.smartindent = true      -- Autoindent new lines

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
o.hidden = true           -- Enable background buffers
o.history = 100           -- Remember N lines in history
o.lazyredraw = true       -- Faster scrolling
o.synmaxcol = 240         -- Max column for syntax highlight
o.updatetime = 250        -- ms to wait for trigger an event


