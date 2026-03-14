return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    require("snacks").setup({
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          {
            section = "recent_files",
            title = "Recent Files",
            cwd = true,
            limit = 8,
            gap = 1,
            padding = 1
          },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      scroll = { enabled = true },
      indent = {
        enabled = true,
        scope = {
          enabled = true,
        },
      },
      git = { enabled = true },
      lazygit = { enabled = true },
      terminal = { enabled = true },
      toggle = { enabled = true },
    })
  end,
}
