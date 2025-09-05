local plugins = {
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  "nvim-treesitter/nvim-treesitter-textobjects",
  {
    "lewis6991/gitsigns.nvim", opts = { current_line_blame = true, },
  },
  "mason-org/mason.nvim",
  "mason-org/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  -- Snippets
  "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip",
  -- Quickfix replacement of sorts
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      padding = false,
      modes = { symbols = { win = { size = 50 } } },
    }
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      highlight = {
        pattern = [[.*<(KEYWORDS)\s]], -- pattern or table of patterns, used for highlighting (vim regex)
      },
      search = {
        -- regex that will be used to match keywords.
        -- don't replace the (KEYWORDS) placeholder
        -- pattern = [[\b(KEYWORDS):]], -- ripgrep regex
        pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
      },
    },
  },
  -- Key Discovery
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = require("keys"),
  },
  -- devicons
  { "nvim-tree/nvim-web-devicons",     lazy = true },
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      update_focused_file = { enable = true },
      view = { width = 40 },
    },
  },

  "ryanoasis/vim-devicons",
  -- tokyonight
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "moon" },
  },
  -- UI
  {
    'nvim-telescope/telescope.nvim',
    opts = {
      defaults = {
        mappings = {
          n = {
            ["s"] = "file_vsplit",
            ["o"] = "file_edit"
          }
        }
      }
    }
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        theme = "tokyonight",
        sections = {
          lualine_c = {
            "filename",
          },
          lualine_x = {
            "noice",
            "encoding",
            "fileformat",
            "filetype",
            {
              require("autoformat").print_autoformat,
              on_click = require("autoformat").toggle_autoformat,
            },
          },
        },
      })
    end,
  },
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      options = {
        offsets = {
          {
            filetype = "NvimTree",
            text = "NvimTree",
            highlight = "Directory",
            text_align = "left"
          }
        }
      }
    }
  },
  {
    "folke/noice.nvim",
    enabled = true,
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = false,        -- use a classic bottom cmdline for search
        command_palette = false,      -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false,       -- add a border to hover docs and signature help
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module='...'` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  },
  -- Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    },
  },
  {
    "petertriho/cmp-git",
    config = true,
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- QoL
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      indent = { enabled = true, exclude = { "Trouble", "gitsigns" } },
      input = { enabled = true },
      explorer = { enabled = false },
      notifier = { enabled = true },
      scope = { enabled = true, exclude = { "Trouble", "gitsigns" } },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { "stylua" }
      }
    }
  },
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    opts = {
      appearance = {
        nerd_font_variant = 'mono'
      },
      completion = { documentation = { auto_show = false } },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
      signature = { enabled = true },
      keymap = {
        preset = "enter",
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
      },
    },
    opts_extend = { "sources.default" }
  },
  {
    "tpope/vim-surround",
  },
  { "kosayoda/nvim-lightbulb" },
  {
    "nvim-mini/mini.nvim",
    version = '*',
  },
  {
    "MagicDuck/grug-far.nvim",
  }
}

return plugins
