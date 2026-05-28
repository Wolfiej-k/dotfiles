return {
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
