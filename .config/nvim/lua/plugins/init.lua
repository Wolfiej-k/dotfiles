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

    -- LSP configuration
    {
        "neovim/nvim-lspconfig",
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
                    keymaps.lsp_keymaps(event.buf)
                end,
            })
        end,
    },

    -- LSP autocomplete
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },
                }),
            })
        end,
    },

    -- Syntax highlighting and indentation
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = {
                    "c",
                    "cpp",
                    "python",
                    "sql",
                    "bash",
                    "json",
                    "make",
                    "perl",
                    "cmake",
                    "lua",
                    "vim",
                    "vimdoc",
                    "regex",
                    "markdown",
                    "markdown_inline",
                },
                highlight = { enable = true },
                indent = { enable = true },
            }
        end,
    },

    -- Show block context
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "VeryLazy",
        config = function()
            require("treesitter-context").setup({
                max_lines = 4,
                trim_scope = "outer",
                mode = "cursor",
            })
        end,
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
								{ win = "input", height = 1, border = "bottom" },
								{ win = "list", border = "none" },
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

    -- Tmux integration
    {
        "mrjones2014/smart-splits.nvim",
        config = function()
            local splits = require("smart-splits")
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
        end,
    },

    -- File browser
    {
        "echasnovski/mini.files",
        lazy = false,
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

    -- Comment toggling
    {
        "echasnovski/mini.comment",
        version = false,
        event = "VeryLazy",
        config = function()
            require("mini.comment").setup()
        end,
    },

    -- Insert matching pairs
    {
        "echasnovski/mini.pairs",
        version = false,
        event = "InsertEnter",
        config = true,
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
