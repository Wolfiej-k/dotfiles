return {
    -- LSP configuration
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "williamboman/mason.nvim", build = ":MasonUpdate", config = true },
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local mason = require("mason")
            local mason_lsp = require("mason-lspconfig")

            mason.setup()
            mason_lsp.setup({
                ensure_installed = {
                    "clangd",
                    "lua_ls",
                    "pyright",
                    "marksman",
                    "jsonls",
                    "jdtls",
                    "bashls",
                    "cmake",
                    "sqlls",
                    "texlab",
                    "ocamllsp",
                },
                automatic_installation = true,
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                desc = "LSP keymaps",
                callback = function(event)
                    local keymaps = require("config.keymaps")
                    keymaps.lsp_keymaps(event)
                end,
            })
        end,
    },

    -- Neovim API
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
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
