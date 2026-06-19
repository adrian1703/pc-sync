-- snacks.lua
return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        -- show dotfiles in the explorer/tree UI
        hidden = true,
      },
      picker = {
        sources = {
          files = {
            hidden = true,   -- show dotfiles
            ignored = false, -- don't hide ignored files
          },
          grep = {
            hidden = true,
            ignored = false,
          },
        },
      },
    },
  },
}