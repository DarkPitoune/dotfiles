return {
  dir = vim.fn.stdpath("config") .. "/lua",
  name = "keytracker",
  config = function()
    require("keytracker").setup({
      -- Log file location (default: ~/.local/share/nvim/keytracker.log)
      -- log_file = vim.fn.expand("~/keytracker.log"),

      -- Include timestamp with each keypress
      include_timestamps = true,

      -- Include current mode (NORMAL, INSERT, etc.)
      include_mode = true,

      -- Flush to disk every N keypresses (higher = better performance)
      buffer_size = 50,
    })
  end,
}
