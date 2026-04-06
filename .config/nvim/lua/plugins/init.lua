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
                    keymaps.lsp_keymaps(event)
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
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "copilot" },
                    { name = "buffer" },
                    { name = "path" },
                }),
            })
        end,
    },

    -- Snippet collection
    {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()

            local ls = require("luasnip")
            local s = ls.snippet
            local i = ls.insert_node
            local fmta = require("luasnip.extras.fmt").fmta
            
            ls.config.set_config({
                enable_autosnippets = true,
                update_events = "TextChanged,TextChangedI",
            })

            local function in_mathmode()
                return vim.fn['vimtex#syntax#in_mathzone']() == 1
            end

            local function no_backslash_before()
                return function(line_to_cursor)
                    return not line_to_cursor:match("\\_$") and not line_to_cursor:match("\\%^$")
                end
            end

            local function no_curly_after()
                return vim.fn.getline('.'):sub(vim.fn.col('.'), vim.fn.col('.')) ~= '{'
            end

            local function auto_trigger()
                return in_mathmode() and no_backslash_before() and no_curly_after()
            end

            ls.add_snippets("tex", {
s("align", fmta(
[[
\begin{align*}
    <>
\end{align*}
]], 
                    { i(1) }
                )),
                s("solution", fmta(
[[
\begin{solution}
    <>
\end{solution}
]], 
                    { i(1) }
                )),
                s("left", fmta([[\left(<>\right)]], { i(1) })),
                s("frac", fmta([[\frac{<>}{<>}]], { i(1), i(2) })),
                s("sum", fmta([[\sum_{<>}^{<>}]], { i(1), i(2) })),
                s("prod", fmta([[\prod{<>}^{<>}]], { i(1), i(2) })),
                s("rm", fmta([[\mathrm{<>}]], { i(1) })),
                s({ trig = "_", wordTrig = false, snippetType = "autosnippet" },
                    fmta([[_{<>}]], { i(1) }), { condition = auto_trigger }),
                s({ trig = "^", wordTrig = false, snippetType = "autosnippet" },
                    fmta([[^{<>}]], { i(1) }), { condition = auto_trigger }),
            })
        end,
    },

    -- Copilot server
    {
        "zbirenbaum/copilot.lua",
        dependencies = { "copilotlsp-nvim/copilot-lsp" },
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                panel = { enabled = false },
                suggestion = { enabled = false },
                disable_limit_reached_message = false,
            })
        end,
    },

    -- Copilot autocomplete
    {
        "zbirenbaum/copilot-cmp",
        config = function()
            require("copilot_cmp").setup()
        end,
    },

    -- Syntax highlighting and indentation
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local ts = require("nvim-treesitter")
            ts.prefer_git = true
            ts.install({
                "c", "cpp", "python", "sql", "bash", "json", "make", "perl",
                "cmake", "lua", "vim", "vimdoc", "regex", "markdown",
                "markdown_inline",
            })

            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local lang = vim.bo[args.buf].filetype
                    if lang == "tex" then
                        return
                    end
                    pcall(vim.treesitter.start, args.buf)
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
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
        config = function()
            local pairs = require("mini.pairs")
            pairs.setup()
            pairs.map_buf(0, "i", "$", {
                action = "closeopen",
                pair = "$$",
                neigh_pattern = "[^%w\\].",
            })
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
