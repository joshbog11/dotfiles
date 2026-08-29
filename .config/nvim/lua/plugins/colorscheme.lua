return {
	{
		"RRethy/base16-nvim",
		lazy = false,
		priority = 1000,

		config = function()
			-- Tinty generates:
			-- ~/.config/nvim/colors/tinted.vim
			local ok = pcall(vim.cmd.colorscheme, "tinted")

			if not ok then
				vim.notify(
					"Tinty theme not found. Run `tinty sync` then `tinty apply <scheme>`.",
					vim.log.levels.WARN
				)
			end
		end,
	},
}
