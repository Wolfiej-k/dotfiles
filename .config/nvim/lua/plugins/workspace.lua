return {
    -- Resurrect
    {
        "rmagatti/auto-session",
        config = function()
            require("auto-session").setup({
                log_level = "error",
                auto_session_suppress_dirs = { "~/", "/" },
            })
        end
    },

    -- Tmux integration
    -- TODO: remove, only keybinds are used
    {
        "mrjones2014/smart-splits.nvim",
        event = "VeryLazy",
        config = function()
            local splits = require("smart-splits")
            splits.setup({
                at_edge = "stop",
                multiplexer_integration = false,
            })

            local keymaps = require("config.keymaps")
            keymaps.split_keymaps(splits)
        end,
    },
}
