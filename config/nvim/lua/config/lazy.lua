-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ','

vim.keymap.set('n', '<leader>w', '<cmd>write<cr>')
vim.keymap.set('n', '<leader>,', ':')
vim.keymap.set('v', '<leader>,', ':')
vim.keymap.set('n', '<leader>p', '<cmd>r!pbpaste<cr>')
vim.keymap.set('n','<C-Space>', '<Esc>:noh<CR>')
vim.keymap.set('v','<C-Space>', '<Esc>gV')
vim.keymap.set('o','<C-Space>', '<Esc>')
vim.keymap.set('c','<C-Space>', '<C-c>')
vim.keymap.set('i','<C-Space>', '<Esc>`^')
vim.keymap.set('v','<leader>c', '"+y')
-- Terminal sees <C-@> as <C-space>
vim.api.nvim_set_keymap('n', '<C-@>', '<Esc>:noh<CR>', { noremap = true })
vim.api.nvim_set_keymap('v', '<C-@>', '<Esc>gV', { noremap = true })
vim.api.nvim_set_keymap('o', '<C-@>', '<Esc>', { noremap = true })
vim.api.nvim_set_keymap('c', '<C-@>', '<C-c>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-@>', '<Esc>`^', { noremap = true })

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

vim.g.wiki_mappings_use_defaults = false

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "everforest" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
