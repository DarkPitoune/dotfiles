-- LSP keymaps (telescope-specific)
vim.keymap.set("n", "<leader>s", function()
  require("telescope.builtin").lsp_document_symbols()
end, { desc = "Document symbols" })
vim.keymap.set("n", "<leader>ws", function()
  require("telescope.builtin").lsp_workspace_symbols()
end, { desc = "Workspace symbols" })

-- Diagnostics
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show error" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics list" })

-- Treesitter context
vim.keymap.set("n", "[c", function()
  require("treesitter-context").go_to_context()
end, { desc = "Jump to context" })

-- Quick close for reference/quickfix lists
vim.keymap.set("n", "<Esc>", "<cmd>cclose<CR><cmd>lclose<CR>", { desc = "Close quickfix/location list" })

-- Fix all problems (ESLint + Prettier)
vim.keymap.set("n", "<leader>f", function()
  vim.cmd("silent! EslintFixAll")
  require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
end, { desc = "Fix all problems (ESLint + Prettier)" })

-- Buffer navigation
vim.keymap.set('n', '<Tab>', ':bnext<CR>', { silent = true, desc = "Next buffer" })
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { silent = true, desc = "Previous buffer" })
vim.keymap.set('n', '<leader>x', ':bp | bd #<CR>', { silent = true, desc = "Close current buffer" })
vim.keymap.set('n', '<leader><leader>', '<cmd>Telescope buffers<cr>', { desc = "Quick buffer access" })

-- Telescope
vim.keymap.set("n", "<leader>ff", function() require("telescope.builtin").find_files() end, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", function() require("telescope.builtin").live_grep() end, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fw", function() require("telescope.builtin").grep_string() end, { desc = "Grep current word" })
vim.keymap.set("n", "<leader>fb", function() require("telescope.builtin").buffers() end, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, { desc = "Help tags" })
vim.keymap.set("n", "<leader>fr", function() require("telescope.builtin").oldfiles() end, { desc = "Recent files" })

-- File explorer
vim.keymap.set("n", "<leader>b", ":Neotree toggle<CR>", { desc = "Toggle file explorer" })
vim.keymap.set("n", "<leader>o", ":Neotree focus<CR>", { desc = "Focus file explorer" })
vim.keymap.set("n", "<leader>nf", ":Neotree reveal<CR>", { desc = "Reveal file in tree" })

-- Search and replace
vim.keymap.set('n', '<leader>Sr', '<cmd>GrugFar<CR>', { desc = "Toggle search and replace" })
vim.keymap.set('n', '<leader>sw', '<cmd>lua require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })<CR>', { desc = "Search current word" })
vim.keymap.set('v', '<leader>sw', '<cmd>lua require("grug-far").with_visual_selection({ prefills = { paths = vim.fn.expand("%") } })<CR>', { desc = "Search selection" })
vim.keymap.set('n', '<leader>sp', '<cmd>lua require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })<CR>', { desc = "Search in current file" })

-- Snacks.nvim
vim.keymap.set('n', '<leader>gg', function() require("snacks").lazygit() end, { desc = "LazyGit" })
vim.keymap.set('n', '<leader>gb', function() require("snacks").git.blame_line() end, { desc = "Git blame line" })
vim.keymap.set('n', '<leader>gB', function() require("snacks").gitbrowse() end, { desc = "Git browse" })
vim.keymap.set('n', '<leader>gf', function() require("snacks").lazygit.log_file() end, { desc = "Lazygit current file history" })
vim.keymap.set('n', '<leader>gl', function() require("snacks").lazygit.log() end, { desc = "Lazygit log (cwd)" })
vim.keymap.set('n', '<leader>.', function() require("snacks").scratch() end, { desc = "Toggle scratch buffer" })
vim.keymap.set('n', '<leader>S', function() require("snacks").scratch.select() end, { desc = "Select scratch buffer" })
vim.keymap.set('n', '<leader>nh', function() require("snacks").notifier.show_history() end, { desc = "Notification history" })
vim.keymap.set('n', '<leader>bd', function() require("snacks").bufdelete() end, { desc = "Delete buffer" })
vim.keymap.set('n', '<leader>cR', function() require("snacks").rename() end, { desc = "Rename file" })
vim.keymap.set('t', '<esc>', '<cmd>close<cr>', { desc = "Hide terminal" })
vim.keymap.set('n', '<c-/>', function() require("snacks").terminal() end, { desc = "Toggle terminal" })
vim.keymap.set('n', '<c-_>', function() require("snacks").terminal() end, { desc = "which_key_ignore" })

-- Console.log macro
vim.keymap.set("n", "<leader>cl", function()
  local word = vim.fn.expand("<cword>")
  vim.cmd("normal! ]m")
  vim.cmd("normal! o")
  vim.api.nvim_put({ "console.log('" .. word .. "', " .. word .. ");" }, "l", false, true)
end, { noremap = true, silent = true })

-- Toggle centered cursor
vim.keymap.set('n', '<leader>zz', function()
  if vim.wo.scrolloff == 16 then
    vim.wo.scrolloff = 0
  else
    vim.wo.scrolloff = 16
  end
end, { desc = 'Toggle centered cursor' })
