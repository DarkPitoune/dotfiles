-- Bootstrap lazy.nvim plugin manager
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

-- Plugin setup
require("lazy").setup({
  -- ============================================================================
  -- COLORSCHEME
  -- ============================================================================
  {
    "nobbmaestro/nvim-andromeda",
    dependencies = {
      { "tjdevries/colorbuddy.nvim", branch = "dev" }
    },
    priority = 1000,
    config = function()
      require("andromeda").setup({
        transparent_background = false,
      })
      vim.cmd.colorscheme("andromeda")
    end,
  },

  -- ============================================================================
  -- LSP & COMPLETION
  -- ============================================================================
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "eslint", "tailwindcss", "gopls", "pyright", "ruff" }
      })

      -- Configure installed LSP servers automatically
      local lspconfig = require("lspconfig")
      local mason_lspconfig = require("mason-lspconfig")

      -- Get the list of installed servers and configure them
      local installed_servers = mason_lspconfig.get_installed_servers()
      for _, server_name in ipairs(installed_servers) do
          lspconfig[server_name].setup({})
      end

      -- ESLint auto-fix on save and LSP keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local bufnr = args.buf

          -- Set up LSP keymaps for this buffer
          local opts = { buffer = bufnr }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gs", function()
            vim.cmd("vsplit")
            vim.lsp.buf.definition()
          end, { buffer = bufnr, desc = "Go to definition in vsplit" })
          vim.keymap.set("n", "<leader>t", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "<leader>i", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<leader>r", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

          -- ESLint auto-fix is handled by the BufWritePost autocmd below
        end,
      })
    end,
  },

  -- Enhanced TypeScript support
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("typescript-tools").setup({
        settings = {
          jsx_close_tag = {
            enable = true,
            filetypes = { "javascriptreact", "typescriptreact" },
          },
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
          },
        }
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        completion = {
          autocomplete = { 'TextChanged' },
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "javascript", "typescript", "tsx", "css", "html", "lua", "markdown", "markdown_inline", "json", "yaml", "go", "python" },
        highlight = { enable = true },
        indent = { enable = true },
      })
      -- Associate .mdc files with markdown
      vim.filetype.add({
        extension = {
          mdc = "markdown",
        },
      })
    end,
  },

  -- Show function/class context at top of window (sticky scroll)
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

  -- Auto-close JSX/TSX tags
  {
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require('nvim-ts-autotag').setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false
        },
      })
    end,
  },

  -- ============================================================================
  -- FORMATTING
  -- ============================================================================
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          css = { "prettier" },
          html = { "prettier" },
          json = { "prettier" },
          go = { "gofmt" },
          python = { "ruff_format", "ruff_organize_imports" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },

  -- ============================================================================
  -- UI & APPEARANCE
  -- ============================================================================
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          icons_enabled = true,
        },
      })
    end,
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          separator_style = "slant",
          always_show_bufferline = true,
          show_buffer_close_icons = true,
          show_close_icon = false,
          diagnostics = "nvim_lsp",
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              highlight = "Directory",
              text_align = "left",
            },
          },
        },
      })
    end,
  },

  {
    'NvChad/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup({
        user_default_options = {
          tailwind = true,
          css = true,
        }
      })
    end,
  },

  -- ============================================================================
  -- NAVIGATION & FILE MANAGEMENT
  -- ============================================================================
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git/" },
          preview = {
            filesize_limit = 0.1, -- MB
          },
          layout_config = {
            preview_width = 0.6,
          },
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            preview = {
              treesitter = false,
              msg_bg_fillchar = "╱",
            },
          },
          live_grep = {
            preview = {
              treesitter = false,
              msg_bg_fillchar = "╱",
            },
          },
        },
      })
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        window = {
          width = 40,
        },
        filesystem = {
          follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
          },
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
          },
        },
      })
    end,
  },

  {
    "justinmk/vim-sneak",
    config = function()
      vim.g['sneak#label'] = 1
      vim.g['sneak#use_ic_scs'] = 1
    end,
  },

  -- ============================================================================
  -- SEARCH & REPLACE
  -- ============================================================================
  {
    "MagicDuck/grug-far.nvim",
    config = function()
      require('grug-far').setup({})
    end,
  },

  -- ============================================================================
  -- GIT INTEGRATION
  -- ============================================================================
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- ============================================================================
  -- EDITING ENHANCEMENTS
  -- ============================================================================
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

  -- Multi-cursor support (VS Code-like)
  {
    "mg979/vim-visual-multi",
    branch = "master",
  },

  -- ============================================================================
  -- REACT DEVELOPMENT
  -- ============================================================================
  -- Package.json management
  {
    "vuki656/package-info.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    config = function()
      require("package-info").setup()
    end,
  },

  -- Emmet for HTML/JSX expansion
  {
    "mattn/emmet-vim",
    ft = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact" },
    config = function()
      vim.g.user_emmet_leader_key = '<C-e>'
    end,
  },

  -- ============================================================================
  -- SNACKS.NVIM - Collection of useful utilities
  -- ============================================================================
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("snacks").setup({
        -- Dashboard
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
        -- Notification system
        notifier = {
          enabled = true,
          timeout = 3000,
        },
        -- Quick file operations
        quickfile = { enabled = true },
        -- Status column enhancements
        statuscolumn = { enabled = true },
        -- Word highlighting
        words = { enabled = true },
        -- Scroll animations
        scroll = { enabled = false },
        -- Indentation guides
        indent = {
          enabled = true,
          scope = {
            enabled = true,
          },
        },
        -- Git integration
        git = { enabled = true },
        -- LazyGit integration
        lazygit = { enabled = true },
        -- Terminal integration
        terminal = { enabled = true },
        -- Toggle term functionality
        toggle = { enabled = true },
      })
    end,
  },
})

