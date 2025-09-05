local cmp = require("cmp")

local lspconfig = require("lspconfig")
require("mason").setup({
  build = ":MasonUpdate",
  opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
      },
    },
})
require("mason-lspconfig").setup()
