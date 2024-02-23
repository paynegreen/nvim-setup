local Util = require("lazyvim.util")

return {
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "elixir-ls",
        "tailwindcss-language-server",
        "terraform-ls",
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      -- local luasnip = require("luasnip")
      local cmp = require("cmp")
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- they way you will only jump inside the snippet region
            -- elseif luasnip.expand_or_jumpable() then
            --   luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          -- elseif luasnip.jumpable(-1) then
          --   luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
      table.insert(opts.sources, 1, {
        name = "codeium",
        group_index = 1,
        priority = 100,
      })
      table.insert(opts.sources, { name = "emoji" })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader><space>", Util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
    },
    opts = {
      defaults = {
        mappings = {
          n = {
            ["s"] = "file_vsplit",
            ["o"] = "file_edit",
          },
        },
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    event = "VeryLazy",
    dependencies = {
      "s1n7ax/nvim-window-picker",
      config = function()
        require("window-picker").setup({
          autoselect_one = true,
          include_current = false,
          filter_rules = {
            -- filter using buffer options
            bo = {
              -- if the file type is one of following, the window will be ignored
              filetype = { "neo-tree", "neo-tree-popup", "notify", "quickfix", "edgy" },
              -- if the buffer type is one of following, the window will be ignored
              buftype = { "terminal" },
            },
          },
          other_win_hl_color = "#9d7cd8",
        })
      end,
    },
    opts = {
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },
      window = {
        mappings = {
          ["o"] = "open_with_window_picker",
          ["S"] = "split_with_window_picker",
          ["s"] = "vsplit_with_window_picker",
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "terraform",
        "javascript",
        "json",
        "elixir",
        "lua",
        "markdown",
        "markdown_inline",
        "query",
        "regex",
        "vim",
        "yaml",
        "heex",
      },
    },
  },
  {
    "nvim-tree/nvim-web-devicons",
  },
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
  },
  {
    "tpope/vim-fugitive",
  },
  {
    "linrongbin16/gitlinker.nvim",
    config = function()
      require("gitlinker").setup()
    end,
  },
  {
    "echasnovski/mini.surround",
    enabled = false,
  },
  {
    "tpope/vim-surround",
  },
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
}
