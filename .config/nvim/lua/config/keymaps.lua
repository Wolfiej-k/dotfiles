local keymap = vim.keymap.set
local opts = { silent = true }

-- Search highlights
keymap("n", "<leader>/", ":noh<CR>", opts)

--- Save and quit
keymap("n", "<C-w>", ":w<CR>", { silent = true, nowait = true })
keymap("i", "<C-w>", "<Esc>:w<CR>gi", { silent = true, nowait = true })
keymap("n", "<C-q>", ":q<CR>", opts)
keymap("i", "<C-q>", "<Esc>:q<CR>", opts)

-- Split keymaps
keymap("n", "<C-s>", ":vsplit<CR>", opts)
keymap("n", "<C-x>", ":split<CR>", opts)

-- Copy file
keymap("n", "<leader>y", ":%y+<CR>", opts)

local function split_keymaps(splits)
    local function resize_mode()
        keymap("n", "h", splits.resize_left, opts)
        keymap("n", "j", splits.resize_down, opts)
        keymap("n", "k", splits.resize_up, opts)
        keymap("n", "l", splits.resize_right, opts)
        keymap("n", "=", "<C-w>=")
        keymap("n", "<Esc>", function()
            pcall(vim.keymap.del, "n", "h")
            pcall(vim.keymap.del, "n", "j")
            pcall(vim.keymap.del, "n", "k")
            pcall(vim.keymap.del, "n", "l")
        end, opts)
    end

    keymap("n", "<C-h>", splits.move_cursor_left, opts)
    keymap("n", "<C-j>", splits.move_cursor_down, opts)
    keymap("n", "<C-k>", splits.move_cursor_up, opts)
    keymap("n", "<C-l>", splits.move_cursor_right, opts)
    keymap("n", "<C-g>", resize_mode)
end

-- LSP keymaps
local function lsp_keymaps(event)
    local lsp_opts = vim.tbl_extend("force", opts, { buffer = event.buf })
    local diagnostic = vim.diagnostic
    local lsp = vim.lsp

    keymap("n", "L", diagnostic.open_float, lsp_opts)
    keymap("n", "K", lsp.buf.hover, lsp_opts)
    keymap("n", "gd", lsp.buf.definition, lsp_opts)
    keymap("n", "gD", lsp.buf.declaration, lsp_opts)
    keymap("n", "gi", lsp.buf.implementation, lsp_opts)
    keymap("n", "gt", lsp.buf.type_definition, lsp_opts)
    keymap("n", "gr", lsp.buf.references, lsp_opts)
    keymap("n", "gs", lsp.buf.signature_help, lsp_opts)
    keymap("n", "<leader>a", lsp.buf.code_action, lsp_opts)

    local client = lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentFormattingProvider then
        local function format()
            lsp.buf.format({ async = true })
        end
        keymap("n", "<leader>f", format, lsp_opts)
    end
end

return {
    split_keymaps = split_keymaps,
    lsp_keymaps = lsp_keymaps
}
