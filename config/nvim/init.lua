-------------------------------------------------------------------------------
-- These are example settings to use with nvim-metals and the nvim built-in
-- LSP. Be sure to thoroughly read the `:help nvim-metals` docs to get an
-- idea of what everything does. Again, these are meant to serve as an example,
-- if you just copy pasta them, then should work,  but hopefully after time
-- goes on you'll cater them to your own liking especially since some of the stuff
-- in here is just an example, not what you probably want your setup to be.
--
-- Unfamiliar with Lua and Neovim?
--  - Check out https://github.com/nanotee/nvim-lua-guide
--
-- The below configuration also makes use of the following plugins besides
-- nvim-metals, and therefore is a bit opinionated:
--
-- - https://github.com/hrsh7th/nvim-cmp
--   - hrsh7th/cmp-nvim-lsp for lsp completion sources
--   - hrsh7th/cmp-vsnip for snippet sources
--   - hrsh7th/vim-vsnip for snippet sources
--
-- - https://github.com/wbthomason/packer.nvim for package management
-- - https://github.com/mfussenegger/nvim-dap (for debugging)
-------------------------------------------------------------------------------
vim.g.mapleader = ','
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>')
vim.keymap.set('n', '<leader>,', ':')
vim.keymap.set('n', '<leader>p', '<cmd>r!pbpaste<cr>')
vim.keymap.set('n','<C-Space>', '<Esc>:noh<CR>')
vim.keymap.set('v','<C-Space>', '<Esc>gV')
vim.keymap.set('o','<C-Space>', '<Esc>')
vim.keymap.set('c','<C-Space>', '<C-c>')
vim.keymap.set('i','<C-Space>', '<Esc>`^')
-- Terminal sees <C-@> as <C-space>
vim.api.nvim_set_keymap('n', '<C-@>', '<Esc>:noh<CR>', { noremap = true })
vim.api.nvim_set_keymap('v', '<C-@>', '<Esc>gV', { noremap = true })
vim.api.nvim_set_keymap('o', '<C-@>', '<Esc>', { noremap = true })
vim.api.nvim_set_keymap('c', '<C-@>', '<C-c>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-@>', '<Esc>`^', { noremap = true })

local api = vim.api
local cmd = vim.cmd

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end

----------------------------------
-- PLUGINS -----------------------
----------------------------------
cmd([[packadd packer.nvim]])
require("packer").startup(function(use)
  use({ "wbthomason/packer.nvim", opt = true })

  use({
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-vsnip" },
      { "hrsh7th/vim-vsnip" },
    },
  })
  use({
    "scalameta/nvim-metals",
    requires = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
  })
  use("sainnhe/everforest")
  use({
	  'nvim-telescope/telescope.nvim', tag = '0.1.0',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  })
  use("neovim/nvim-lspconfig")
  use("simrat39/rust-tools.nvim")
use 'tpope/vim-commentary'
use 'tpope/vim-unimpaired'
use 'tpope/vim-vinegar'
use 'tpope/vim-repeat'
use 'tpope/vim-fugitive'
use 'tpope/vim-rhubarb'
use 'airblade/vim-gitgutter'
use 'rhysd/git-messenger.vim'
use 'vim-ruby/vim-ruby'
use 'tpope/vim-projectionist'
use 'mileszs/ack.vim'
use 'romainl/vim-qf'
use '/opt/homebrew/opt/fzf'
use 'junegunn/fzf.vim'
use 'lifepillar/vim-solarized8'
end)

vim.opt.grepprg = 'rg --vimgrep'
vim.g.ackprg = 'rg --vimgrep'
vim.g.ackhighlight = false
vim.api.nvim_create_user_command('Ag', 'call ack#Ack("grep<bang>", <q-args>)', {})
vim.g.rustfmt_autosave = 1

vim.cmd 'command! -bang -nargs=* -complete=file Ag           call ack#Ack(\'grep<bang>\', <q-args>)'
-- command! -bang -nargs=* -complete=file AgFromSearch call ack#AckFromSearch('grep<bang>', <q-args>)

----------------------------------
-- OPTIONS -----------------------
----------------------------------
-- global
vim.opt_global.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt_global.shortmess:remove("F"):append("c")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ruler = true
vim.opt.colorcolumn = "80"
vim.opt.wildmenu = true
vim.opt.wrap = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.list = true
-- vim.opt.listchars = { space = ' ', tab = '▸ ', extends = '❯', }
vim.opt.listchars = {
  tab = '▸ ',
  extends = '❯',
  precedes = '❮',
  trail = '☠',
}
vim.opt.scrolloff = 3
vim.opt.showcmd = true
vim.opt.showbreak = ↪

vim.opt.hlsearch    = true
vim.opt.incsearch   = true
vim.opt.ignorecase  = true
vim.opt.smartcase   = true
vim.opt.autoread   = true
vim.opt.lazyredraw   = true

vim.opt.termguicolors = true
vim.opt.background = 'dark'
cmd 'colorscheme everforest'

