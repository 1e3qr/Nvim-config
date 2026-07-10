return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					component_separators = { left = "\u{e0b1}", right = "\u{e0b3}" },
					section_separators = { left = "\u{e0b0}", right = "\u{e0b2}" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = {
						"encoding",
						{
							"fileformat",
							symbols = {
								unix = "\u{f303}", -- Arch Linux logo
								dos = "\u{e70f}",
								mac = "\u{f179}",
							},
						},
						"filetype",
					},
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},
}
