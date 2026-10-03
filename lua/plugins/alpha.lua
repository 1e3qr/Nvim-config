return {
	{
		"goolord/alpha-nvim",
		dependencies = {
			"nvim-mini/mini.icons",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")
			local ansi_header = require("ansi_header")

			-- Header built from raw ANSI capture:
			--   ascii-image-converter <img> -C > ~/.config/nvim/ascii_tree_raw.txt
			-- Colors are applied after alpha renders (see AlphaReady autocmd below),
			-- since alpha's layout engine doesn't lay child elements out horizontally.
			local built = ansi_header.build_header(
				vim.fn.stdpath("config") .. "/ascii_tree_raw.txt"
			)
			dashboard.section.header.type = built.type
			dashboard.section.header.val = built.val
			dashboard.section.header.opts = built.opts

			-- Set menu
			dashboard.section.buttons.val = {
				dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
				dashboard.button("f", "󰈞  > Find file", ":cd . | Telescope find_files<CR>"),
				dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
				dashboard.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
				dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
			}

			-- Set footer
			--   NOTE: This is currently a feature in my fork of alpha-nvim (opened PR #21, will update snippet if added to main)
			--   To see test this yourself, add the function as a dependecy in packer and uncomment the footer lines
			--   ```init.lua
			--   return require('packer').startup(function()
			--       use 'wbthomason/packer.nvim'
			--       use {
			--           'goolord/alpha-nvim', branch = 'feature/startify-fortune',
			--           requires = {'BlakeJC94/alpha-nvim-fortune'},
			--           config = function() require("config.alpha") end
			--       }
			--   end)
			--   ```
			-- local fortune = require("alpha.fortune")
			-- dashboard.section.footer.val = fortune()

			-- Send config to alpha
			alpha.setup(dashboard.opts)

			-- Apply the ASCII art's colors once alpha has actually drawn the buffer
			vim.api.nvim_create_autocmd("User", {
				pattern = "AlphaReady",
				callback = function()
					ansi_header.apply_highlights(0)
				end,
			})

			-- Disable folding on alpha buffer
			vim.cmd([[
					autocmd FileType alpha setlocal nofoldenable
					]])
		end,
	},
}