-- LSP mappings
map("n", "gD", "<cmd>lua vim.lsp.buf.definition()<CR>")
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
map("n", "gds", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
map("n", "gws", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")
map("n", "<leader>cl", [[<cmd>lua vim.lsp.codelens.run()<CR>]])
map("n", "<leader>sh", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
map("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>")
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
-- map("n", "<leader>ws", '<cmd>lua require"metals".hover_worksheet()<CR>')
map("n", "<leader>aa", [[<cmd>lua vim.diagnostic.setqflist()<CR>]]) -- all workspace diagnostics
map("n", "<leader>ae", [[<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>]]) -- all workspace errors
map("n", "<leader>aw", [[<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>]]) -- all workspace warnings
map("n", "<leader>d", "<cmd>lua vim.diagnostic.setloclist()<CR>") -- buffer diagnostics only
map("n", "[c", "<cmd>lua vim.diagnostic.goto_prev { wrap = false }<CR>")
map("n", "]c", "<cmd>lua vim.diagnostic.goto_next { wrap = false }<CR>")

-- Example mappings for usage with nvim-dap. If you don't use that, you can
-- skip these
map("n", "<leader>dc", [[<cmd>lua require"dap".continue()<CR>]])
map("n", "<leader>dr", [[<cmd>lua require"dap".repl.toggle()<CR>]])
map("n", "<leader>dK", [[<cmd>lua require"dap.ui.widgets".hover()<CR>]])
map("n", "<leader>dt", [[<cmd>lua require"dap".toggle_breakpoint()<CR>]])
map("n", "<leader>dso", [[<cmd>lua require"dap".step_over()<CR>]])
map("n", "<leader>dsi", [[<cmd>lua require"dap".step_into()<CR>]])
map("n", "<leader>dl", [[<cmd>lua require"dap".run_last()<CR>]])

map("n", "<leader>f", [[<cmd>Files<cr>]])
map("n", "<leader>F", [[<cmd>lua require('telescope.builtin').find_files( { cwd = vim.fn.expand('%:p:h') })<cr>]])
map("n", "<leader>b", [[<cmd>Buffers<cr>]])
map("n", "<leader>.", [[<cmd>BTags<cr>]])

map("n", "<Space><Space>", "<Plug>(qf_qf_toggle)")
map("n", "<C-n>", "<Plug>(qf_qf_next)")
map("n", "<C-p>", "<Plug>(qf_qf_previous)")
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })
vim.api.nvim_set_keymap('v', '<leader>c', '"+y', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>p', ':r!pbpaste<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'j', 'gj', { noremap = true })
vim.api.nvim_set_keymap('n', 'k', 'gk', { noremap = true })
vim.api.nvim_set_keymap('n', 'cd', ':lcd %:h<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader><leader>', ':', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>w', ':update<CR>', { noremap = true })
vim.api.nvim_set_keymap('v', '<leader>c', '"+y', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>p', ':r!pbpaste<CR>', { noremap = true })

-- Configure LSP through rust-tools.nvim plugin.
-- rust-tools will configure and enable certain LSP features for us.
-- See https://github.com/simrat39/rust-tools.nvim#configuration
local opts = {
  tools = {
    runnables = {
      use_telescope = true,
    },
    inlay_hints = {
      auto = true,
      show_parameter_hints = false,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
    },
  },

  -- all the opts to send to nvim-lspconfig
  -- these override the defaults set by rust-tools.nvim
  -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
  server = {
    -- on_attach is a callback called when the language server attachs to the buffer
    on_attach = on_attach,
    settings = {
      -- to enable rust-analyzer settings visit:
      -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
      ["rust-analyzer"] = {
        -- enable clippy on save
         checkOnSave = {
           command = "clippy",
         },
      },
    },
  },
}

require("rust-tools").setup(opts)

-- completion related settings
-- This is similiar to what I use
local cmp = require("cmp")
cmp.setup({
  sources = {
    { name = "nvim_lsp" },
    { name = "vsnip" },
  },
  snippet = {
    expand = function(args)
      -- Comes from vsnip
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    -- None of this made sense to me when first looking into this since there
    -- is no vim docs, but you can't have select = true here _unless_ you are
    -- also using the snippet stuff. So keep in mind that if you remove
    -- snippets you need to remove this select
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    -- I use tabs... some say you should stick to ins-completion but this is just here as an example
    ["<Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
  }),
})

----------------------------------
-- LSP Setup ---------------------
----------------------------------
local metals_config = require("metals").bare_config()

-- Example of settings
metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
}

-- *READ THIS*
-- I *highly* recommend setting statusBarProvider to true, however if you do,
-- you *have* to have a setting to display this in your statusline or else
-- you'll not see any messages from metals. There is more info in the help
-- docs about this
-- metals_config.init_options.statusBarProvider = "on"

-- Example if you are using cmp how to make sure the correct capabilities for snippets are set
local capabilities = vim.lsp.protocol.make_client_capabilities()
metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Debug settings if you're using nvim-dap
local dap = require("dap")

dap.configurations.scala = {
  {
    type = "scala",
    request = "launch",
    name = "RunOrTest",
    metals = {
      runType = "runOrTestFile",
      --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test Target",
    metals = {
      runType = "testTarget",
    },
  },
}

metals_config.on_attach = function(client, bufnr)
  require("metals").setup_dap()
end

-- Autocmd that will actually be in charging of starting the whole thing
local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
api.nvim_create_autocmd("FileType", {
  -- NOTE: You may or may not want java included here. You will need it if you
  -- want basic Java support but it may also conflict if you are using
  -- something like nvim-jdtls which also works on a java filetype autocmd.
  pattern = { "scala", "sbt", "java" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})

map("n", "<neader>h", [[<cmd>lua require"rust-tools".inlay_hints.enable()<CR>]])
map("n", "<leader>H", [[<cmd>lua require"rust-tools".inlay_hints.disable()<CR>]])
