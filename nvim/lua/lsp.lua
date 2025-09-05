require("cmp")
require("lspconfig")

require("mason").setup({
  ensure_installed = {
    "stylua",
    "shfmt",
  },
})

require("mason-lspconfig").setup()
