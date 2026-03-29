vim.opt["tabstop"] = 2
vim.opt["shiftwidth"] = 2
vim.o.number = true
vim.o.clipboard = "unnamedplus"
vim.o.undofile = true
vim.o.undodir = "/home/kos/neovim/undo/"
vim.o.signcolumn = 'yes'
vim.g.mapleader = " "
vim.o.showmode = false

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } }
  }
vim.o.linebreak = true


