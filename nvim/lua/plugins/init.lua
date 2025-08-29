local plugins = {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  {
    "terrastruct/d2-vim",
    ft = { "d2" },
  },
  {
    "ravsii/tree-sitter-d2",
    ft = "d2",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    build = "make nvim-install",
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "ruff",
        "flake8",
        "debugpy",
        "lua-language-server",
        "rust-analyzer",
        "stylua",
        "html-lsp",
        "css-lsp",
        "prettier",
        "xmlformatter",
        "lemminx",
        "prettier",
        "pyright",
      },
    },
  },
  {
    "tpope/vim-fugitive",
    lazy = false,
  },
  {
    -- I added this config so i only see file/folders colored relevatn to git status and nothing else
    "nvim-tree/nvim-tree.lua",
    opts = {
      git = {
        enable = true,
        show_on_dirs = true, -- Only show git status on files, not parent directories
        show_on_open_dirs = false, -- Show git status on folders when they contain changes but are collapsed
      },
      renderer = {
        highlight_git = true,
        special_files = {}, -- Disable yellow highlighting for README.md
        highlight_diagnostics = false,
        highlight_opened_files = "none",
        highlight_modified = "none",
        icons = {
          show = {
            git = true,
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)
      -- Remove red color from executable files
      vim.api.nvim_set_hl(0, "NvimTreeExecFile", {})
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    ft = { "python", "yaml" },
    config = function()
      require "configs.null_ls"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "rust",
        "python",
        "d2",
        "markdown",
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
  },
  {
    "nvim-neotest/nvim-nio",
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = require "configs.dap_ui",
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap",
    },
  },
  require "plugins.avante",
}
