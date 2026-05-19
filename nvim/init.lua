-- bootstrap lazy.nvim, LazyVim and your plugins
if vim.g.vscode then
  require("vscode-custom")
else
  require("config.lazy")
end
