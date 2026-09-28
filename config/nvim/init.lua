-- Faster startup (byte-compiles lua)
vim.loader.enable()

-- Leader key (must be set before plugins)
vim.g.mapleader = ','

-- Options
vim.opt_global.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = "80"
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"  -- keep text from shifting when signs appear
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
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.showbreak = '↪'

vim.opt.ignorecase  = true
vim.opt.smartcase   = true
vim.opt.undofile   = true
vim.opt.updatetime = 300  -- faster CursorHold (default 4000ms)
vim.opt.timeoutlen = 400

vim.opt.termguicolors = true
-- fish's theme-switch touches this file (also read by vim, bat, tmux, mutt)
vim.opt.background = vim.uv.fs_stat('/tmp/light-theme') and 'light' or 'dark'

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
-- Don't claim every .md file on disk as a "temporary wiki" - only ~/notes
vim.g.vimwiki_global_ext = 0

-- Keymaps
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>')
vim.keymap.set('n', '<Leader><Leader>', ':')
vim.keymap.set('v', '<Leader><Leader>', ':')
vim.keymap.set('n', '<leader>p', '"+p')
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

-- Move by display lines; counts use real lines so they match relativenumber
vim.keymap.set('n', 'j', "v:count ? 'j' : 'gj'", { expr = true })
vim.keymap.set('n', 'k', "v:count ? 'k' : 'gk'", { expr = true })

-- cd to current file's directory
vim.keymap.set('n', '<leader>cd', ':lcd %:h<cr>')

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

-- Toggle checkbox: vimwiki's own toggle inside wiki files, plain GFM
-- checkbox toggle elsewhere (vimwiki_global_ext=0 means plain .md files
-- outside ~/notes are filetype=markdown, not vimwiki)
local function toggle_gfm_checkbox()
  local line = vim.api.nvim_get_current_line()
  local new_line, n = line:gsub('%[ %]', '[x]', 1)
  if n == 0 then
    new_line, n = line:gsub('%[[xX]%]', '[ ]', 1)
  end
  if n == 0 then
    -- Plain list item, no checkbox yet - add one
    new_line, n = line:gsub('^(%s*[-*+]%s+)', '%1[ ] ', 1)
  end
  if n == 0 then
    new_line, n = line:gsub('^(%s*%d+[%.%)]%s+)', '%1[ ] ', 1)
  end
  if n > 0 then
    vim.api.nvim_set_current_line(new_line)
  end
end

vim.keymap.set('n', '<Leader><Space>', function()
  if vim.bo.filetype == 'vimwiki' then
    vim.cmd('VimwikiToggleListItem')
  else
    toggle_gfm_checkbox()
  end
end, { desc = 'Toggle checkbox' })
vim.keymap.set('v', '<Leader><Space>', '<Plug>VimwikiToggleListItem')

-- Claiming this Plug target here stops vimwiki's ftplugin from also
-- binding its default '-' key, which shadows vinegar's directory-up map
vim.keymap.set('n', '<leader>v-', '<Plug>VimwikiRemoveHeaderLevel')

-- Quickfix mappings (vim-qf)
vim.keymap.set('n', '<Space><Space>', '<Plug>(qf_qf_toggle)')
vim.keymap.set('n', '<C-n>', '<Plug>(qf_qf_next)')
vim.keymap.set('n', '<C-p>', '<Plug>(qf_qf_previous)')

-- gx is natively cross-platform since Neovim 0.10 (vim.ui.open picks
-- open/xdg-open/wslview per OS), so no custom mapping needed here.

