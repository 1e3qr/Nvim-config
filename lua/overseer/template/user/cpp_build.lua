return {
	name = "g++ build",
	builder = function()
		local file = vim.fn.expand("%:p")
		local out = vim.fn.expand("%:p:r")
		return {
			cmd = { "sh", "-c", "g++ -g " .. file .. " -o " .. out .. " && gnome-terminal -- " .. out },
			components = {
				{ "on_output_quickfix", open = true },
				{ "open_output", on_start = "always" },
				"default",
			},
		}
	end,
	condition = {
		filetype = { "cpp" },
	},
}
