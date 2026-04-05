return {
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvimtools/none-ls-extras.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.clang_format,
					null_ls.builtins.formatting.black,
					null_ls.builtins.formatting.isort,
					require("none-ls.diagnostics.flake8"),
					null_ls.builtins.formatting.prettier,
					require("none-ls.diagnostics.eslint_d"),
					null_ls.builtins.formatting.stylua,
				},
			})

			vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
		end,
	},
}
