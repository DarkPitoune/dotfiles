return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "javascript", "typescript", "tsx", "css", "html", "lua", "markdown", "markdown_inline", "json", "yaml", "go", "python" },
        highlight = { enable = true },
        indent = { enable = true },
      })
      vim.filetype.add({
        extension = {
          mdc = "markdown",
        },
      })
    end,
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("barbecue").setup()
    end,
  },
}
