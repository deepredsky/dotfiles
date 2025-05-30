local M = {}

M.init = function()
  vim.keymap.set("n", "<leader>f", function() require "fzf-lua".files() end, {desc = "Files"})
  vim.keymap.set("n", "<leader>F", function() require "fzf-lua".files({ cwd = vim.fn.expand('%:p:h') }) end, {desc = "Files within current dir"})
  vim.keymap.set("n", "<leader>b", function() require "fzf-lua".buffers() end, { desc = "Buffers"})
  vim.keymap.set("n", "<leader>.", function() require "fzf-lua".btags() end, { desc = "Tags in buffer"})

  -- vim.keymap.set("n", "<Space><Space>"
end

return M
