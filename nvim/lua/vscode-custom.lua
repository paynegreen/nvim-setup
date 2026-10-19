vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local vscode = require("vscode")
local opt = vim.opt

local bookmark = {
  toggle = function()
    vim.fn.VSCodeNotify("bookmarks.toggle")
  end,
  list = function()
    vim.fn.VSCodeNotify("bookmarks.list")
  end,
}

local cursor = {
  agent = function()
    vim.fn.VSCodeNotify("composerMode.agent")
  end,
}

local editor = {
  save = function()
    vim.fn.VSCodeNotify("workbench.action.files.save")
  end,
  navigateLeft = function()
    vim.fn.VSCodeNotify("workbench.action.navigateLeft")
  end,
  navigateRight = function()
    vim.fn.VSCodeNotify("workbench.action.navigateRight")
  end,
  navigateTop = function()
    vim.fn.VSCodeNotify("workbench.action.navigateTop")
  end,
  navigateDown = function()
    vim.fn.VSCodeNotify("workbench.action.navigateDown")
  end,
  noHighlight = function()
    vim.fn.VSCodeNotify(":nohl")
  end,
  closeBuffer = function()
    vim.fn.VSCodeNotify("workbench.action.closeActiveEditor")
  end,
  closeOtherBuffer = function()
    vim.fn.VSCodeNotify("workbench.action.closeOtherEditors")
  end,
  replaceSelected = function()
    local saved_reg = vim.fn.getreg('"')
    vim.cmd('execute "normal! vgvy"')
    local pattern = vim.fn.escape(vim.fn.getreg('"'), "\\/.*'$^~[]")
    pattern = vim.fn.substitute(pattern, "\n$", "", "")
    vim.fn.feedkeys(":%s/" .. pattern .. "/")
    vim.fn.setreg('"', saved_reg)
    vim.fn.setreg("/", pattern)
    vim.fn.setcmdline(":%s/" .. pattern .. "/")
  end,
  goToDefinitionSplit = function()
    vscode.call("workbench.action.splitEditorRight")
    vscode.call("editor.action.revealDefinition")
  end,
  toggleTerminal = function()
    vim.fn.VSCodeNotify("workbench.action.terminal.toggleTerminal")
  end,
  stageHunk = function()
    vim.fn.VSCodeNotify("git.stageSelectedRanges")
  end,
  resetHunk = function()
    vim.fn.VSCodeNotify("git.unstageSelectedRanges")
  end,
}

local project = {
  findFile = function()
    vim.fn.VSCodeNotify("workbench.action.quickOpen")
  end,
  tree = function()
    vim.fn.VSCodeNotify("workbench.view.explorer")
  end,
  list = function()
    vim.fn.VSCodeNotify("workbench.actions.view.problems")
  end,
}

-- bookmark
vim.keymap.set({ "n" }, "<leader>m", bookmark.toggle)
vim.keymap.set({ "n" }, "<leader>b", bookmark.list)

-- cursor
vim.keymap.set({ "n" }, "<leader>a", cursor.agent)

-- editor
vim.keymap.set("n", "<leader>w", editor.save)
vim.keymap.set("n", ",w", editor.save)
vim.keymap.set("n", "<leader>/", [[<cmd>lua require('vscode').action('workbench.action.findInFiles')<cr>]])
vim.keymap.set("n", "u", "<Cmd>call VSCodeNotify('undo')<CR>")
vim.keymap.set("n", "<C-r>", "<Cmd>call VSCodeNotify('redo')<CR>")
vim.keymap.set("n", "<C-j>", editor.navigateDown)
vim.keymap.set("n", "<C-k>", editor.navigateTop)
vim.keymap.set("n", "<C-h>", editor.navigateLeft)
vim.keymap.set("n", "<C-l>", editor.navigateRight)
vim.keymap.set("n", "<leader>n", editor.noHighlight)
vim.keymap.set("n", "<leader>bd", editor.closeBuffer)
vim.keymap.set("n", "<leader>bg", editor.closeOtherBuffer)
vim.keymap.set("n", "<leader>xx", project.list)
vim.keymap.set("v", ",r", editor.replaceSelected)
vim.keymap.set("n", "gv", editor.goToDefinitionSplit)
vim.keymap.set("n", "<leader>yp", "<Cmd>let @+ = expand('%:')<CR>")
vim.keymap.set("n", "<leader>yl", "<Cmd>let @+ = expand('%:'). ':' .line('.')<CR>")
vim.keymap.set("n", "<leader>tt", editor.toggleTerminal)
vim.keymap.set("n", "<leader>ghs", editor.stageHunk)
vim.keymap.set("n", "<leader>ghr", editor.resetHunk)

-- project
vim.keymap.set({ "n" }, "<leader><leader>", project.findFile)
vim.keymap.set({ "n" }, "<leader>e", project.tree)

-- options
opt.clipboard = "unnamedplus"
opt.cursorline = true
opt.relativenumber = true
opt.spelllang = { "en" }