-- Add plugins using vim.pack
vim.pack.add({
  -- File navigation
  'https://github.com/tpope/vim-vinegar',

  -- Tim Pope essentials
  'https://github.com/tpope/vim-surround',
  'https://github.com/tpope/vim-repeat',

  -- Fuzzy finder
  'https://github.com/ibhagwan/fzf-lua',

  -- Completion
  { src = 'https://github.com/Saghen/blink.cmp', version = 'v1.10.2' },

  -- Motion
  'https://github.com/folke/flash.nvim',

  -- Formatting
  'https://github.com/stevearc/conform.nvim',

  -- Markdown rendering
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',

  -- Git
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/tpope/vim-rhubarb',
  'https://github.com/lewis6991/gitsigns.nvim',

  -- Colorscheme
  'https://github.com/sainnhe/everforest',

  -- LSP server configs (lsp/*.lua)
  'https://github.com/neovim/nvim-lspconfig',

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

-- Treesitter
local ts_parsers = {
  'lua', 'vim', 'vimdoc', 'query',
  'ruby', 'go', 'gomod', 'c', 'rust',
  'bash', 'json', 'yaml', 'markdown', 'markdown_inline',
}
require('nvim-treesitter').install(ts_parsers)
-- vimwiki keeps &filetype=vimwiki even with syntax='markdown', so alias it
-- to the markdown parser for treesitter (and render-markdown.nvim)
vim.treesitter.language.register('markdown', 'vimwiki')
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'lua', 'vim', 'help', 'query', 'ruby', 'go', 'gomod', 'c', 'rust', 'sh', 'json', 'yaml', 'markdown', 'vimwiki' },
  callback = function() vim.treesitter.start() end,
})

-- Flash (treesitter-powered jump motion)
require('flash').setup()
vim.keymap.set({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end, { desc = 'Flash' })
vim.keymap.set({ 'n', 'x', 'o' }, 'S', function() require('flash').treesitter() end, { desc = 'Flash Treesitter' })
vim.keymap.set('o', 'r', function() require('flash').remote() end, { desc = 'Remote Flash' })
vim.keymap.set({ 'o', 'x' }, 'R', function() require('flash').treesitter_search() end, { desc = 'Treesitter Search' })
vim.keymap.set('c', '<C-s>', function() require('flash').toggle() end, { desc = 'Toggle Flash Search' })

-- Conform (formatting)
require('conform').setup({
  formatters_by_ft = {
    lua = { 'stylua' },
    ruby = { 'rubocop' },
  },
  format_on_save = { lsp_format = 'fallback' },
})

-- render-markdown
require('render-markdown').setup({
  file_types = { 'markdown', 'vimwiki' },
  heading = { enabled = false },
})

-- fzf-lua keymaps
vim.keymap.set('n', '<leader>f', function() require('fzf-lua').files() end, { desc = 'Files' })
vim.keymap.set('n', '<leader>F', function() require('fzf-lua').files({ cwd = vim.fn.expand('%:p:h') }) end, { desc = 'Files in current dir' })
vim.keymap.set('n', '<leader>b', function() require('fzf-lua').buffers() end, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>.', function() require('fzf-lua').btags() end, { desc = 'Tags in buffer' })

-- Git keymaps
vim.keymap.set('n', '<leader>gb', '<cmd>G blame<cr>', { desc = 'Git blame' })

-- gitsigns
require('gitsigns').setup()
vim.keymap.set('n', ']c', function()
  if vim.wo.diff then vim.cmd.normal({ ']c', bang = true }) else require('gitsigns').nav_hunk('next') end
end, { desc = 'Next hunk' })
vim.keymap.set('n', '[c', function()
  if vim.wo.diff then vim.cmd.normal({ '[c', bang = true }) else require('gitsigns').nav_hunk('prev') end
end, { desc = 'Prev hunk' })
vim.keymap.set('n', '<leader>gs', function() require('gitsigns').stage_hunk() end, { desc = 'Stage hunk' })
vim.keymap.set('n', '<leader>gr', function() require('gitsigns').reset_hunk() end, { desc = 'Reset hunk' })
vim.keymap.set('n', '<leader>gp', function() require('gitsigns').preview_hunk() end, { desc = 'Preview hunk' })
vim.keymap.set('n', '<leader>gB', function() require('gitsigns').blame_line() end, { desc = 'Blame line' })

-- Goyo (distraction-free writing)
vim.keymap.set('n', '<leader>G', '<cmd>Goyo<cr>', { desc = 'Goyo' })

-- Completion
require('blink.cmp').setup({
  keymap = {
    preset = 'default',
    -- Don't steal <C-space>; it's already mapped to Escape below
    ['<C-space>'] = { 'fallback' },
    -- Accept with <CR> when the popup is open, otherwise normal <CR>
    ['<CR>'] = { 'accept', 'fallback' },
  },
  appearance = { nerd_font_variant = 'mono' },
  signature = { enabled = true },
})

-- =============================================================================
-- Native LSP (neovim 0.11+)
-- =============================================================================
-- Merge blink.cmp's completion capabilities into every server
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

-- Enable servers
vim.lsp.enable({ 'solargraph', 'gopls', 'lua_ls', 'clangd', 'rust_analyzer' })

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
    vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
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
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<BS>', true, false, true), 'n', false)
  end
end, { desc = 'Snippet jump backward (or backspace)' })
