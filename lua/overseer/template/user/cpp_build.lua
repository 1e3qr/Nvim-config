return {
	name = "g++ build",
	builder = function()
		vim.cmd("update")
		local file = vim.fn.expand("%:p")
		local out = vim.fn.expand("%:p:r")
		return {
			cmd = {
				"sh",
				"-c",
				string.format(
					"g++ -std=c++20 -Wall -Wextra -Wpedantic -g -fsanitize=address,undefined -fno-omit-frame-pointer '%s' -o '%s' && '%s'",
					file, out, out
				),
			},
			components = {
				{ "on_output_quickfix", open_on_match = true },
				{ "open_output", on_start = "always", focus = true },
				"default",
			},
		}
	end,
	condition = {
		filetype = { "cpp" },
	},
}
