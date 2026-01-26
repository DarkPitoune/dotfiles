-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load settings first (includes mapleader)
require("settings")

-- Load plugins
require("lazy").setup({
  { import = "plugins" },
})

-- Load keymaps and autocmds after plugins
require("keymaps")
require("autocmds")
