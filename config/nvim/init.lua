-- Faster startup (byte-compiles lua)
vim.loader.enable()

-- Leader key (must be set before plugins)
vim.g.mapleader = ','

-- Options
vim.opt_global.completeopt = { "menuone", "noinsert", "noselect" }
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
vim.opt.listchars = {
  tab = '▸ ',
  extends = '❯',
  precedes = '❮',
  trail = '☠',
}
vim.opt.scrolloff = 3
vim.opt.showcmd = true
vim.opt.showbreak = '↪'

vim.opt.hlsearch    = true
vim.opt.incsearch   = true
vim.opt.ignorecase  = true
vim.opt.smartcase   = true
vim.opt.autoread   = true
vim.opt.updatetime = 300  -- faster CursorHold (default 4000ms)

vim.opt.termguicolors = true
vim.opt.background = 'dark'

-- Use rg or ag for grep
if vim.fn.executable('rg') == 1 then
  vim.opt.grepprg = 'rg --vimgrep'
  vim.opt.grepformat = '%f:%l:%c:%m'
elseif vim.fn.executable('ag') == 1 then
  vim.opt.grepprg = 'ag --vimgrep'
  vim.opt.grepformat = '%f:%l:%c:%m'
end

-- :Ag command - search and populate quickfix
vim.api.nvim_create_user_command('Ag', function(opts)
  vim.cmd('silent grep! ' .. opts.args)
  vim.cmd('copen')
end, { nargs = '+', complete = 'file' })

-- Plugin-specific globals (vimwiki)
vim.g.vimwiki_map_prefix = ',v'
vim.g.vimwiki_list = {{
  path = '~/notes/',
  syntax = 'markdown',
  ext = '.md',
}}

-- Keymaps
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>')
vim.keymap.set('n', '<Leader><Leader>', ':')
vim.keymap.set('v', '<Leader><Leader>', ':')
vim.keymap.set('n', '<leader>p', '<cmd>r!pbpaste<cr>')
vim.keymap.set('n','<C-Space>', '<Esc>:noh<CR>')
vim.keymap.set('v','<C-Space>', '<Esc>gV')
vim.keymap.set('o','<C-Space>', '<Esc>')
vim.keymap.set('c','<C-Space>', '<C-c>')
vim.keymap.set('i','<C-Space>', '<Esc>`^')
vim.keymap.set('v','<leader>c', '"+y')
-- Terminal sees <C-@> as <C-space>
vim.keymap.set('n', '<C-@>', '<Esc>:noh<CR>')
vim.keymap.set('v', '<C-@>', '<Esc>gV')
vim.keymap.set('o', '<C-@>', '<Esc>')
vim.keymap.set('c', '<C-@>', '<C-c>')
vim.keymap.set('i', '<C-@>', '<Esc>`^')

-- Disable arrow keys
vim.keymap.set('n', '<up>', '<nop>')
vim.keymap.set('n', '<down>', '<nop>')
vim.keymap.set('n', '<left>', '<nop>')
vim.keymap.set('n', '<right>', '<nop>')
vim.keymap.set('i', '<up>', '<nop>')
vim.keymap.set('i', '<down>', '<nop>')
vim.keymap.set('i', '<left>', '<nop>')
vim.keymap.set('i', '<right>', '<nop>')

-- Make Y behave like C and D
vim.keymap.set('n', 'Y', 'y$')

-- Move by display lines
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

-- cd to current file's directory
vim.keymap.set('n', 'cd', ':lcd %:h<cr>')

-- K to grep word under cursor
vim.keymap.set('n', 'K', ':grep! "\\b<C-R><C-W>\\b"<CR>:cw<CR>')
vim.keymap.set('v', 'K', '"ay:Ag "<C-r>a"<CR>')

-- Create directory for current file
vim.keymap.set('n', '<leader>md', ':!mkdir -p %:p:h<CR>', { silent = true })

-- Edit in current file's directory
vim.keymap.set('n', '<leader>ew', ":e <C-R>=expand('%:h').'/'<cr>")

-- Cmdline shortcuts
vim.keymap.set('c', '%%', "<C-R>=expand('%:h').'/'<CR>")
vim.keymap.set('c', '$$', "<C-R>=expand('%')<CR>")

