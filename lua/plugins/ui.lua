return {
  -- Rice the buffer tabs at the top
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        separator_style = "slant", -- Options: "slant", "bubble", "circular", "thick"
        diagnostics = "nvim_lsp",
      },
    },
  },

  -- Rice the statusline at the bottom
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- Use smooth pill components instead of sharp triangles
      opts.options.component_separators = { left = '', right = '' }
      opts.options.section_separators = { left = '', right = '' }
    end,
  },
}