-- ============================================================================
-- SWEEP-EDIT - Next-edit predictions via Ollama
-- ============================================================================
-- Local plugin for AI-powered next-edit suggestions using sweep-next-edit model
-- Keymaps: <C-y> accept | <C-]> reject | <C-\> trigger manually
-- Commands: :SweepEdit enable/disable/toggle/trigger/health
require("sweep-edit").setup({
  ollama = {
    host = "http://localhost:11434",
    model = "sweep-next-edit",
    timeout = 15000,
  },
  trigger = {
    auto = true,
    debounce_ms = 1000,  -- Wait 1s after editing before suggesting
  },
  keymaps = {
    accept = "<C-y>",
    reject = "<C-]>",
    trigger = "<C-\\>",
  },
  debug = false,
})

-- ============================================================================
-- NEOVIM SETTINGS
-- ============================================================================
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

-- Auto-commands
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  pattern = "*",
  command = "checktime"
})

-- Auto-save on focus lost, buffer leave, and insert leave
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave", "InsertLeave" }, {
  pattern = "*",
  callback = function()
    -- Only save if buffer is modified, has a filename, and is a normal file
    if vim.bo.modified and vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
      vim.cmd("silent! write")
    end
  end,
})

-- Auto-fix on save for JS/TS files
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
  callback = function()
    vim.cmd("silent! EslintFixAll")
  end,
})

-- Only open neo-tree if opening a file/directory, not on empty nvim
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Don't open neo-tree if we're showing the dashboard
    if vim.fn.argc() > 0 then
      require("neo-tree.command").execute({ action = "show" })
    end
  end,
})

-- ============================================================================
-- KEYMAPS
-- ============================================================================

-- LSP keymaps (telescope-specific ones)
vim.keymap.set("n", "<leader>s", function()
  require("telescope.builtin").lsp_document_symbols()
end, { desc = "Document symbols" })
vim.keymap.set("n", "<leader>ws", function()
  require("telescope.builtin").lsp_workspace_symbols()
end, { desc = "Workspace symbols" })

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show error" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics list" })

-- Treesitter context keymaps
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

-- Telescope keymaps
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

-- Snacks.nvim keymaps
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


-- Personal keymaps - macro
vim.keymap.set("n", "<leader>cl", function()
  local word = vim.fn.expand("<cword>")
  vim.cmd("normal! ]m")
  vim.cmd("normal! o")
  vim.api.nvim_put({ "console.log('" .. word .. "', " .. word .. ");" }, "l", false, true)
end, { noremap = true, silent = true })

-- Set cursor centered
vim.keymap.set('n', '<leader>zz', function()
  if vim.wo.scrolloff == 16 then
    vim.wo.scrolloff = 0
  else
    vim.wo.scrolloff = 16
  end
end, { desc = 'Toggle centered cursor' })
