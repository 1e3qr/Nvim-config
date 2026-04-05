return {
	"barrett-ruth/live-server.nvim",
	build = "npm install -g live-server",
	cmd = { "LiveServerStart", "LiveServerStop" },
	config = function()
		vim.g.live_server = {
			-- your settings here, e.g.:
			-- port = 5500,
		}
	end,
	keys = {
		{ "<leader>ls", "<cmd>LiveServerStart<cr>", desc = "Start Live Server" },
		{ "<leader>lx", "<cmd>LiveServerStop<cr>", desc = "Stop Live Server" },
	},
}
