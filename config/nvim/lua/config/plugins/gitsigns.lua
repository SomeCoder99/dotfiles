return {
  "lewis6991/gitsigns.nvim",
  lazy = false,
  opts = {},

  keys = {
    { "<leader>g", "", desc = "Git" },
    { "<leader>gb", "<cmd>Gitsigns blame_line<cr>", desc = "Show Current Line Blame" },
    { "<leader>gB", "<cmd>Gitsigns blame<cr>", desc = "Show Blames" },
    { "<leader>gd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff Current File" },
    { "<leader>gt", "", desc = "Toggle" },
    {
      "<leader>gtb",
      "<cmd>Gitsigns toggle_current_line_blame<cr>",
      desc = "Toggle Current Line Blame",
    },
    { "<leader>gtd", "<cmd>Gitsigns toggle_deleted<cr>", desc = "Toggle Deleted" },
    { "<leader>gtl", "<cmd>Gitsigns toggle_linehl<cr>", desc = "Toggle Line Highlight" },
    { "<leader>gtn", "<cmd>Gitsigns toggle_numhl<cr>", desc = "Toggle Number Highlight" },
    { "<leader>gts", "<cmd>Gitsigns toggle_signs<cr>", desc = "Toggle Signs" },
    { "<leader>gtw", "<cmd>Gitsigns toggle_word_diff<cr>", desc = "Toggle Word Diff" },
  },
}
