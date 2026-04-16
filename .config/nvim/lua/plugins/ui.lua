return {
    -- Color scheme
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("tokyonight-night")
            vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#7aa2f7" })
        end,
    },

    -- Highlight word
    {
        "echasnovski/mini.cursorword",
        version = false,
        event = "VeryLazy",
        config = true,
    },

    -- Highlight patterns
    {
        "echasnovski/mini.hipatterns",
        version = false,
        event = "VeryLazy",
        config = function()
            local hipatterns = require("mini.hipatterns")
            hipatterns.setup({
                highlighters = {
                    todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
                    note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            })
        end,
    },

    -- Icon definitions
    {
        "echasnovski/mini.icons",
        version = false,
        event = "VeryLazy",
        config = true,
    },

    -- Statusline
    {
        "echasnovski/mini.statusline",
        version = false,
        event = "VeryLazy",
        config = function()
            require("mini.statusline").setup({
                use_icons = true,
                set_vim_settings = true,
            })
        end,
    },
}
