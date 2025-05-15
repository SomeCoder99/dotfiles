return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        rust = { "rustfmt" },
      },
      formatters = {
        stylua = {
          -- stylua: ignore
          prepend_args = {
            "--call-parentheses", "NoSingleTable",
            "--column-width", "100",
            "--indent-type", "Spaces",
            "--indent-width", "2",
            "--quote-style", "ForceDouble",
          },
        },
      },
    },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format()
        end,
        desc = "Format Buffer",
      },
      {
        "<leader>cF",
        function()
          require("conform").format { async = true }
        end,
        desc = "Format Buffer (Async)",
      },
    },
  },
}
