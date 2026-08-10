return {
  "kylechui/nvim-surround",
  version = "*", -- use the latest stable release
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("nvim-surround").setup({})
  end,
}
