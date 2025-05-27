local border = "single"

return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    opts = {
      servers = {
        ts_ls = {},
        lua_ls = {},
        rust_analyzer = {},
        ccls = {},
        nil_ls = {},
      },
    },
    config = function(_, opts)
      vim.diagnostic.config {
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
          },
        },
        virtual_text = true,
      }

      for server, config in pairs(opts.servers) do
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end
    end,

    keys = {
      {
        "]d",
        function()
          vim.diagnostic.jump { count = 1, float = { border = border } }
        end,
        desc = "Go To Next Diagnostic",
      },
      {
        "[d",
        function()
          vim.diagnostic.jump { count = -1, float = { border = border } }
        end,
        desc = "Go To Previous Diagnostic",
      },
      {
        "K",
        function()
          vim.lsp.buf.hover { border = border, max_width = 80 }
        end,
      },
      { "<leader>c", "", desc = "Code" },
      {
        "<leader>cr",
        function()
          vim.lsp.buf.rename()
        end,
        desc = "Rename Symbol",
      },
      {
        "<leader>ca",
        function()
          vim.lsp.buf.code_action()
        end,
        desc = "Code Action",
      },
    },
  },
}
