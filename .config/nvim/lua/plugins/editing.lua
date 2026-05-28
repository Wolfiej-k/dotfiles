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
                    neigh_pattern = ".[%s%z%)}%]$%\\]",
                    register = { cr = false },
                },
                ["{"] = {
                    action = "open",
                    pair = "{}",
                    neigh_pattern = ".[%s%z%)}%]$%\\]",
                    register = { cr = false },
                },
                ["("] = {
                    action = "open",
                    pair = "()",
                    neigh_pattern = ".[%s%z%)%$%\\]",
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
            require("mini.pairs").setup(opts)
        end,
    }
}
