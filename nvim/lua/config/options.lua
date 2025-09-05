vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.autoformat = true

local opt = vim.opt

opt.autowrite = true
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.cursorline = true
opt.confirm = true
opt.expandtab = true
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldlevel = 99
opt.ignorecase = true
opt.mouse = "a"
opt.number = true
opt.linebreak = true
opt.list = true
opt.relativenumber = true
opt.ruler = false
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true  -- Round indent
opt.shiftwidth = 2     -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false   -- Dont show mode since we have a statusline
opt.sidescrolloff = 8  -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true   -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { "en" }
opt.splitbelow = true  -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true
opt.scrolloff = 4
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.wrap = true
