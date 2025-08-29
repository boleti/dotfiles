return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false,
  branch = "main",
  build = "make",

  -- Key mappings for NvimTree integration
  keys = {
    {
      "<leader>a+",
      function()
        require("avante.extensions.nvim_tree").add_file()
      end,
      desc = "Avante: Add file from NvimTree",
      ft = "NvimTree",
    },
    {
      "<leader>a-",
      function()
        require("avante.extensions.nvim_tree").remove_file()
      end,
      desc = "Avante: Remove file from NvimTree",
      ft = "NvimTree",
    },
  },

  config = function(_, opts)
    require("avante").setup(opts)

    -- Setup nvim-cmp integration for Avante input
    local cmp = require "cmp"
    cmp.setup.filetype("AvanteInput", {
      sources = cmp.config.sources {
        { name = "luasnip", priority = 100 },
        { name = "avante_commands", priority = 90 },
        { name = "avante_mentions", priority = 80 },
        { name = "avante_files", priority = 70 },
      },
    })
  end,

  opts = {
    -- Core configuration
    mode = "legacy",
    provider = "qwen_coder",
    auto_suggestions_provider = "qwen_coder",

    selector = {
      exclude_auto_select = { "NvimTree" },
    },

    -- UI settings
    windows = {
      width = 50,
      ask = {
        start_insert = false,
      },
      input = {
        prefix = "=>",
        height = 10,
      },
    },

    -- AI providers
    providers = (function()
      local providers = require "configs.avante_providers"

      local custom_config_dir = vim.fn.stdpath "config" .. "-custom"
      local custom_providers_path = custom_config_dir .. "/lua/configs/avante_providers.lua"

      local custom_providers = {}
      if vim.fn.filereadable(custom_providers_path) == 1 then
        custom_providers = dofile(custom_providers_path)
      end

      providers = vim.tbl_deep_extend("force", providers, custom_providers)
      return providers
    end)(),
  },

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-tree/nvim-web-devicons",
    "echasnovski/mini.pick",
    "nvim-telescope/telescope.nvim",
    "ibhagwan/fzf-lua",
    "stevearc/dressing.nvim",
    "folke/snacks.nvim",
  },
}
