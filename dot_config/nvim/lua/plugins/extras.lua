-- Enable LazyVim extras
-- See: https://www.lazyvim.org/extras

return {
  -- Language support
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.yaml" },
  { import = "lazyvim.plugins.extras.lang.markdown" },

  -- Linting and formatting
  { import = "lazyvim.plugins.extras.linting.eslint" },
  { import = "lazyvim.plugins.extras.formatting.prettier" },

  -- Editor enhancements
  { import = "lazyvim.plugins.extras.editor.mini-files" },

  -- Additional tools via Mason
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Lua
        "stylua",
        "lua-language-server",
        -- Shell
        "shellcheck",
        "shfmt",
        -- Web
        "prettier",
        "eslint-lsp",
        -- Python
        "ruff",
        "pyright",
        -- Go
        "gopls",
        "gofumpt",
        "goimports",
      },
    },
  },

  -- Additional treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "dockerfile",
        "fish",
        "gitcommit",
        "gitignore",
        "go",
        "gomod",
        "gosum",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "rust",
        "sql",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      })
    end,
  },
}
