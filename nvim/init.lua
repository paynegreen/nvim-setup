-- Plugins
vim.cmd [[packadd packer.nvim]]
require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use { "neovim/nvim-lspconfig" }
	use { "tamago324/nlsp-settings.nvim" }
	use {
		"jose-elias-alvarez/null-ls.nvim",
	}
	use { "williamboman/mason-lspconfig.nvim" }
	use {
		"williamboman/mason.nvim",
	}
	use { 'dracula/vim', as = 'dracula' }
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	}
	use { 'folke/which-key.nvim' }
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}
	use {
		'nvim-tree/nvim-tree.lua',
		requires = {
			'nvim-tree/nvim-web-devicons',
		},
		tag = 'nightly'
	}
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.0',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}
	use { 'tpope/vim-surround' }
	use {
		'lewis6991/gitsigns.nvim',
	}
	use { 'nvim-lua/popup.nvim' }
	use { 'onsails/lspkind.nvim' }
	use {
		"hrsh7th/nvim-cmp",
		requires = {
			"L3MON4D3/LuaSnip",
		},
	}
	use {
		"rafamadriz/friendly-snippets",
	}
	use {
		"hrsh7th/cmp-nvim-lsp",
	}
	use {
		"saadparwaiz1/cmp_luasnip",
	}
	use {
		"hrsh7th/cmp-buffer",
	}
	use {
		"hrsh7th/cmp-path",
	}
	use {
		"folke/neodev.nvim",
		module = "neodev",
	}
	use {
		"windwp/nvim-autopairs",
	}
	use {
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = "BufReadPost",
	}
	use {
		"numToStr/Comment.nvim",
		config = function()
			require('Comment').setup()
		end
	}
	use {
		"SmiteshP/nvim-navic",
	}
	use {
		"akinsho/bufferline.nvim",
		tag = "v3.*"
	}
	use {
		"b0o/schemastore.nvim",
	}
	use {
		"RRethy/vim-illuminate",
	}
	use {
		"lukas-reineke/indent-blankline.nvim",
	}
	use { 'phaazon/hop.nvim' }
	use { 'folke/trouble.nvim' }
	-- use {
	-- 	"folke/noice.nvim",
	-- 	requires = {
	-- 		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
	-- 		"MunifTanjim/nui.nvim",
	-- 		-- OPTIONAL:
	-- 		--   `nvim-notify` is only needed, if you want to use the notification view.
	-- 		--   If not available, we use `mini` as the fallback
	-- 		"rcarriga/nvim-notify",
	-- 	}
	-- }
	use {
		"smjonas/inc-rename.nvim",
	}
	use {
		"folke/todo-comments.nvim"
	}
	use 'nvim-tree/nvim-web-devicons'
	use {
		'roobert/tailwindcss-colorizer-cmp.nvim'
	}
end)

-- Setup
vim.cmd [[colorscheme dracula]]
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Lsp
-- Neovim doesn't support snippets out of the box, so we need to mutate the
-- capabilities we send to the language server to let them know we want snippets.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

vim.diagnostic.config({
	virtual_text = false
})
-- Show line diagnostics automatically in hover window
vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

-- A callback that will get called when a buffer connects to the language server.
-- Here we create any key maps that we want to have on that buffer.
require("bufferline").setup {}
local navic = require('nvim-navic')
local on_attach = function(client, bufnr)
	require("luasnip.loaders.from_vscode").lazy_load()
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	if client.name ~= 'tailwindcss' then
		navic.attach(client, bufnr)
	end

	--Enable completion triggered by <c-x><c-o>
	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	local opts = { noremap = true, silent = true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', ':vsplit | lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', '<leader>gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_set_keymap('n', '<C-j>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	-- buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	buf_set_keymap('n', '<F6>', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	buf_set_keymap('n', 'gR', '<cmd>Telescope lsp_references<cr>', opts)
	buf_set_keymap("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
	buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
	buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.format({ async = false })<CR>", opts)

	-- format on save / autoformat
	if client.server_capabilities.documentFormattingProvider then
		vim.cmd [[augroup Format]]
		vim.cmd [[autocmd! * <buffer>]]
		vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format { async = false }]]
		vim.cmd [[augroup END]]
	end
end

require('mason').setup()
require("mason-lspconfig").setup { automatic_installation = true }
require("mason-lspconfig").setup_handlers {
	-- The first entry (without a key) will be the default handler
	-- and will be called for each installed server that doesn't have
	-- a dedicated handler.
	function(server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup {
			on_attach = on_attach,
			capabilities = capabilities,
		}
	end,
	["elixirls"] = function()
		require("lspconfig")["elixirls"].setup {
			on_attach = on_attach,
			capabilities = capabilities,
			root_dir = require("lspconfig/util").root_pattern("mix.lock", ".git"),
			settings = {
				elixirLS = {
					suggestSpecs = true,
					testLenses = true,
					dialyzerEnabled = true,
					fetchDeps = true,
				}
			}
		}
	end
}

-- NullLs
local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		-- null_ls.builtins.formatting.stylua,
		-- null_ls.builtins.completion.spell,
		-- null_ls.builtins.code_actions.gitsigns,
		null_ls.builtins.code_actions.shellcheck,
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.completion.luasnip,
		-- null_ls.builtins.diagnostics.codespell,
		-- null_ls.builtins.diagnostics.write_good,
		null_ls.builtins.diagnostics.zsh,
		null_ls.builtins.diagnostics.jsonlint,
		null_ls.builtins.diagnostics.credo.with({ env = { MIX_ENV = "test" } }),
	},
})

