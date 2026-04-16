return {
    -- Better motions
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function() require("flash").jump() end,
                desc = "Flash"
            },
            {
                "S",
                mode = { "n", "x", "o" },
                function() require("flash").treesitter() end,
                desc = "Flash Treesitter"
            },
        },
    },

    -- File picker and fuzzy finder
    {
        "folke/snacks.nvim",
        keys = {
            {
                "<leader>ff",
                function()
                    Snacks.picker.files()
                end,
                desc = "Find Files",
            },
            {
                "<leader>fg",
                function()
                    Snacks.picker.grep()
                end,
                desc = "Grep Live",
            },
            {
                "<leader>fs",
                function()
                    Snacks.picker.grep_word()
                end,
                desc = "Grep String",
                mode = { "n", "x" },
            },
        },
        opts = {
            picker = {
                enabled = true,
                layouts = {
                    default = {
                        layout = {
                            box = "horizontal",
                            border = "none",
                            backdrop = false,
                            row = -1,
                            col = 0,
                            width = 0.7,
                            height = 0.5,
                            {
                                box = "vertical",
                                border = "single",
                                title = "{title}",
                                title_pos = "left",
                                width = 0.4,
                                { win = "input", height = 1,     border = "bottom" },
                                { win = "list",  border = "none" },
                            },
                            {
                                win = "preview",
                                border = "single",
                                title = "{preview:Preview}",
                                title_pos = "left",
                                width = 0.6,
                            },
                        },
                    },
                },
            },
        },
        config = true,
    },

    -- File browser
    {
        "echasnovski/mini.files",
        version = false,
        keys = {
            {
                "<leader>e",
                function()
                    local files = require("mini.files")
                    local path = vim.api.nvim_buf_get_name(0)
                    if vim.fn.filereadable(path) == 1 then
                        files.open(path)
                    else
                        files.open(vim.loop.cwd())
                    end
                    files.reveal_cwd()
                end,
                desc = "Open File Explorer",
            }
        },
        opts = {
            options = {
                use_as_default_explorer = true,
            },
        },
        config = true,
    },

    -- Better marks
    {
        "chentoast/marks.nvim",
        event = "VeryLazy",
        opts = {},
    },
}
