local kitty_default = {
	normal = {
		a = { fg = "#ffffff", bg = "#0d73cc", gui = "bold" },
		b = { fg = "#dddddd", bg = "#222222" },
		c = { fg = "#dddddd", bg = "#000000" },
	},

	insert = {
		a = { fg = "#000000", bg = "#23d18b", gui = "bold" },
		b = { fg = "#dddddd", bg = "#222222" },
		c = { fg = "#dddddd", bg = "#000000" },
	},

	visual = {
		a = { fg = "#ffffff", bg = "#7d57c2", gui = "bold" },
		b = { fg = "#dddddd", bg = "#222222" },
		c = { fg = "#dddddd", bg = "#000000" },
	},

	replace = {
		a = { fg = "#ffffff", bg = "#f2201f", gui = "bold" },
		b = { fg = "#dddddd", bg = "#222222" },
		c = { fg = "#dddddd", bg = "#000000" },
	},

	command = {
		a = { fg = "#000000", bg = "#e5e510", gui = "bold" },
		b = { fg = "#dddddd", bg = "#222222" },
		c = { fg = "#dddddd", bg = "#000000" },
	},

	inactive = {
		a = { fg = "#767676", bg = "#000000" },
		b = { fg = "#767676", bg = "#000000" },
		c = { fg = "#767676", bg = "#000000" },
	},
}

return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },

		opts = {
			options = {
				theme = kitty_default,
				globalstatus = true,

				disabled_filetypes = {
					statusline = { "dashboard", "alpha", "starter" },
				},

				component_separators = {
					left = "",
					right = "",
				},

				section_separators = {
					left = "",
					right = "",
				},
			},

			sections = {
				lualine_a = { "mode" },

				lualine_b = {
					"branch",
				},

				lualine_c = {
					{ "diagnostics" },
					{
						"filetype",
						icon_only = true,
						separator = "",
						padding = {
							left = 1,
							right = 0,
						},
					},
					{
						"filename",
						path = 1,
						symbols = {
							modified = "  ",
							readonly = " ",
							unnamed = "",
						},
					},
				},

				lualine_x = {
					{
						"diff",
						symbols = {
							added = " ",
							modified = " ",
							removed = " ",
						},
					},
				},

				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		},
	},
}
