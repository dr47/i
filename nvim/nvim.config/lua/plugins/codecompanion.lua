return {
  {
    "olimorris/codecompanion.nvim",
    version = "^20.0.0",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      opts = {
        language = "Czech",
      },
      adapters = {
        http = {
          ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
              env = {
                url = "http://192.168.37.28:11434",
              },
            })
          end,
          -- anthropic = function()
          --   return require("codecompanion.adapters").extend("anthropic", {
          --     env = {
          --       api_key = os.getenv("ANTHROPIC_API_KEY"), -- You'll need to set this environment variable
          --     },
          --     schema = {
          --       model = {
          --         default = "claude-haiku-5-5",
          --       },
          --     },
          --   })
          -- end,
        },
      },
      interactions = {
        chat = {
          adapter = {
            name = "anthropic",
            model = "claude-haiku-5-5",
          },
        },
        inline = {
          adapter = {
            name = "anthropic",
            model = "claude-haiku-5-5",
          },
        },
      },
      rules = {
        default = {
          description = "Moje pravidla programování",
          files = {
            vim.fn.expand("~/.config/nvim/lua/plugins/codecompanion-rules.md"),
            "AGENTS.md",
          },
        },
      },
    },
  },
}
