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
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("treesitter-context").setup({
        enable = true,
        max_lines = 3,
        trim_scope = 'outer',
        mode = 'cursor',
        separator = nil,
      })
    end,
  },
}