-- Cmp
local cmp = require('cmp')
local lspkind = require('lspkind')
local luasnip = require('luasnip')

cmp.setup({
	snippet = {
		expand = function(args)
			-- vim.fn["vsnip#anonymous"](args.body)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		-- C-space is taken by language switcher and also not sure what this is for; the completion is super aggressive already
		-- ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
		['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			-- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			select = true,
		}),
		['<Tab>'] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end,
		['<S-Tab>'] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end,
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		-- { name = 'vsnip' },
		{ name = 'luasnip' },
	}, {
		{
			name = 'buffer',
			option = {
				keyword_length = 4,
				get_bufnrs = function()
					local bufs = {}
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						bufs[vim.api.nvim_win_get_buf(win)] = true
					end
					return vim.tbl_keys(bufs)
				end
			}
		},
	}),
	formatting = {
		format = lspkind.cmp_format({
			maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
			with_text = true,
			menu = ({
				buffer = "[buf]",
				nvim_lsp = "[lsp]",
				vsnip = "[snip]",
			})
		})
	}
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})

-- Illuminate
require('illuminate').configure({
	providers = {
		'lsp',
		'treesitter',
		'regex',
	},
	filetypes_denylist = {
		"dirvish",
		"fugitive",
		"alpha",
		"NvimTree",
		"packer",
		"neogitstatus",
		"Trouble",
		"lir",
		"Outline",
		"spectre_panel",
		"toggleterm",
		"DressingSelect",
		"TelescopePrompt",
	},
	under_cursor = true,
})

-- Autocmd
local definitions = {
	{
		"TextYankPost",
		{
			group = "_general_settings",
			pattern = "*",
			desc = "Highlight text on yank",
			callback = function()
				require("vim.highlight").on_yank { higroup = "Search", timeout = 100 }
			end,
		},
	},
	{
		"BufWritePre",
		{
			group = "_general_settings",
			pattern = "*",
			desc = "Format document on save",
			callback = function()
				vim.lsp.buf.format({ timeout_ms = 500 })
			end
		}
	}
}

for _, entry in ipairs(definitions) do
	local event = entry[1]
	local opts = entry[2]
	if type(opts.group) == "string" and opts.group ~= "" then
		local exists, _ = pcall(vim.api.nvim_get_autocmds, { group = opts.group })
		if not exists then
			vim.api.nvim_create_augroup(opts.group, {})
		end
	end
	vim.api.nvim_create_autocmd(event, opts)
end

local default_options = {
	autoread = true,
	backup = false,
	clipboard = "unnamedplus",
	cmdheight = 1,
	completeopt = { "menuone", "noselect" },
	conceallevel = 0,
	cursorline = true,
	fileencoding = "utf-8",
	foldmethod = "manual",
	foldexpr = "",
	guifont = "monospace:h17",
	hlsearch = true,
	hidden = true,
	ignorecase = true,
	laststatus = 3,
	mouse = "a",
	number = true,
	numberwidth = 2,
	pumheight = 10,
	scrolloff = 8,
	syntax = on,
	showcmd = false,
	showmode = false,
	showtabline = 2,
	shiftwidth = 2,
	splitbelow = true,
	sidescrolloff = 8,
	splitright = true,
	smartcase = true,
	tabstop = 2,
	title = true,
	termguicolors = true,
	undofile = true,
	history = 500,
	ruler = true,
	tm = 500
}

