local keymap = vim.keymap.set
local opts = { silent = true }

-- Search clarity
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)
keymap("n", "<leader>/", ":noh<CR>", opts)

-- Split navigation
keymap("n", "<A-h>", "<C-w>h", opts)
keymap("n", "<A-j>", "<C-w>j", opts)
keymap("n", "<A-k>", "<C-w>k", opts)
keymap("n", "<A-l>", "<C-w>l", opts)
keymap("n", "<A-s>", ":vsplit<CR>", opts)
keymap("n", "<A-S>", ":split<CR>", opts)
keymap("n", "<A-]>", ":vertical resize +5<CR>", opts)
keymap("n", "<A-[>", ":vertical resize -5<CR>", opts)
keymap("n", "<A-}>", ":resize +5<CR>", opts)
keymap("n", "<A-{>", ":resize -5<CR>", opts)
keymap("n", "<A-=>", "<C-w>=")

-- Save and quit
keymap("n", "<C-s>", ":w<CR>", opts)
keymap("i", "<C-s>", "<Esc>:w<CR>gi", opts)
keymap("n", "<C-q>", ":q<CR>", opts)
keymap("i", "<C-q>", "<Esc>:q<CR>", opts)

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
    lsp_keymaps = lsp_keymaps
}