-- Vimwiki toggle
vim.keymap.set('n', '<Leader><Space>', '<Plug>VimwikiToggleListItem')
vim.keymap.set('v', '<Leader><Space>', '<Plug>VimwikiToggleListItem')

-- Quickfix mappings (vim-qf)
vim.keymap.set('n', '<Space><Space>', '<Plug>(qf_qf_toggle)')
vim.keymap.set('n', '<C-n>', '<Plug>(qf_qf_next)')
vim.keymap.set('n', '<C-p>', '<Plug>(qf_qf_previous)')

-- Fix broken netrw gx
vim.keymap.set('n', 'gx', function()
  vim.fn.system({ 'open', vim.fn.expand('<cWORD>') })
end, { silent = true })

-- Add plugins using vim.pack
vim.pack.add({
  -- File navigation
  'https://github.com/tpope/vim-vinegar',

  -- Tim Pope essentials
  'https://github.com/tpope/vim-surround',
  'https://github.com/tpope/vim-repeat',

  -- Fuzzy finder
  'https://github.com/ibhagwan/fzf-lua',

  -- Git
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/tpope/vim-rhubarb',

  -- Colorscheme
  'https://github.com/sainnhe/everforest',

  -- Treesitter
  'https://github.com/nvim-treesitter/nvim-treesitter',

  -- Quickfix
  'https://github.com/romainl/vim-qf',

  -- Writing/Notes
  'https://github.com/vimwiki/vimwiki',

  -- Distraction-free writing
  'https://github.com/junegunn/goyo.vim',
  'https://github.com/junegunn/limelight.vim',
})

-- Colorscheme
vim.cmd.colorscheme('everforest')

-- fzf-lua keymaps
vim.keymap.set('n', '<leader>f', function() require('fzf-lua').files() end, { desc = 'Files' })
vim.keymap.set('n', '<leader>F', function() require('fzf-lua').files({ cwd = vim.fn.expand('%:p:h') }) end, { desc = 'Files in current dir' })
vim.keymap.set('n', '<leader>b', function() require('fzf-lua').buffers() end, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>.', function() require('fzf-lua').btags() end, { desc = 'Tags in buffer' })

-- Git keymaps
vim.keymap.set('n', '<leader>gb', '<cmd>G blame<cr>', { desc = 'Git blame' })

-- Goyo (distraction-free writing)
vim.keymap.set('n', '<leader>z', '<cmd>Goyo<cr>', { desc = 'Goyo' })

-- =============================================================================
-- Native LSP (neovim 0.11+)
-- =============================================================================
-- Configure language servers
vim.lsp.config('solargraph', {
  cmd = { 'solargraph', 'stdio' },
  filetypes = { 'ruby', 'eruby' },
  root_markers = { 'Gemfile', '.git' },
})

vim.lsp.config('gopls', {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.mod', '.git' },
})

vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.git' },
})

vim.lsp.config('clangd', {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
  root_markers = { 'compile_commands.json', '.git' },
})

-- Enable servers
vim.lsp.enable({ 'solargraph', 'gopls', 'lua_ls', 'clangd' })

-- Diagnostics: off by default
vim.diagnostic.enable(false)

-- Toggle diagnostics with <leader>D
vim.keymap.set('n', '<leader>D', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  if vim.diagnostic.is_enabled() then
    print('Diagnostics ON')
  else
    print('Diagnostics OFF')
  end
end, { desc = 'Toggle diagnostics' })

-- Show diagnostic virtual text only on current line
vim.diagnostic.config({
  virtual_text = { current_line = true },
  signs = true,
  underline = true,
})

-- LSP keymaps (set when LSP attaches to buffer)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)

    -- Enable inlay hints if supported
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
    end
  end,
})

-- Toggle inlay hints
vim.keymap.set('n', '<leader>ih', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'Toggle inlay hints' })

-- =============================================================================
-- Native Snippets (neovim 0.10+)
-- =============================================================================
-- Jump forward/backward in snippet
vim.keymap.set({ 'i', 's' }, '<C-l>', function()
  if vim.snippet.active({ direction = 1 }) then
    vim.snippet.jump(1)
  end
end, { desc = 'Snippet jump forward' })

vim.keymap.set({ 'i', 's' }, '<C-h>', function()
  if vim.snippet.active({ direction = -1 }) then
    vim.snippet.jump(-1)
  end
end, { desc = 'Snippet jump backward' })
