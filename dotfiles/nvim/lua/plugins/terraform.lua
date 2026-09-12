return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "terraform", "hcl", "bash" })
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "terraform-ls",
        "tflint",
        "bash-language-server",
        "shellcheck",
        "shfmt",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        terraformls = {},
        tflint = {},
        bashls = {
          filetypes = { "sh", "bash", "zsh" },
        },
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local null_ls = require("null-ls")
      opts.sources = opts.sources or {}
      vim.list_extend(opts.sources, {
        null_ls.builtins.formatting.terraform_fmt,
        null_ls.builtins.diagnostics.terraform_validate,
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.diagnostics.shellcheck,
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>ls",
        function()
          require("telescope.builtin").lsp_document_symbols()
        end,
        desc = "LSP Symbols (Buffer)",
      },
      {
        "<leader>lS",
        function()
          require("telescope.builtin").lsp_workspace_symbols()
        end,
        desc = "LSP Symbols (Workspace)",
      },
    },
  },
}
