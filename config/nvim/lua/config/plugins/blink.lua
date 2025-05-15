return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "nvim-tree/nvim-web-devicons",
    },
    version = "*",
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      cmdline = {
        keymap = { preset = "cmdline" },
      },
      appearance = {
        kind_icons = {
          Text = "󰦨",
          Method = "󰊕",
          Function = "󰊕",
          Constructor = "󰣪",
          Field = "󰭷",
          Variable = "󰏖",
          Class = "󰀄",
          Interface = "󰠱",
          Module = "",
          Property = "󱍔",
          Unit = "󰟢",
          Value = "",
          Enum = "󰭳",
          Keyword = "󰌆",
          Snippet = "󰅴",
          Color = "󰉦",
          File = "󰈤",
          Reference = "󰌷",
          Folder = "󰉖",
          EnumMember = "󰭳",
          Constant = "󰏿",
          Struct = "󰅩",
          Event = "󱐋",
          Operator = "󰐕",
          TypeParamter = "󰗴",
        },
      },

      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },

      keymap = {
        ["<cr>"] = { "accept", "fallback" },
        ["<up>"] = { "select_prev", "fallback" },
        ["<down>"] = { "select_next", "fallback" },
        ["<c-down>"] = { "scroll_documentation_down", "fallback" },
        ["<c-up>"] = { "scroll_documentation_up", "fallback" },
        ["<c-space>"] = { "show", "cancel", "fallback" },
        ["<c-d>"] = { "show_documentation", "hide_documentation", "fallback" },
        ["<c-k>"] = { "show_signature", "hide_signature", "fallback" },
        ["<tab>"] = { "snippet_forward", "fallback" },
        ["<s-tab>"] = { "snippet_backward", "fallback" },
      },

      completion = {
        accept = {
          auto_brackets = {
            enabled = false,
          },
        },
        list = {
          selection = {
            auto_insert = false,
            preselect = true,
          },
        },
        documentation = {
          auto_show = true,
          window = {
            border = "single",
          },
        },
        menu = {
          border = "single",
          auto_show = true,
          draw = {
            treesitter = { "lsp" },
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
            components = {
              kind_icon = {
                text = function(ctx)
                  local icon = ctx.kind_icon
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      icon = dev_icon
                    end
                  end

                  return icon .. ctx.icon_gap
                end,

                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end
                  return hl
                end,
              },
            },
          },
        },
      },

      signature = {
        enabled = true,
        window = {
          show_documentation = false,
          treesitter_highlighting = true,
          border = "single",
        },
      },
    },
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
      enabled = function(root_dir)
        return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
      end,
    },
  },
}
