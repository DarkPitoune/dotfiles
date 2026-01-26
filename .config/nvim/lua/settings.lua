-- Leader key
vim.g.mapleader = " "

-- Editor options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.autoread = true
vim.opt.clipboard = "unnamedplus"
vim.opt.scrolloff = 16

-- Search options
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Folding
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99

-- Diagnostics
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
  },
})

-- Make word highlights more visible (for snacks.words)
vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#3a3a4a", underline = false })
vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "#3a3a4a", underline = false })
vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#3a3a4a", underline = false })
