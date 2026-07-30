local dashboard_header = [[
                             
     ▄▄                       
    ██             █▄         
 ▀▀▄██▄         ▀▀▄██▄▀▀      
 ██ ██▀█▄ █▄ ██▀██ ██ ██ ▄██▀█
 ██ ██ ██▄██▄██ ██ ██ ██ ▀███▄
▄██▄██  ▀██▀██▀▄██▄██▄███▄▄██▀
    ██                        
   ▀▀                         
                                ]]

return {
    'folke/snacks.nvim',
    event = 'VimEnter',
    config = function()
        require("snacks").setup({
            dashboard = {
                width    = 48,
                pane_gap = 32,
                preset = {
                    header = dashboard_header,
                },
                sections = {
                    { section = "header" },
                    { section = "keys", gap = 1, padding = 1, pane = 1 },
                    { section = "recent_files", icon = " ", title = "Recent Files", padding = 1, limit = 5 },
                },            
            },
        })
    end,
}
