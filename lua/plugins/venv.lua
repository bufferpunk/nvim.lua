return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    { "folke/snacks.nvim", version = "*" }, -- optional: you can also use fzf-lua, telescope or mini-pick instead.
  },
  ft = "python", -- Load when opening Python files
  keys = { { ",v", "<cmd>VenvSelect<cr>" } }, -- Open picker on keymap
  opts = {
    options = {}, -- plugin-wide options
    search = {
      my_project_venvs = {
        command = "fd '/bin/python$' ~/ --full-path --color never",
      },
    }
  },
}
