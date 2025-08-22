local keymap = vim.keymap.set
local opts = { silent = true }

-- Search clarity
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)
keymap("n", "<leader>/", ":noh<CR>", opts)

-- Save and quit
keymap("n", "<C-s>", ":w<CR>", opts)
keymap("i", "<C-s>", "<Esc>:w<CR>gi", opts)
keymap("n", "<C-q>", ":q<CR>", opts)
keymap("i", "<C-q>", "<Esc>:q<CR>", opts)

-- Split keymaps
local function split_keymaps(splits)
    keymap("n", "<A-h>", splits.move_cursor_left, opts)
    keymap("n", "<A-j>", splits.move_cursor_down, opts)
    keymap("n", "<A-k>", splits.move_cursor_up, opts)
    keymap("n", "<A-l>", splits.move_cursor_right, opts)
    keymap("n", "<A-o>", splits.resize_left, opts)
    keymap("n", "<A-p>", splits.resize_right, opts)
    keymap("n", "<A-O>", splits.resize_up, opts)
    keymap("n", "<A-P>", splits.resize_down, opts)
    keymap("n", "<A-s>", ":vsplit<CR>", opts)
    keymap("n", "<A-S>", ":split<CR>", opts)
    keymap("n", "<A-=>", "<C-w>=")
end

-- LSP keymaps
local function lsp_keymaps(bufnr)
    local lsp_opts = vim.tbl_extend("force", opts, { buffer = bufnr })
    local diagnostic = vim.diagnostic
    local lsp = vim.lsp.buf

    keymap("n", "L", diagnostic.open_float, lsp_opts)
    keymap("n", "K", lsp.hover, lsp_opts)
    keymap("n", "gd", lsp.definition, lsp_opts)
    keymap("n", "gD", lsp.declaration, lsp_opts)
    keymap("n", "gi", lsp.implementation, lsp_opts)
    keymap("n", "gt", lsp.type_definition, lsp_opts)
    keymap("n", "gr", lsp.references, lsp_opts)
    keymap("n", "gs", lsp.signature_help, lsp_opts)
end

return {
    split_keymaps = split_keymaps,
    lsp_keymaps = lsp_keymaps
}
