require("cmp")
require("lspconfig")

require("mason").setup({
  ensure_installed = {
    "stylua",
    "shfmt",
  },
})

require("mason-lspconfig").setup()

vim.lsp.config('dexter', {
  cmd = { 'dexter', 'lsp' },
  root_markers = { '.dexter.db', '.git', 'mix.exs' },
  filetypes = { 'elixir', 'eelixir', 'heex' },
  init_options = {
    followDelegates = true, -- jump through defdelegate to the target function
    -- stdlibPath = "",      -- override Elixir stdlib path (auto-detected)
    -- debug = false,        -- verbose logging to stderr (view with :LspLog)
  },
})

vim.lsp.enable 'dexter'
