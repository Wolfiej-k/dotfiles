return {
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
        event = "InsertEnter",
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
        event = "VeryLazy",
        opts = {
            modes = { insert = true, command = false, terminal = false },
            mappings = {
                [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
                ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
                ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
                ["["] = {
                    action = "open",
                    pair = "[]",
                    neigh_pattern = ".[%s%z%)}%]]",
                    register = { cr = false },
                },
                ["{"] = {
                    action = "open",
                    pair = "{}",
                    neigh_pattern = ".[%s%z%)}%]]",
                    register = { cr = false },
                },
                ["("] = {
                    action = "open",
                    pair = "()",
                    neigh_pattern = ".[%s%z%)]",
                    register = { cr = false },
                },
                ['"'] = {
                    action = "closeopen",
                    pair = '""',
                    neigh_pattern = "[^%w\\][^%w]",
                    register = { cr = false },
                },
                ["'"] = {
                    action = "closeopen",
                    pair = "''",
                    neigh_pattern = "[^%w\\][^%w]",
                    register = { cr = false },
                },
                ["`"] = {
                    action = "closeopen",
                    pair = "``",
                    neigh_pattern = "[^%w\\][^%w]",
                    register = { cr = false },
                },
            },
        },
        config = function(_, opts)
            local pairs = require("mini.pairs")
            pairs.setup(opts)

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "tex",
                callback = function(args)
                    pairs.map_buf(args.buf, "i", "$", {
                        action = "closeopen",
                        pair = "$$",
                        neigh_pattern = "[^%w\\][^%w]",
                    })
                end,
            })
        end,
    },
}
