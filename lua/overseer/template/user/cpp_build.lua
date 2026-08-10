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
				"g++ -std=c++20 -Wall -Wextra -Wpedantic -g -fsanitize=address,undefined -fno-omit-frame-pointer "
					.. file
					.. " -o "
					.. out
					.. " && kitty -- "
					.. out,
			},
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