for k, v in pairs(default_options) do
	vim.opt[k] = v
end

-- Lualine Configuration
local function diff_source()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed,
		}
	end
end

local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand "%:t") ~= 1
	end,
	hide_in_width = function()
		return vim.o.columns > 100
	end,
}

local diff = {
	'diff',
	source = diff_source,
	padding = { left = 2, right = 1 },
	diff_color = {
		added = { fg = "#98be65" },
		modified = { fg = "#ECBE7B" },
		removed = { fg = "#ec5f67" },
	},
	cond = nil,
}

local lsp = {
	function(msg)
		msg = msg or "LS Inactive"
		local buf_clients = vim.lsp.get_active_clients()
		if next(buf_clients) == nil then
			-- TODO: clean up this if statement
			if type(msg) == "boolean" or #msg == 0 then
				return "LS Inactive"
			end
			return msg
		end
		local buf_ft = vim.bo.filetype
		local buf_client_names = {}

		-- add client
		for _, client in pairs(buf_clients) do
			if client.name ~= "null-ls" then
				table.insert(buf_client_names, client.name)
			end
		end

		local unique_client_names = vim.fn.uniq(buf_client_names)

		local language_servers = "[" .. table.concat(unique_client_names, ", ") .. "]"

		return language_servers
	end,
	color = { gui = "bold" },
	cond = conditions.hide_in_width,
}

require('lualine').setup({
	style = "default",
	options = {
		icons_enabled = true,
		theme = "auto",
		globalstatus = true,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "alpha" },
	},
	sections = {
		lualine_a = { { 'mode', padding = { left = 0, right = 0 }, cond = nil, color = {} } },
		lualine_b = { { 'branch', 'b:gitsigns_head', color = { gui = 'bold' } } },
		lualine_c = { diff, { 'filename', color = {}, cond = nil } },
		lualine_x = { { 'diagnostics', sources = { 'nvim_diagnostic' } }, lsp, {
			'spaces',
			function()
				return vim.api.nvim_buf_get_option(0, "shiftwidth")
			end,
			padding = 1
		}, { 'filetype', cond = nil,                     padding = { left = 1, right = 1 } } },
		lualine_y = { "location" },
		lualine_z = {
			'progress',
			{
				'progress',
				fmt = function()
					return "%L"
				end,
				color = {}
			}
		},
	},
	inactive_sections = {
		lualine_a = { { 'mode', padding = { left = 0, right = 0 }, cond = nil, color = {} } },
		lualine_b = { { 'branch', 'b:gitsigns_head', color = { gui = 'bold' } } },
		lualine_c = { diff, { 'filename', color = {}, cond = nil } },
		lualine_x = { { 'diagnostics', sources = { 'nvim_diagnostic' } }, lsp, {
			'spaces',
			function()
				return vim.api.nvim_buf_get_option(0, "shiftwidth")
			end,
			padding = 1
		}, { 'filetype', cond = nil,                     padding = { left = 1, right = 1 } } },
		lualine_y = { "location" },
		lualine_z = {
			'progress',
			{
				'progress',
				fmt = function()
					return "%L"
				end,
				color = {}
			}
		},
	},
	tabline = {},
	extensions = {},
})

local wk = require('which-key')
wk.register({
		w = { ":w!<cr>", "Save" },
		n = { f = { "<cmd>NvimTreeFindFile<CR>", "Explorer focus" }, w = { ":noa w!<cr>", "Save without autocmd" } },
		o = { "<cmd>Telescope buffers<cr>", "Buffer search" },
		f = { f = { "<cmd>Telescope find_files<cr>", "Find files" }, g = { "<cmd>Telescope live_grep<cr>", "Live grep" } },
		g = {
			s = { ":Gitsigns stage_hunk<CR>", "Stage hunk" },
			u = { ":Gitsigns undo_stage_hunk<CR>", "Undo Stage hunk" },
			b = { ":Gitsigns blame_line<CR>", "Git blame" }
		},
		b = {
			name = "Buffers",
			j = { "<cmd>BufferLinePick<cr>", "Jump" },
			f = { "<cmd>Telescope buffers<cr>", "Find" },
			b = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
			n = { "<cmd>BufferLineCycleNext<cr>", "Next" },
			-- w = { "<cmd>BufferWipeout<cr>", "Wipeout" }, -- TODO: implement this for bufferline
			e = {
				"<cmd>BufferLinePickClose<cr>",
				"Pick which buffer to close",
			},
			h = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
			l = {
				"<cmd>BufferLineCloseRight<cr>",
				"Close all to the right",
			},
			D = {
				"<cmd>BufferLineSortByDirectory<cr>",
				"Sort by directory",
			},
			L = {
				"<cmd>BufferLineSortByExtension<cr>",
				"Sort by language",
			},
		},
		l = {
			name = "LSP",
			a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
			d = { "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", "Buffer Diagnostics" },
			w = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
			i = { "<cmd>LspInfo<cr>", "Info" },
			I = { "<cmd>Mason<cr>", "Mason Info" },
			j = {
				vim.diagnostic.goto_next,
				"Next Diagnostic",
			},
			k = {
				vim.diagnostic.goto_prev,
				"Prev Diagnostic",
			},
			l = { vim.lsp.codelens.run, "CodeLens Action" },
			q = { vim.diagnostic.setloclist, "Quickfix" },
			r = { vim.lsp.buf.rename, "Rename" },
			s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
			S = {
				"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
				"Workspace Symbols",
			},
			e = { "<cmd>Telescope quickfix<cr>", "Telescope Quickfix" },
		},
	}
	,
	{ prefix = "<leader>", mode = "n" })

