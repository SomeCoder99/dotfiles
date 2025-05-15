-- vim.keymap.set("n", "<leader>e", function ()
--   if vim.bo.ft == "netrw" then
--     vim.cmd("bdelete")
--   else
--     vim.cmd("Explore")
--   end
-- end)

-- Clear search highlight on escape
vim.keymap.set({ "i", "n", "s" }, "<esc>", function()
  vim.cmd.nohlsearch()
  vim.snippet.stop()
  return "<esc>"
end, { expr = true })

-- Move selected up and down
vim.keymap.set("v", "<c-down>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv")
vim.keymap.set("v", "<c-up>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv")

-- Move current line up and down
vim.keymap.set("n", "<c-down>", "<cmd>move+1<cr>==")
vim.keymap.set("n", "<c-up>", "<cmd>move-2<cr>==")
