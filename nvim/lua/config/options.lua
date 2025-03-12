-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
local generic_opts = { noremap = true, silent = true }
local mode_adapters = {
  insert_mode = "i",
  normal_mode = "n",
  term_mode = "t",
  visual_mode = "v",
  visual_block_mode = "x",
  command_mode = "c",
}
local key_mappings = {
  insert_mode = {
    ["jj"] = "<ESC>",
    -- Move current line / block with Alt-j/k ala vscode.
    ["<A-j>"] = "<Esc>:m .+1<CR>==gi",
    -- Move current line / block with Alt-j/k ala vscode.
    ["<A-k>"] = "<Esc>:m .-2<CR>==gi",
    ["<D-s>"] = "<cmd>w<cr><esc>",
  },
  normal_mode = {
    [",w"] = ":w!<cr><esc>",
    [",nw"] = ":noa w!<cr>",
    ["<leader>w"] = ":w!<cr><esc>",
    ["<leader>nw"] = ":noa w!<cr>",
    ["<C-e>"] = ":e! ~/.config/nvim/lua/config/options.lua<cr>",
    ["<leader>q"] = ":e! ~/buffer<CR>",
    ["<leader><cr>"] = ":noh<cr>",
    ["<leader>nf"] = ":Neotree<CR>",
    ["gv"] = ":vsplit | lua vim.lsp.buf.definition()<CR>",
    ["gk"] = "<cmd>lua vim.lsp.buf.signature_help()<CR>",
    ["<leader>m"] = "<cmd>Mason<CR>",
    ["gpl"] = "<cmd>Git pull<CR>",
    ["<leader>yp"] = ":let @+ = expand('%:')<CR>",
    ["<leader>yl"] = ":let @+ = expand('%:'). ':' .line('.')<CR>",
    ["<leader><leader>"] = "<cmd>LazyVim.pick('files', { root = false })<CR>",
  },
  visual_mode = {
    -- Better indenting
    ["<"] = "<gv",
    [">"] = ">gv",
    ["$1"] = "<esc>`>a)<esc>`<i(<esc>",
    ["$2"] = "<esc>`>a]<esc>`<i[<esc>",
    ["$3"] = "<esc>`>a}<esc>`<i{<esc>",
    ["$$"] = '<esc>`>a"<esc>`<i"<esc>',
    ["$q"] = "<esc>`>a'<esc>`<i'<esc>",
    ["$e"] = "<esc>`>a`<esc>`<i`<esc>",
    [",r"] = "<cmd>lua VisualSelection()<CR>",
  },
  visual_block_mode = {
    -- Move current line / block with Alt-j/k ala vscode.
    ["<A-j>"] = ":m '>+1<CR>gv-gv",
    ["<A-k>"] = ":m '<-2<CR>gv-gv",
  },
}
for adapter, mode in pairs(mode_adapters) do
  local opt = generic_opts[adapter]
  if type(key_mappings[adapter]) == "table" then
    for k, v in pairs(key_mappings[adapter]) do
      if type(v) == "table" then
        opt = v[2]
        v = v[1]
      end
      vim.keymap.set(mode, k, v, opt)
    end
  end
end
VisualSelection = function()
  local saved_reg = vim.fn.getreg('"')
  vim.cmd('execute "normal! vgvy"')
  local pattern = vim.fn.escape(vim.fn.getreg('"'), "\\/.*'$^~[]")
  pattern = vim.fn.substitute(pattern, "\n$", "", "")
  vim.fn.feedkeys(":%s/" .. pattern .. "/")
  vim.fn.setreg('"', saved_reg)
  vim.fn.setreg("/", pattern)
  -- vim.fn.setcmdline(":%s/" .. pattern .. '/')
end
