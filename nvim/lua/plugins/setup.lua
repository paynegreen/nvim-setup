local M = {
  {
    "nvim-mini/mini.nvim",
    config = function()
      require("mini.pairs").setup()
    end
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      {
        'b0o/nvim-tree-preview.lua',
      },
    },
    config = function()
      require("nvim-tree").setup({
        actions = {
          open_file = {
            quit_on_open = true
          }
        },
        renderer = {
          indent_markers = {
            enable = true,
          },
        },
        diagnostics = {
          enable = true,
          show_on_dirs = true,
        },
        filters = {
          custom = {
            "^.git$",
          },
        },
        view = {
          side = "right",
        },
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")
          local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end
          local preview = require('nvim-tree-preview')

          api.config.mappings.default_on_attach(bufnr)

          vim.keymap.set("n", "s", api.node.open.vertical, opts("Open: Vertical Split"))

          vim.keymap.set('n', '<C-p>', preview.watch, opts 'Preview (Watch)')
          vim.keymap.set('n', '<Esc>', preview.unwatch, opts 'Close Preview/Unwatch')
          vim.keymap.set('n', '<C-f>', function() return preview.scroll(4) end, opts 'Scroll Down')
          vim.keymap.set('n', '<C-b>', function() return preview.scroll(-4) end, opts 'Scroll Up')
          vim.keymap.set('n', '<Tab>', function()
            local ok, node = pcall(api.tree.get_node_under_cursor)
            if ok and node then
              if node.type == 'directory' then
                api.node.open.edit()
              else
                preview.node(node, { toggle_focus = true })
              end
            end
          end, opts 'Preview')
        end
      })
    end
  },
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },
}

return M