-- NvimTree
require("nvim-tree").setup({
	sort_by = "case_sensitive",
	view = {
		adaptive_size = true,
		mappings = {
			list = {
				{ key = "u", action = "dir_up" },
				{
					key = "s",
					action = "vsplit",
				},
				{
					key = "e",
					action = "system_open"
				}
			},
		},
		side = "right"
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = true,
	},
})

-- Telescope
local trouble = require 'trouble.providers.telescope'
require('telescope').setup({
	defaults = {
		mappings = {
			i = { ["<c-t>"] = trouble.open_with_trouble },
			n = {
				["s"] = "file_vsplit",
				["o"] = "file_edit",
				["<c-t>"] = trouble.open_with_trouble
			}
		}
	}
})

-- Gitsigns
require('gitsigns').setup()

-- Autopairs
require('nvim-autopairs').setup({
	disable_filetype = { "TelescopePrompt", "spectre_panel" }
})
require("nvim-treesitter.configs").setup { autopairs = { enable = true }, context_commentstring = {
	enable = true
},
	ensure_installed = {
		'bash',
		'elixir',
		'eex',
		'erlang',
		'heex',
		'ruby',
		'vim',
		'lua',
		'html',
		'css',
		'regex',
		'yaml',
		'make',
		'http',
		'dockerfile',
		'devicetree',
		'json',
	},
	highlight = {
		enable = true, -- false will disable the whole extension
		additional_vim_regex_highlighting = false,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},
	textobjects = {
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
	},
}

-- Comment
require('Comment').setup()

-- Noice
-- require("noice").setup({
-- 	lsp = {
-- 		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
-- 		override = {
-- 			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
-- 			["vim.lsp.util.stylize_markdown"] = true,
-- 			["cmp.entry.get_documentation"] = true,
-- 		},
-- 	},
-- 	-- you can enable a preset for easier configuration
-- 	presets = {
-- 		bottom_search = true, -- use a classic bottom cmdline for search
-- 		command_palette = true, -- position the cmdline and popupmenu together
-- 		long_message_to_split = true, -- long messages will be sent to a split
-- 		inc_rename = true, -- enables an input dialog for inc-rename.nvim
-- 		lsp_doc_border = false, -- add a border to hover docs and signature help
-- 	}
-- })

-- IncRename
require("inc_rename").setup()

-- Todo-Comments
require("todo-comments").setup {}

-- Tailwindcss colorizer cmp
require("tailwindcss-colorizer-cmp").setup({
	color_square_width = 2,
})
require("cmp").config.formatting = {
	format = require("tailwindcss-colorizer-cmp").formatter
}


-- Keymappings
vim.g.mapleader = ","

local generic_opts = { noremap = true, silent = true }
local mode_adapters = {
	insert_mode = "i",
	normal_mode = "n",
	term_mode = "t",
	visual_mode = "v",
	visual_block_mode = "x",
	command_mode = "c"
}

VisualSelection = function()
	local saved_reg = vim.fn.getreg('"')
	vim.cmd('execute "normal! vgvy"')
	local pattern = vim.fn.escape(vim.fn.getreg('"'), "\\/.*'$^~[]")
	pattern = vim.fn.substitute(pattern, "\n$", "", "")
	vim.fn.feedkeys(":%s/" .. pattern .. "/")
	vim.fn.setreg('"', saved_reg)
	vim.fn.setreg('/', pattern)
	-- vim.fn.setcmdline(":%s/" .. pattern .. '/')
