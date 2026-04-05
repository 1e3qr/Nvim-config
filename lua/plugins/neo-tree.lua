return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", {})
		window = {
			mappings = {
				["P"] = {
					"toggle_preview",
					config = {
						use_float = true,
						use_snacks_image = true,
					},
				},
			},
		}
	end,
}
