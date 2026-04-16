return {
    -- Syntax tree
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
}
