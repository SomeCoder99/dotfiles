return {
  {
    "SomeCoder99/darkslate.nvim",
    dev = false,
    priority = 1000,
    ---@module "darkslate"
    ---@type darkslate.opts
    opts = {
      variant = "dark",
      plugin = {
        lualine = { brightness = -1 },
      },
    },
    config = function(_, opts)
      require("darkslate").setup(opts)
      vim.cmd.colorscheme("darkslate")
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    dependencies = {
      "SomeCoder99/darkslate.nvim",
    },
    opts = function(_, opts)
      return require("darkslate.plugin.nvim_web_devicons").tweak_opts(opts)
    end,
  },
}
