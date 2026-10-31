local M = {}

local function send(sequence)
    if vim.env.TMUX then
        sequence = "\27Ptmux;"
            .. sequence:gsub("\27", "\27\27")
            .. "\27\\"
    elseif vim.env.TERM_PROGRAM ~= "ghostty" then
        return
    end

    vim.api.nvim_ui_send(sequence)
end

function M.sync()
    local hl = vim.api.nvim_get_hl(0, { name = "Normal" })

    local sequence = ""

    if hl.fg then
        sequence = sequence .. string.format("\27]10;#%06x\7", hl.fg)
    else
        sequence = sequence .. "\27]110\7"
    end

    if hl.bg then
        sequence = sequence .. string.format("\27]11;#%06x\7", hl.bg)
    else
        -- Transparent theme: restore Ghostty's default background.
        sequence = sequence .. "\27]111\7"
    end

    send(sequence)
end

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
    callback = function()
        vim.schedule(M.sync)
    end,
})

return M
