-- Lualine — Atom One Light statusline

local colors = {
	bg = "#fafafa",
	bg_alt = "#e5e5e6",
	fg = "#383a42",
	muted = "#686b77",
	blue = "#4078f2",
	green = "#50a14f",
	purple = "#a626a4",
	red = "#e45649",
	orange = "#c18401",
	cyan = "#0184bb",
	white = "#ffffff",
}

local atom_one_light = {
	normal = {
		a = { fg = colors.white, bg = colors.blue, gui = "bold" },
		b = { fg = colors.fg, bg = colors.bg_alt },
		c = { fg = colors.fg, bg = colors.bg },
	},

	insert = {
		a = { fg = colors.white, bg = colors.green, gui = "bold" },
	},

	visual = {
		a = { fg = colors.white, bg = colors.purple, gui = "bold" },
	},

	replace = {
		a = { fg = colors.white, bg = colors.red, gui = "bold" },
	},

	command = {
		a = { fg = colors.white, bg = colors.orange, gui = "bold" },
	},

	terminal = {
		a = { fg = colors.white, bg = colors.cyan, gui = "bold" },
	},

	inactive = {
		a = { fg = colors.muted, bg = colors.bg_alt },
		b = { fg = colors.muted, bg = colors.bg },
		c = { fg = colors.muted, bg = colors.bg },
	},
}

return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },

		opts = {
			options = {
				theme = atom_one_light,
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
