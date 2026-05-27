return {
    -- LSP configuration
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "williamboman/mason.nvim", build = ":MasonUpdate", config = true },
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp"
        },
        config = function()
            local mason = require("mason")
            local mason_lsp = require("mason-lspconfig")

            local servers = {
                "clangd", "lua_ls", "pyright", "marksman", "jsonls",
                "jdtls", "bashls", "cmake", "sqlls", "texlab", "ocamllsp"
            }

            mason.setup()
            mason_lsp.setup({
                ensure_installed = servers,
            })

            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            for _, server in ipairs(servers) do
                local server_caps = capabilities
                if server == "clangd" then
                    server_caps = vim.deepcopy(capabilities)
                    server_caps.offsetEncoding = { "utf-8", "utf-16" }
                end

                vim.lsp.config(server, {
                    capabilities = server_caps,
                })

                vim.lsp.enable(server)
            end

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
}
