return {
  -- 1. Core Copilot Engine Configuration
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    dependencies = { "copilotlsp-nvim/copilot-lsp" },
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true, -- Automatically show ghost-text suggestions
        debounce = 150, -- Increased from 75 to give the layout engine time to settle
        hide_during_completion = true, -- Prevents overlapping with popup menus
        keymap = {
          accept = "<Tab>",       -- Bind Tab to accept the suggestion
          accept_word = "<M-w>",  -- Alt+w to accept next word
          accept_line = "<M-l>",  -- Alt+l to accept next line
          next = "<M-]>",         -- Alt+] for next suggestion
          prev = "<M-[>",         -- Alt+[ for previous suggestion
          dismiss = "<C-]>",      -- Ctrl+] to clear suggestion
        },
      },
      panel = { enabled = false }, -- Disable panel if using inline ghost text
      nes = {
        enabled = true,
        auto_trigger = true,
      },
      filetypes = {
        markdown = true, -- Enable for notes
        help = false,
        gitcommit = true,
      },
    },
    config = function(_, opts)
      require("copilot").setup(opts)
      -- Highlight Style (Rice the ghost text color)
      -- Modifies suggestion to be subtle italicized gray code
      vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#6A6575", italic = true })
    end,
  },
  -- 2. Copilot Chat Integration (Inline Chat & Explanations)
  {
    "CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      show_help = "yes", -- Open help hints in chat window
      window = {
        layout = "float", -- Float, vertical, or horizontal
        width = 0.45,     -- 45% screen width
        height = 0.8,
        border = "rounded", -- Styled visual border
      },
    },
    keys = {
      -- Visual Keymaps to leverage Copilot Chat
      { "<leader>aa", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Copilot Chat" },
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>", mode = "x", desc = "Explain Code Selection" },
      { "<leader>af", "<cmd>CopilotChatFix<cr>", mode = "x", desc = "Fix Code Selection Bugs" },
    },
  },

  {
    "copilotlsp-nvim/copilot-lsp",
    init = function()
      vim.g.copilot_nes_debounce = 150

      require('copilot-lsp').setup({
        nes = {
          move_count_threshold = 10,   -- Clear after 10 cursor movements
        }
      })

      vim.lsp.enable("copilot_ls")
      local function accept_nes()
        local bufnr = vim.api.nvim_get_current_buf()
        local state = vim.b[bufnr].nes_state
        if state then
          -- Try to jump to the start of the suggestion edit.
          -- If already at the start, then apply the pending suggestion and jump to the end of the edit.
          local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
            or (
              require("copilot-lsp.nes").apply_pending_nes()
              and require("copilot-lsp.nes").walk_cursor_end_edit()
            )
          return nil
        else
          -- Resolving the terminal's inability to distinguish between `TAB` and `<C-i>` in normal mode
          return "<C-l>"
        end
      end

      vim.keymap.set("n", "<Tab>", accept_nes, { expr = true, desc = "Accept Copilot NES suggestion (normal)" })
      vim.keymap.set("i", "<C-l>", accept_nes, { expr = true, desc = "Accept Copilot NES suggestion (insert)" })

      -- Clear copilot suggestion with Esc if visible, otherwise preserve default Esc behavior
      local function clearCopilotSuggestion()
        if require("copilot-lsp.nes").clear() then
          return nil
        else
          return "<esc>"
        end
      end
      vim.keymap.set("i", "<C-c>", clearCopilotSuggestion, { desc = "Clear Copilot suggestion or fallback" })
      vim.keymap.set("n", "<C-c>", clearCopilotSuggestion, { desc = "Clear Copilot suggestion or fallback" })
    end,
  },
}
