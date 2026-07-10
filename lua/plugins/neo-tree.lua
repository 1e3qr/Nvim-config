return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
		{
			"3rd/image.nvim",
			opts = {
				backend = "kitty",
				processor = "magick_cli", -- avoids needing luarocks + the magick rock
				integrations = {
					neo_tree = {
						enabled = true,
						show_in_file_explorer = true,
					},
				},
				max_width_window_percentage = 100,
				max_height_window_percentage = 100,
			},
		},
	},
	config = function()
		vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", {})
		require("neo-tree").setup({
			window = {
				mappings = {
					["P"] = {
						"toggle_preview",
						config = {
							use_float = true,
							use_image_nvim = true,
						},
					},
				},
			},
		})
	end,
}
