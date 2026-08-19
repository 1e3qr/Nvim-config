return {
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()

			-- Fix: LuaSnip can leave a snippet "session" active even after you
			-- move the cursor away from it without properly jumping/exiting
			-- (e.g. via hjkl, search, gg, mouse click). When that happens,
			-- luasnip.expand_or_jumpable() keeps returning true, so a later
			-- <Tab> press on an unrelated empty line jumps back to the stale
			-- placeholder instead of inserting a tab. This clears the session
			-- whenever we drop to Normal mode without an active jump.
			vim.api.nvim_create_autocmd("ModeChanged", {
				pattern = "*:n",
				callback = function()
					if
						luasnip.session
						and luasnip.session.current_nodes[vim.api.nvim_get_current_buf()]
						and not luasnip.session.jump_active
					then
						luasnip.unlink_current()
					end
				end,
			})

			-- Belt-and-suspenders: some InsertLeave paths don't fire a
			-- ModeChanged event the same way, so clear here too.
			vim.api.nvim_create_autocmd("InsertLeave", {
				callback = function()
					if
						luasnip.session
						and luasnip.session.current_nodes[vim.api.nvim_get_current_buf()]
						and not luasnip.session.jump_active
					then
						luasnip.unlink_current()
					end
				end,
			})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					-- Enter only confirms if an item has been explicitly selected.
					-- Otherwise it just inserts a normal newline.
					["<CR>"] = cmp.mapping(function(fallback)
						if cmp.visible() and cmp.get_selected_entry() then
							cmp.confirm({ select = false })
						else
							fallback()
						end
					end, { "i", "s" }),
					-- Tab only moves the highlight to the next item, it does NOT
					-- confirm/insert it. If nothing is completing, it jumps to
					-- the next snippet placeholder instead.
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					-- Shift-Tab: move highlight to previous item (no confirm),
					-- or jump to previous snippet placeholder.
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
}
