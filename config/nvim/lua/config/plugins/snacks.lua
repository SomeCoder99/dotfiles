local function picker(name)
  return function()
    require("snacks").picker[name]()
  end
end

return {
  "folke/snacks.nvim",
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    picker = {
      enabled = true,
      layouts = {
        default = {
          layout = {
            box = "horizontal",
            width = 0.8,
            min_width = 120,
            height = 0.8,
            {
              box = "vertical",
              border = "none",
              {
                title = "{title} {live} {flags}",
                win = "input",
                height = 1,
                border = { "┌", "─", "┬", "│", "┤", "─", "├", "│" },
              },
              { win = "list", border = { "", "", "", "│", "┴", "─", "└", "│" } },
            },
            {
              win = "preview",
              title = "{preview}",
              border = { "", "─", "┐", "│", "┘", "─", "", "" },
              width = 0.5,
            },
          },
        },
      },
    },
    quickfile = { enabled = true },
  },

  keys = {
    -- picker keymaps
    { "<leader>f", "", desc = "Find" },
    { "<leader>fp", picker("pickers"), desc = "Find Pickers" },
    { "<leader>ff", picker("files"), desc = "Find Files" },
    { "<leader>fb", picker("buffers"), desc = "Find Buffers" },
    { "<leader>fg", picker("grep"), desc = "Live Grep" },
    { "<leader>fn", picker("notifications"), desc = "Find Notifications" },
    { "<leader>fr", picker("recent"), desc = "Find Recent Files" },
    { "<leader>f\"", picker("registers"), desc = "Find Register" },
    { "<leader>fa", picker("autocmds"), desc = "Find Autocommands" },
    { "<leader>fc", picker("commands"), desc = "Find Commands" },
    { "<leader>fC", picker("colorschemes"), desc = "Find Themes" },
    { "<leader>fD", picker("diagnostics"), desc = "Find Diagnostics" },
    { "<leader>fh", picker("help"), desc = "Find Help Tags" },
    { "<leader>fH", picker("highlights"), desc = "Find Highlight Groups" },
    { "<leader>fj", picker("jumps"), desc = "Find Jumps" },
    { "<leader>fk", picker("keymaps"), desc = "Find Keymaps" },
    { "<leader>fl", picker("loclist"), desc = "Loclist" },
    { "<leader>fm", picker("marks"), desc = "Find Marks" },
    { "<leader>fM", picker("man"), desc = "Find Man Pages" },
    { "<leader>fu", picker("undo"), desc = "Find Undo Histories" },
    { "<leader>ft", picker("todo_comments"), desc = "Find Todo Comments" },

    -- LSP keymaps
    { "gd", picker("lsp_definitions"), desc = "LSP: Go To Definition" },
    { "gD", picker("lsp_declarations"), desc = "LSP: Go To Declaration" },
    { "gr", picker("lsp_references"), nowait = true, desc = "LSP: Go To Reference" },
    { "gI", picker("lsp_implementations"), desc = "LSP: Go To Implementation" },
    { "gt", picker("lsp_type_definitions"), desc = "LSP: Go To Type Definition" },
    { "<leader>fs", picker("lsp_symbols"), desc = "LSP: Find Symbols" },
    { "<leader>fS", picker("lsp_workspace_symbols"), desc = "LSP: Find Workspace Symbols" },
  },
}
