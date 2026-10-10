local in_ssh = (vim.env.SSH_CONNECTION or vim.env.SSH_TTY or vim.env.SSH_CLIENT) ~= nil

return {
	name = "g++ build",
	builder = function()
		vim.cmd("update")
		local file = vim.fn.expand("%:p")
		local out = vim.fn.expand("%:p:r")

		local compile = "g++ -std=c++20 -Wall -Wextra -Wpedantic -g -fsanitize=address,undefined -fno-omit-frame-pointer '"
			.. file
			.. "' -o '"
			.. out
			.. "'"

		-- over SSH: run inside nvim's task output; locally: open kitty for the program
		local run = in_ssh and ("'" .. out .. "'") or ("kitty -- '" .. out .. "'")

		local components
		if in_ssh then
			components = {
				{ "on_output_quickfix", open_on_match = true },
				{ "open_output", on_start = "always", focus = true },
				"default",
			}
		else
			components = {
				{ "on_output_quickfix", open = true },
				{ "open_output", on_start = "always" },
				"default",
			}
		end

		return {
			cmd = { "sh", "-c", compile .. " && " .. run },
			components = components,
		}
	end,
	condition = {
		filetype = { "cpp" },
	},
}
