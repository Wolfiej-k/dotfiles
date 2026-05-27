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

    -- LaTeX integration
    {
        "lervag/vimtex",
        lazy = false,
        init = function()
            vim.g.vimtex_view_method = "general"
            vim.g.vimtex_view_general_viewer = "/home/wolfi/.local/bin/pdfopen.sh"
            vim.g.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"
            vim.g.vimtex_quickfix_open_on_warning = 0
            vim.g.vimtex_indent_ignored_envs = { "document" }
            vim.g.vimtex_indent_lists = {}
            vim.g.vimtex_indent_on_ampersands = 0
        end,
    },

    -- Lean integration
    {
        "Julian/lean.nvim",
        event = { "BufReadPre *.lean", "BufNewFile *.lean" },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            mappings = true,
        }
    },
}
