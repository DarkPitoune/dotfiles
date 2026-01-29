return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "eslint", "tailwindcss", "gopls", "pyright", "ruff" },
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({
              on_attach = function(client, bufnr)
                if client.server_capabilities.documentSymbolProvider then
                  require("nvim-navic").attach(client, bufnr)
                end
              end,
            })
          end,
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local function opts(desc)
            return { buffer = bufnr, desc = desc }
          end
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
          vim.keymap.set("n", "gs", function()
            vim.cmd("vsplit")
            vim.lsp.buf.definition()
          end, opts("Go to definition in vsplit"))
          vim.keymap.set("n", "<leader>t", vim.lsp.buf.type_definition, opts("Type definition"))
          vim.keymap.set("n", "<leader>i", vim.lsp.buf.implementation, opts("Go to implementation"))
          vim.keymap.set("n", "<leader>r", vim.lsp.buf.references, opts("Find references"))
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename symbol"))
        end,
      })
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("typescript-tools").setup({
        on_attach = function(client, bufnr)
          if client.server_capabilities.documentSymbolProvider then
            require("nvim-navic").attach(client, bufnr)
          end
        end,
        settings = {
          jsx_close_tag = {
            enable = true,
            filetypes = { "javascriptreact", "typescriptreact" },
          },
        }
      })
    end,
  },
}
