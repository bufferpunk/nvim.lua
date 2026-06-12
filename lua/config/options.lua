-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.clipboard = "unnamedplus"
-- Enable true color support
vim.opt.termguicolors = true
vim.filetype.add({
  extension = {
    vue = "vue",
  },
})

-- Create an autocommand to force transparency across panels
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    local hl_groups = { "Normal", "NormalNC", "SignColumn", "NeoTreeNormal", "NeoTreeNormalNC" }
    for _, group in ipairs(hl_groups) do
      vim.api.nvim_set_hl(0, group, { bg = "none" })
    end
  end,
})
