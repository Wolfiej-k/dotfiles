return {
    -- Color scheme
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("tokyonight-night")
        end,
    },

    -- Revamped UI
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        opts = {
            presets = {
                bottom_search = false,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = false,
                lsp_doc_border = true,
            },
            lsp = {
                progress = { enabled = false },
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            cmdline = {
                view = "cmdline_popup",
                history = {
                    enabled = true,
                    max_length = 100,
                },
            },
            views = {
                cmdline_popup = {
                    position = {
                        row = "99.9%",
                        col = 0,
                    },
                    size = {
                        width = 60,
                        height = "auto",
                    },
                    border = {
                        style = "none",
                    },
                    win_options = {
                        winblend = 0,
                    },
                },
                hover = {
                    border = {
                        style = "single",
                    },
                },
                signature = {
                    border = {
                        style = "single",
                    },
                },
            },
            routes = {
                {
                    filter = { event = "cmdline", kind = "input" },
                    view = "cmdline_popup",
                    opts = {
                        position = {
                            row = "98%",
                            col = 0,
                        },
                        border = {
                            style = "single",
                        },
                    },
                },
            },
        },
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

    -- Navigate between nvim and tmux
    {
        "alexghergh/nvim-tmux-navigation",
        config = function()
            require("nvim-tmux-navigation").setup {
                disable_when_zoomed = true,
                keybindings = {
                    left = "<A-h>",
                    down = "<A-j>",
                    up = "<A-k>",
                    right = "<A-l>",
                },
            }
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
                            width = 0.8,
                            height = 0.8,
                            {
                                box = "vertical",
                                border = "single",
                                title = "{title}",
                                title_pos = "left",
								{ win = "input", height = 1, border = "bottom" },
								{ win = "list", border = "none" },
                            },
                            {
                                win = "preview",
                                border = "single",
                                title = "{preview:Preview}",
                                title_pos = "left",
                                width = 0.6
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
                    require("mini.files").open()
                end,
                desc = "Open File Explorer",
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

    -- Start screen
    {
        "echasnovski/mini.starter",
        version = false,
        config = true,
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

    -- Bufferline
    {
        "echasnovski/mini.tabline",
        version = false,
        event = "VeryLazy",
        config = function()
            require("mini.tabline").setup({
                show_icons = true,
                tabpage_section = "right",
            })
        end,
    },
}
