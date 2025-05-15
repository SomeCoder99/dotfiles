return {
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      delete_to_trash = true,
      keymaps = {
        ["<leader>."] = {
          mode = "n",
          desc = "Enter and change directory to directory under cursor",
          function()
            local oil = require("oil")
            local action = require("oil.actions")
            local entry = oil.get_cursor_entry()
            if not entry then
              vim.notify("No entry under cursor")
              return
            end
            if entry.type ~= "directory" then
              vim.notify("Entry under cursor is not a directory")
              return
            end

            oil.select({}, function(err)
              if not err then
                action.cd.callback {}
              end
            end)
          end,
        },
      },
      win_options = {
        number = false,
      },
      view_options = {
        show_hidden = true,
      },
      float = {
        border = "single",
      },
      confirmation = {
        border = "single",
      },
      progress = {
        border = "single",
      },
      ssh = {
        border = "single",
      },
      keymaps_help = {
        border = "single",
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,

    keys = {
      {
        "<leader>e",
        function()
          require("oil").toggle_float()
        end,
        desc = "File Explorer (oil.nvim)",
      },
    },
  },
}