end

local key_mappings = {
	insert_mode = {
		["jj"] = '<ESC>',
		-- Move current line / block with Alt-j/k ala vscode.
		["<A-j>"] = "<Esc>:m .+1<CR>==gi",
		-- Move current line / block with Alt-j/k ala vscode.
		["<A-k>"] = "<Esc>:m .-2<CR>==gi",
		-- navigation
		["<A-Up>"] = "<C-\\><C-N><C-w>k",
		["<A-Down>"] = "<C-\\><C-N><C-w>j",
		["<A-Left>"] = "<C-\\><C-N><C-w>h",
		["<A-Right>"] = "<C-\\><C-N><C-w>l",
	},
	normal_mode = {
		['<leader><cr>'] = ':noh<cr>',
		-- Navigate buffers
		["<C-h>"] = "<C-w>h",
		["<C-j>"] = "<C-w>j",
		["<C-k>"] = "<C-w>k",
		["<C-l>"] = "<C-w>l",
		-- Resize with arrows
		['<C-Up>'] = ':resize -2<CR>',
		['<C-Down>'] = ':resize +2<CR>',
		['<C-Left>'] = ':vertical resize -2<CR>',
		['<C-Right>'] = ":vertical resize +2<CR>",
		-- Move current line / block with Alt-j/k a la vscode.
		['<A-j>'] = ':m .+1<CR>==',
		['<A-k>'] = ':m .-2<CR>==',
		-- QuickFix
		[']q'] = ':cnext<CR>',
		['[q'] = ':cprev<CR>',
		['<C-q>'] = ':call QuickFixToggle()<CR>',
		['<leader>e'] = ':e! ~/.config/nvim/init.lua<cr>',
		['<leader>q'] = ':e! ~/buffer<CR>'
	},
	visual_mode = {
		-- Better indenting
		['<'] = '<gv',
		['>'] = '>gv',
		['$1'] = '<esc>`>a)<esc>`<i(<esc>',
		['$2'] = '<esc>`>a]<esc>`<i[<esc>',
		['$3'] = '<esc>`>a}<esc>`<i{<esc>',
		['$$'] = '<esc>`>a"<esc>`<i"<esc>',
		['$q'] = "<esc>`>a'<esc>`<i'<esc>",
		['$e'] = '<esc>`>a`<esc>`<i`<esc>',
		['<leader>r'] = '<cmd>lua VisualSelection()<CR>',
	},
	visual_block_mode = {
		-- Move current line / block with Alt-j/k ala vscode.
		["<A-j>"] = ":m '>+1<CR>gv-gv",
		["<A-k>"] = ":m '<-2<CR>gv-gv",
	},
	command_mode = {
		-- navigate tab completion with <c-j> and <c-k>
		-- runs conditionally
		["<C-j>"] = { 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true } },
		["<C-k>"] = { 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true } },
	},
}

for adapter, mode in pairs(mode_adapters) do
	local opt = generic_opts[adapter]
	if type(key_mappings[adapter]) == "table" then
		for k, v in pairs(key_mappings[adapter]) do
			if type(v) == "table" then
				opt = v[2]
				v = v[1]
			end
			vim.keymap.set(mode, k, v, opt)
		end
	end
end

require 'hop'.setup()

vim.api.nvim_set_keymap('n', '<space><space>w',
	"<cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })<cr>", {})
vim.api.nvim_set_keymap('n', '<space><space>b',
	"<cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })<cr>", {})
vim.api.nvim_set_keymap('n', '<space><space>j',
	"<cmd>lua require'hop'.hint_lines_skip_whitespace({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })<cr>",
	{})
vim.api.nvim_set_keymap('n', '<space><space>k',
	"<cmd>lua require'hop'.hint_lines_skip_whitespace({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })<cr>",
	{})
vim.api.nvim_set_keymap('v', '<space><space>w',
	"<cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })<cr>", {})
vim.api.nvim_set_keymap('v', '<space><space>b',
	"<cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })<cr>", {})
vim.api.nvim_set_keymap('v', '<space><space>j',
	"<cmd>lua require'hop'.hint_lines_skip_whitespace({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })<cr>",
	{})
vim.api.nvim_set_keymap('v', '<space><space>k',
	"<cmd>lua require'hop'.hint_lines_skip_whitespace({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })<cr>",
	{})

vim.keymap.set("n", "<leader>r", function()
	return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true })
