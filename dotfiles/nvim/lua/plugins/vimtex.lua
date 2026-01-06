return {
  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      -- Always compile to PDF
      vim.g.vimtex_compiler_method = "latexmk"

      -- Optional: explicitly force pdf output
      vim.g.vimtex_compiler_latexmk = {
        options = {
          "-pdf",
          "-interaction=nonstopmode",
          "-synctex=1",
        },
      }

      -- PDF viewer
      vim.g.vimtex_view_method = "zathura"
    end,
  },
}
