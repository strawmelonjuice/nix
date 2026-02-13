return {
    {
        "folke/snacks.nvim",
        opts = {
            explorer = {
                enabled = false,
            },
            dashboard = {
                preset = {
                    pick = function(cmd, opts)
                        return LazyVim.pick(cmd, opts)()
                    end,
                    header = [[
===================================================================
-------------------------   Mar's Nvim!   -------------------------
===================================================================




]],
                    -- Commented out my LazyVim-style header, bit grotesque, innit?
                    -- header = [[
                    --
                    -- ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
                    -- ░░░░░░░░░░░░░   ░░░░░░░   ░░░░░░░░░░░░░░░░░░░░   ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   ░░░░░░░░░   ░   ░   ░░░░░░░   ░░░░░░░░░░░░
                    -- ▒▒▒▒▒▒▒▒▒▒▒▒▒  ▒   ▒▒▒    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒   ▒▒▒▒▒▒▒   ▒▒   ▒  ▒   ▒▒▒    ▒▒▒▒▒▒▒▒▒▒▒▒
                    -- ▒▒▒▒▒▒▒▒▒▒▒▒▒   ▒   ▒ ▒   ▒▒▒▒   ▒▒▒▒▒  ▒    ▒▒▒▒▒▒     ▒▒▒▒▒▒▒▒▒▒▒▒▒▒   ▒   ▒▒▒▒▒   ▒▒▒▒▒   ▒▒▒   ▒   ▒   ▒ ▒   ▒▒▒▒▒▒▒▒▒▒▒▒
                    -- ▓▓▓▓▓▓▓▓▓▓▓▓▓   ▓▓   ▓▓   ▓▓   ▓▓   ▓▓▓   ▓▓▓▓▓▓▓▓   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓   ▓▓   ▓▓▓▓   ▓▓▓   ▓▓▓▓   ▓   ▓▓   ▓▓   ▓▓▓▓▓▓▓▓▓▓▓▓
                    -- ▓▓▓▓▓▓▓▓▓▓▓▓▓   ▓▓▓  ▓▓   ▓   ▓▓▓   ▓▓▓   ▓▓▓▓▓▓▓▓▓▓    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓   ▓▓   ▓▓▓▓▓   ▓   ▓▓▓▓▓   ▓   ▓▓▓  ▓▓   ▓▓▓▓▓▓▓▓▓▓▓▓
                    -- ▓▓▓▓▓▓▓▓▓▓▓▓▓   ▓▓▓▓▓▓▓   ▓   ▓▓▓   ▓▓▓   ▓▓▓▓▓▓▓▓▓▓▓▓   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓   ▓▓   ▓▓▓▓▓▓     ▓▓▓▓▓▓   ▓   ▓▓▓▓▓▓▓   ▓▓▓▓▓▓▓▓▓▓▓▓
                    -- █████████████   ███████   ███   █    █    ████████      ██████████████    ██   ███████   ███████   █   ███████   ████████████
                    -- █████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
                    -- ]],

                    -- stylua: ignore
                    ---@type snacks.dashboard.Item[]
                    keys = {
                        { icon = "", key = "f", desc = "Find File",       action = ":lua Snacks.dashboard.pick('files')" },
                        { icon = "", key = "/", desc = "Find Text",       action = ":lua Snacks.dashboard.pick('live_grep')" },
                        { icon = "", key = "e", desc = "Explorer",        action = ":lua Snacks.explorer({ layout = { layout = { position = \"right\" } } })" },
                        { icon = "", key = "r", desc = "Recent Files",    action = ":lua Snacks.dashboard.pick('oldfiles')" },
                        { icon = "", key = "s", desc = "Restore Session", section = "session" },
                        { icon = "", key = "j", desc = "LazyJJ",          action = ":Lazyjj" },
                        { icon = "", key = "g", desc = "LazyGit",         action = ":LazyGit" },
                        { icon = "", key = "q", desc = "Quit",            action = ":qa" },
                    },
                },
            },
        },
    },
}
